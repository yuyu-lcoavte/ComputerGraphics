public void CGLine(float x1, float y1, float x2, float y2) {
    // TODO HW1
    // You need to implement the "line algorithm" in this section.
    // You can use the function line(x1, y1, x2, y2); to verify the correct answer.
    // However, remember to comment out before you submit your homework.
    // Otherwise, you will receive a score of 0 for this part.
    // Utilize the function drawPoint(x, y, color) to apply color to the pixel at
    // coordinates (x, y).
    // For instance: drawPoint(114, 514, color(255, 0, 0)); signifies drawing a red
    // point at (114, 514).
    
    float x = x1;
    float y = y1;

    float endX = x2;
    float endY = y2;
    
    float dx = abs(endX - x);
    float dy = abs(endY - y);

    float sx = (endX >= x) ? 1 : -1;
    float sy = (endY >= y) ? 1 : -1;

    drawPoint(x, y, color(0, 0, 0));

    if (dx >= dy) {
        float a = dy;
        float b = -dx;
        float d = a + b / 2;

        while (x != endX) {
            if (d <= 0) {
                x += sx;
                d += a;
            } else {
                x += sx;
                y += sy;
                d += (a + b);
            }
            drawPoint(x, y, color(0, 0, 0));
        }

    } else {
        float a = dx;
        float b = -dy;
        float d = a + b / 2;

        while (y != endY) {
            if (d <= 0) {
                y += sy;
                d += a;
            } else {
                x += sx;
                y += sy;
                d += (a + b);
            }
            drawPoint(x, y, color(0, 0, 0));
        }
    }
    /*
     stroke(0);
     noFill();
     line(x1,y1,x2,y2);
    */
}

public void CGCircle(float x, float y, float r) {
    // TODO HW1
    // You need to implement the "circle algorithm" in this section.
    // You can use the function circle(x, y, r); to verify the correct answer.
    // However, remember to comment out before you submit your homework.
    // Otherwise, you will receive a score of 0 for this part.
    // Utilize the function drawPoint(x, y, color) to apply color to the pixel at
    // coordinates (x, y).
    
    // 圓心及半徑
    float cx = x;
    float cy = y;
    float R = r;

    // Midpoint Circle 初始位置
    float px = 0;
    float py = R;

    // 初始判斷值
    float d = 1.25 - R;
    float incE = 3;
    float incSE = 5 - 2 * R;

    while (px <= py) {
        // 畫出八個對稱點
        drawPoint(cx + px, cy + py, color(0, 0, 0));
        drawPoint(cx - px, cy + py, color(0, 0, 0));
        drawPoint(cx + px, cy - py, color(0, 0, 0));
        drawPoint(cx - px, cy - py, color(0, 0, 0));

        drawPoint(cx + py, cy + px, color(0, 0, 0));
        drawPoint(cx - py, cy + px, color(0, 0, 0));
        drawPoint(cx + py, cy - px, color(0, 0, 0));
        drawPoint(cx - py, cy - px, color(0, 0, 0));

        if (d < 0) {
            // 選擇 E
            d += incE;
            incE += 2;
            incSE += 2;
            px++;
        } else {
            // 選擇 SE
            d += incSE;
            incE += 2;
            incSE += 4;
            px++;
            py--;
        }
    }
    /*
    stroke(0);
    noFill();
    circle(x,y,r*2);
    */
}

public void CGEllipse(float x, float y, float r1, float r2) {
    // TODO HW1
    // You need to implement the "ellipse algorithm" in this section.
    // You can use the function ellipse(x, y, r1,r2); to verify the correct answer.
    // However, remember to comment out the function before you submit your homework.
    // Otherwise, you will receive a score of 0 for this part.
    // Utilize the function drawPoint(x, y, color) to apply color to the pixel at
    // coordinates (x, y).
    
    // 橢圓中心及水平、垂直半徑
    float cx = x;
    float cy = y;
    float rx = r1;
    float ry = r2;

    // Midpoint Ellipse 初始位置
    float px = 0;
    float py = ry;

    // 半徑平方
    float rx2 = rx * rx;
    float ry2 = ry * ry;

    // 初始增量
    float dx = 2 * ry2 * px;
    float dy = 2 * rx2 * py;

    // Region 1 初始判斷值
    float d1 = ry2 - rx2 * ry + 0.25f * rx2;

    // Region 1
    while (dx < dy) {
        // 畫出四個對稱點
        drawPoint(cx + px, cy + py, color(0, 0, 0));
        drawPoint(cx - px, cy + py, color(0, 0, 0));
        drawPoint(cx + px, cy - py, color(0, 0, 0));
        drawPoint(cx - px, cy - py, color(0, 0, 0));

        if (d1 < 0) {
            // 選擇 E
            px++;
            dx += 2 * ry2;
            d1 += dx + ry2;
        } else {
            // 選擇 SE
            px++;
            py--;
            dx += 2 * ry2;
            dy -= 2 * rx2;
            d1 += dx - dy + ry2;
        }
    }

    // Region 2 初始判斷值
    float d2 = ry2 * (px + 0.5f) * (px + 0.5f)
             + rx2 * (py - 1) * (py - 1)
             - rx2 * ry2;

    // Region 2
    while (py >= 0) {
        // 畫出四個對稱點
        drawPoint(cx + px, cy + py, color(0, 0, 0));
        drawPoint(cx - px, cy + py, color(0, 0, 0));
        drawPoint(cx + px, cy - py, color(0, 0, 0));
        drawPoint(cx - px, cy - py, color(0, 0, 0));

        if (d2 > 0) {
            // 選擇 S
            py--;
            dy -= 2 * rx2;
            d2 += rx2 - dy;
        } else {
            // 選擇 SE
            px++;
            py--;
            dx += 2 * ry2;
            dy -= 2 * rx2;
            d2 += dx - dy + rx2;
        }
    }
    /*
    stroke(0);
    noFill();
    ellipse(x,y,r1*2,r2*2);
    */

}

public void CGCurve(Vector3 p1, Vector3 p2, Vector3 p3, Vector3 p4) {
    // TODO HW1
    // You need to implement the "bezier curve algorithm" in this section.
    // You can use the function bezier(p1.x, p1.y, p2.x, p2.y, p3.x, p3.y, p4.x,
    // p4.y); to verify the correct answer.
    // However, remember to comment out before you submit your homework.
    // Otherwise, you will receive a score of 0 for this part.
    // Utilize the function drawPoint(x, y, color) to apply color to the pixel at
    // coordinates (x, y).
    // 計算四個控制點之間的總距離
    float d1 = sqrt(sq(p2.x - p1.x) + sq(p2.y - p1.y));
    float d2 = sqrt(sq(p3.x - p2.x) + sq(p3.y - p2.y));
    float d3 = sqrt(sq(p4.x - p3.x) + sq(p4.y - p3.y));
    
    float length = d1 + d2 + d3;

    // 設定取樣次數
    int steps = ceil(length * 3);

    for (int i = 0; i <= steps; i++) {

        // t 從 0 到 1
        float t = (float)i / steps;
        float u = 1 - t;

        // Bezier Curve 四個權重
        float a = u * u * u;
        float b = 3 * u * u * t;
        float c = 3 * u * t * t;
        float d = t * t * t;

        // 計算曲線上的 x 座標
        float px = a * p1.x
                 + b * p2.x
                 + c * p3.x
                 + d * p4.x;

        // 計算曲線上的 y 座標
        float py = a * p1.y
                 + b * p2.y
                 + c * p3.y
                 + d * p4.y;

        // 畫出曲線上的點
        drawPoint(px, py, color(0, 0, 0));
    }
    /*
    stroke(0);
    noFill();
    bezier(p1.x,p1.y,p2.x,p2.y,p3.x,p3.y,p4.x,p4.y);
    */
}

public void CGEraser(Vector3 p1, Vector3 p2) {
    // TODO HW1
    // You need to erase the scene in the area defined by points p1 and p2 in this
    // section.
    // p1 ------
    // |       |
    // |       |
    // ------ p2
    // The background color is color(250);
    // You can use the mouse wheel to change the eraser range.
    // Utilize the function drawPoint(x, y, color) to apply color to the pixel at
    // coordinates (x, y).
    // 取得兩個點的座標
    int p1x = round(p1.x);
    int p2x = round(p2.x);
    int p1y = round(p1.y);
    int p2y = round(p2.y);

    // 確定矩形的邊界
    int xMin = min(p1x, p2x);
    int xMax = max(p1x, p2x);
    int yMin = min(p1y, p2y);
    int yMax = max(p1y, p2y);

    // 擦除矩形範圍
    for (int i = xMin; i <= xMax; i++) {
        for (int j = yMin; j <= yMax; j++) {
            drawPoint(i, j, color(250));
        }
    }
}

public void drawPoint(float x, float y, color c) {
    stroke(c);
    point(x, y);
}

public float distance(Vector3 a, Vector3 b) {
    Vector3 c = a.sub(b);
    return sqrt(Vector3.dot(c, c));
}
