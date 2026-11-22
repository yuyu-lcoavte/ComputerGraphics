public class GameObject {
    Transform transform;
    Mesh mesh;
    String name;
    Shader shader;

    GameObject() {
        transform = new Transform();
    }

    GameObject(String fname) {
        transform = new Transform();
        setMesh(fname);
        String[] sn = fname.split("\\\\");
        name = sn[sn.length - 1].substring(0, sn[sn.length - 1].length() - 4);
        shader = new Shader(new DepthVertexShader(), new DepthFragmentShader());
    }

    void reset() {
        transform.position.setZero();
        transform.rotation.setZero();
        transform.scale.setOnes();
    }

    void setMesh(String fname) {
        mesh = new Mesh(fname);
    }

    void Draw() {
        Matrix4 MVP = main_camera.Matrix().mult(localToWorld());
        for (int i=0; i<mesh.triangles.size(); i++) {
            Triangle triangle = mesh.triangles.get(i);
            Vector3[] position = triangle.verts;
            Vector4[] gl_Position = shader.vertex.main(new Object[]{position}, new Object[]{MVP});
            Vector3[] s_Position = new Vector3[3];
            for (int j = 0; j<gl_Position.length; j++) {
                s_Position[j] = gl_Position[j].homogenized();
            }
            Vector3[] boundbox = findBoundBox(s_Position);
            float minX = map(min( max(boundbox[0].x, -1.0 ), 1.0), -1.0, 1.0, 0.0, renderer_size.z - renderer_size.x);
            float maxX = map(min( max(boundbox[1].x, -1.0 ), 1.0), -1.0, 1.0, 0.0, renderer_size.z - renderer_size.x);
            float minY = map(min( max(boundbox[0].y, -1.0 ), 1.0), -1.0, 1.0, 0.0, renderer_size.w - renderer_size.y);
            float maxY = map(min( max(boundbox[1].y, -1.0 ), 1.0), -1.0, 1.0, 0.0, renderer_size.w - renderer_size.y);
            
            for (int y = int(minY); y < maxY; y++) {
                for (int x = int(minX); x < maxX; x++) {
                    float rx=map(x, 0.0 , renderer_size.z - renderer_size.x, -1, 1);
                    float ry=map(y, 0.0, renderer_size.w - renderer_size.y, -1, 1);
                    if (!pnpoly(rx, ry, s_Position)) continue;
                    int index = y * int(renderer_size.z - renderer_size.x) + x;
                    
                    float z = getDepth(rx, ry, s_Position );
                    Vector4 c = shader.fragment.main(new Object[]{new Vector3(rx, ry, z)});
                    
                    if (GH_DEPTH[index] > z) {
                        GH_DEPTH[index] = z;
                        renderBuffer.pixels[index] = color(c.x * 255, c.y*255, c.z*255);
                    }
                }
            }
        }        
        update();
    }

    void update() {
    }

    
    void debugDraw() {
        Matrix4 model = localToWorld();
        Matrix4 MV = main_camera.worldView.mult(model);
        Matrix4 MVP = main_camera.Matrix().mult(model);
    
        for (int i = 0; i < mesh.triangles.size(); i++) {
            Triangle triangle = mesh.triangles.get(i);
    
            // 先在 Eye Space 進行 Backface Culling
            Vector3[] eyePos = new Vector3[3];
    
            for (int j = 0; j < 3; j++) {
                eyePos[j] = MV.mult(
                    triangle.verts[j].getVector4(1.0f)
                ).homogenized();
            }
    
            Vector3 A = eyePos[0];
            Vector3 B = eyePos[1];
            Vector3 C = eyePos[2];
    
            Vector3 AB = B.sub(A);
            Vector3 AC = C.sub(A);
            Vector3 N = Vector3.cross(AB, AC);
            Vector3 toCamera = A.mult(-1.0f);
    
            if (Vector3.dot(N, toCamera) <= 0) {
                continue;
            }
    
            // 轉換到 Clip Space，先保留 Vector4
            Vector4[] clipPos = new Vector4[3];
    
            for (int j = 0; j < 3; j++) {
                clipPos[j] = MVP.mult(
                    triangle.verts[j].getVector4(1.0f)
                );
            }
    
            // 對三角形的三條邊分別進行裁切
            for (int j = 0; j < 3; j++) {
                Vector4[] segment = {
                    clipPos[j],
                    clipPos[(j + 1) % 3]
                };
    
                // 如果整條線段不可見，就不繪製
                if (!clipLine(segment)) {
                    continue;
                }
    
                // 裁切完成後才能做 Perspective Divide
                Vector3 P1 = segment[0].homogenized();
                Vector3 P2 = segment[1].homogenized();
    
                // NDC 轉成螢幕座標
                float x1 = map(P1.x, -1, 1,
                               renderer_size.x, renderer_size.z);
                float y1 = map(P1.y, -1, 1,
                               renderer_size.y, renderer_size.w);
    
                float x2 = map(P2.x, -1, 1,
                               renderer_size.x, renderer_size.z);
                float y2 = map(P2.y, -1, 1,
                               renderer_size.y, renderer_size.w);
    
                CGLine(x1, y1, x2, y2);
            }
        }
    }


    String getGameObjectName() {
        return name;
    }

    Matrix4 localToWorld() {
        // TODO HW3
        // You need to calculate the model Matrix here.
        
        Matrix4 T = Matrix4.Trans(transform.position);
        Matrix4 Ry = Matrix4.RotY(transform.rotation.y);
        Matrix4 Rx = Matrix4.RotX(transform.rotation.x);
        Matrix4 Rz = Matrix4.RotZ(transform.rotation.z);
        Matrix4 S = Matrix4.Scale(transform.scale);
    
        return T.mult(Ry).mult(Rx).mult(Rz).mult(S);
    }

    Matrix4 worldToLocal() {
        return Matrix4.Scale(transform.scale.inv()).mult(Matrix4.RotZ(-transform.rotation.z))
                .mult(Matrix4.RotX(-transform.rotation.x)).mult(Matrix4.RotY(-transform.rotation.y))
                .mult(Matrix4.Trans(transform.position.mult(-1)));
    }

    Vector3 forward() {
        return (Matrix4.RotZ(transform.rotation.z).mult(Matrix4.RotX(transform.rotation.y))
                .mult(Matrix4.RotY(transform.rotation.x)).zAxis()).mult(-1);
    }
    
    float clipValue(Vector4 p, int plane) {
        switch (plane) {
            case 0: return p.w + p.x; // Left
            case 1: return p.w - p.x; // Right
            case 2: return p.w + p.y; // Bottom
            case 3: return p.w - p.y; // Top
            case 4: return p.z;       // Near
            case 5: return p.w - p.z; // Far
        }
        return -1;
    }

    Vector4 lerpClip(Vector4 A, Vector4 B, float t) {
        // 根據 t 計算線段 AB 上的點
        return new Vector4(
            A.x + t * (B.x - A.x),
            A.y + t * (B.y - A.y),
            A.z + t * (B.z - A.z),
            A.w + t * (B.w - A.w)
        );
    }

    boolean clipLine(Vector4[] segment) {
        Vector4 A = segment[0];
        Vector4 B = segment[1];
    
        // 保留線段的參數範圍
        float tEnter = 0.0f;
        float tExit = 1.0f;
    
        // 依序檢查六個裁切平面
        for (int i = 0; i < 6; i++) {
            float cA = clipValue(A, i);
            float cB = clipValue(B, i);
    
            // 兩端都在同一個平面的外側
            if (cA < 0 && cB < 0) {
                return false;
            }
    
            // 兩端都在內側，不需要裁切
            if (cA >= 0 && cB >= 0) {
                continue;
            }
    
            // 一端在內、一端在外，計算交點參數
            float t = cA / (cA - cB);
    
            if (cA < 0) {
                // A 在外側，更新進入位置
                tEnter = max(tEnter, t);
            } else {
                // B 在外側，更新離開位置
                tExit = min(tExit, t);
            }
    
            // 沒有可保留的線段
            if (tEnter > tExit) {
                return false;
            }
        }
    
        // 使用最後的參數求出裁切後的兩個端點
        segment[0] = lerpClip(A, B, tEnter);
        segment[1] = lerpClip(A, B, tExit);
    
        return true;
    }


}
