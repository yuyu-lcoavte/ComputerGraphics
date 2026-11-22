public void CGLine(float x1, float y1, float x2, float y2) {
    stroke(0);
    line(x1, y1, x2, y2);
}

public boolean outOfBoundary(float x, float y) {
    if (x < 0 || x >= width || y < 0 || y >= height)
        return true;
    return false;
}

public void drawPoint(float x, float y, color c) {
    int index = (int) y * width + (int) x;
    if (outOfBoundary(x, y))
        return;
    pixels[index] = c;
}

public float distance(Vector3 a, Vector3 b) {
    Vector3 c = a.sub(b);
    return sqrt(Vector3.dot(c, c));
}

boolean pnpoly(float x, float y, Vector3[] vertexes) {
    // TODO HW2
    // You need to check the coordinate p(x,v) if inside the vertexes.

    if (vertexes == null || vertexes.length < 3) {
        return false;
    }

    int count = 0;
    int n = vertexes.length;

    for (int i = 0; i < n; i++) {
        int j = (i + 1) % n;

        float xi = vertexes[i].x;
        float yi = vertexes[i].y;
        float xj = vertexes[j].x;
        float yj = vertexes[j].y;

        if ((yi > y) != (yj > y)) {
            float crossX = xi + (y - yi) * (xj - xi) / (yj - yi);

            if (x < crossX) {
                count++;
            }
        }
    }

    if (count % 2 == 1) {
        return true;
    }

    return false;
}

public Vector3[] findBoundBox(Vector3[] v) {
    
    
    // TODO HW2 
    // You need to find the bounding box of the vertices v.
    // r1 -------
    //   |   /\  |
    //   |  /  \ |
    //   | /____\|
    //    ------- r2

    Vector3 recordminV = new Vector3(0);
    Vector3 recordmaxV = new Vector3(999);
    
    recordminV.x = v[0].x;
    recordminV.y = v[0].y;

    recordmaxV.x = v[0].x;
    recordmaxV.y = v[0].y;

    for (int i = 1; i < v.length; i++) {
        recordminV.x = min(recordminV.x, v[i].x);
        recordmaxV.x = max(recordmaxV.x, v[i].x);

        recordminV.y = min(recordminV.y, v[i].y);
        recordmaxV.y = max(recordmaxV.y, v[i].y);
    }
    
    Vector3[] result = { recordminV, recordmaxV };
    return result;

}

public Vector3[] Sutherland_Hodgman_algorithm(Vector3[] points, Vector3[] boundary) {
    ArrayList<Vector3> input = new ArrayList<Vector3>();
    ArrayList<Vector3> output = new ArrayList<Vector3>();
    for (int i = 0; i < points.length; i += 1) {
        input.add(points[i]);
    }

    // TODO HW2
    // You need to implement the Sutherland Hodgman Algorithm in this section.
    // The function you pass 2 parameter. One is the vertexes of the shape "points".
    // And the other is the vertices of the "boundary".
    // The output is the vertices of the polygon.
    for (int i = 0; i < boundary.length; i++) {

        output = new ArrayList<Vector3>();

        if (input.size() == 0) {
            break;
        }

        Vector3 A = boundary[i];
        Vector3 B = boundary[(i + 1) % boundary.length];

        for (int j = 0; j < input.size(); j++) {

            Vector3 S = input.get(j);
            Vector3 P = input.get((j + 1) % input.size());

            float dS = (B.x - A.x) * (S.y - A.y)
                     - (B.y - A.y) * (S.x - A.x);

            float dP = (B.x - A.x) * (P.y - A.y)
                     - (B.y - A.y) * (P.x - A.x);

            boolean insideS = dS <= 0;
            boolean insideP = dP <= 0;

            if (insideS && insideP) {
                // Inside -> Inside
                output.add(P);
            }
            else if (insideS && !insideP) {
                // Inside -> Outside
                float t = dS / (dS - dP);

                Vector3 I = new Vector3(
                    S.x + t * (P.x - S.x),
                    S.y + t * (P.y - S.y),
                    S.z + t * (P.z - S.z)
                );

                output.add(I);
            }
            else if (!insideS && insideP) {
                // Outside -> Inside
                float t = dS / (dS - dP);

                Vector3 I = new Vector3(
                    S.x + t * (P.x - S.x),
                    S.y + t * (P.y - S.y),
                    S.z + t * (P.z - S.z)
                );

                output.add(I);
                output.add(P);
            }
        }

        input = output;
    }

    output = input;

    Vector3[] result = new Vector3[output.size()];
    for (int i = 0; i < result.length; i += 1) {
        result[i] = output.get(i);
    }
    return result;
}

public float getDepth(float x, float y, Vector3[] vertex) {
    // TODO HW3
    // You need to calculate the depth (z) in the triangle (vertex) based on the
    // positions x and y. and return the z value;

    // 利用三角形的平面方程式計算像素深度

    Vector3 A = vertex[0];
    Vector3 B = vertex[1];
    Vector3 C = vertex[2];

    // 建立兩個邊向量
    Vector3 AB = B.sub(A);
    Vector3 AC = C.sub(A);

    // 計算平面的法向量
    Vector3 N = Vector3.cross(AB, AC);

    // 由平面方程式求出目前像素的 Z
    float z = A.z - (N.x * (x - A.x)
                    + N.y * (y - A.y)) / N.z;

    return z;
}

float[] barycentric(Vector3 P, Vector4[] verts) {

    Vector3 A = verts[0].homogenized();
    Vector3 B = verts[1].homogenized();
    Vector3 C = verts[2].homogenized();

    // TODO HW4
    // Calculate the barycentric coordinates of point P in the triangle verts using
    // the barycentric coordinate system.

    float[] result = { 0.0, 0.0, 0.0 };

    return result;
}
