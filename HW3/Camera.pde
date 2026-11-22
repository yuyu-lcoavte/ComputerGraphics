public class Camera {
    Matrix4 projection = new Matrix4();
    Matrix4 worldView = new Matrix4();
    int wid;
    int hei;
    float near;
    float far;
    Transform transform;

    Camera() {
        wid = 256;
        hei = 256;
        worldView.makeIdentity();
        projection.makeIdentity();
        transform = new Transform();
    }

    Matrix4 inverseProjection() {
        Matrix4 invProjection = Matrix4.Zero();
        float a = projection.m[0];
        float b = projection.m[5];
        float c = projection.m[10];
        float d = projection.m[11];
        float e = projection.m[14];
        invProjection.m[0] = 1.0f / a;
        invProjection.m[5] = 1.0f / b;
        invProjection.m[11] = 1.0f / e;
        invProjection.m[14] = 1.0f / d;
        invProjection.m[15] = -c / (d * e);
        return invProjection;
    }

    Matrix4 Matrix() {
        return projection.mult(worldView);
    }

    void setSize(int w, int h, float n, float f) {
        wid = w;
        hei = h;
        near = n;
        far = f;
        
        // TODO HW3
        // This function takes four parameters, which are 
        // the width of the screen, the height of the screen
        // the near plane and the far plane of the camera.
        // Where GH_FOV has been declared as a global variable.
        // Finally, pass the result into projection matrix.

        // 計算水平視角的一半，並轉成弧度
        float theta = radians(GH_FOV * 0.5f);
        float tanTheta = tan(theta);
    
        // 畫面的寬高比
        float AR = (float) w / h;
    
        // 建立 Perspective Projection Matrix
        projection = Matrix4.Zero();
    
        projection.m[0] = 1.0f;
        projection.m[5] = AR;
    
        // 將深度對應到 0 ~ 1
        projection.m[10] = (f / (f - n)) * tanTheta;
        projection.m[11] = -(n * f / (f - n)) * tanTheta;
    
        // 用於 Perspective Divide
        projection.m[14] = tanTheta;

    }

    void setPositionOrientation(Vector3 pos, float rotX, float rotY) {

    }

    void setPositionOrientation(Vector3 pos, Vector3 lookat) {
        // TODO HW3
        // This function takes two parameters, which are the position of the camera and
        // the point the camera is looking at.
        // We uses topVector = (0,1,0) to calculate the eye matrix.
        // Finally, pass the result into worldView matrix.

        // 計算相機的觀看方向
        Vector3 V3 = lookat.sub(pos);
        if (V3.near_zero()) return;
        V3.normalize();
    
        // 使用 Top Vector 建立相機的 X、Y 軸
        Vector3 top = new Vector3(0, 1, 0);
        Vector3 V1 = Vector3.cross(top, V3);
    
        // 避免觀看方向與 Top Vector 平行
        if (V1.near_zero()) {
            top = new Vector3(0, 0, 1);
            V1 = Vector3.cross(top, V3);
        }
        V1.normalize();
    
        Vector3 V2 = Vector3.cross(V3, V1);
        V2.normalize();
    
        // 使用三個方向向量建立 GRM
        Matrix4 GRM = Matrix4.Identity();
    
        GRM.m[0] = V1.x;
        GRM.m[1] = V1.y;
        GRM.m[2] = V1.z;
    
        GRM.m[4] = V2.x;
        GRM.m[5] = V2.y;
        GRM.m[6] = V2.z;
    
        GRM.m[8] = V3.x;
        GRM.m[9] = V3.y;
        GRM.m[10] = V3.z;
    
        // 將相機位置移動到原點
        Matrix4 T = Matrix4.Trans(pos.mult(-1));
    
        // Eye Matrix = Mirror * GRM * Translation
        worldView = Matrix4.Mirror().mult(GRM).mult(T);
    }
}
