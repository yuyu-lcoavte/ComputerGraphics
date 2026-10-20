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
    // 先把座標轉成整數，避免一直無法到終點
    float x = round(x1);
    float y = round(y1);
    float endX = round(x2);
    float endY = round(y2);

    // 計算 x、y 的距離
    float dx = abs(endX - x);
    float dy = abs(endY - y);

    // 判斷要往哪個方向走
    float sx = (endX >= x) ? 1 : -1;
    float sy = (endY >= y) ? 1 : -1;

    // 先畫起點
    drawPoint(x, y, color(0, 0, 0));

    if (dx >= dy) {
        // x 的變化比較大，以 x 為主
        float a = dy;
        float b = -dx;
        float d = a + b / 2;

        while (x != endX) {
            if (d <= 0) {
                // 走 E
                x += sx;
                d += a;
            } else {
                // 走斜的方向
                x += sx;
                y += sy;
                d += (a + b);
            }
            drawPoint(x, y, color(0, 0, 0));
        }

    } else {
        // y 的變化比較大，以 y 為主
        float a = dx;
        float b = -dy;
        float d = a + b / 2;

        while (y != endY) {
            if (d <= 0) {
                // 只移動 y
                y += sy;
                d += a;
            } else {
                // x、y 一起移動
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

    // 從 (0, R) 開始
    float px = 0;
    float py = R;

    // 初始判斷值
    float d = 1.25 - R;
    float incE = 3;
    float incSE = 5 - 2 * R;

    while (px <= py) {
        // 利用八個方向的對稱畫出圓
        drawPoint(cx + px, cy + py, color(0, 0, 0));
        drawPoint(cx - px, cy + py, color(0, 0, 0));
        drawPoint(cx + px, cy - py, color(0, 0, 0));
        drawPoint(cx - px, cy - py, color(0, 0, 0));

        drawPoint(cx + py, cy + px, color(0, 0, 0));
        drawPoint(cx - py, cy + px, color(0, 0, 0));
        drawPoint(cx + py, cy - px, color(0, 0, 0));
        drawPoint(cx - py, cy - px, color(0, 0, 0));

        if (d < 0) {
            // 選 E，只增加 px
            d += incE;
            incE += 2;
            incSE += 2;
            px++;
        } else {
            // 選 SE，px 增加、py 減少
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
    
    // 橢圓中心及兩個半徑
    float cx = x;
    float cy = y;
    float rx = r1;
    float ry = r2;

    // 從橢圓上方開始
    float px = 0;
    float py = ry;

    // 計算半徑平方
    float rx2 = rx * rx;
    float ry2 = ry * ry;

    // 判斷目前在哪個 Region
    float dx = 2 * ry2 * px;
    float dy = 2 * rx2 * py;

    // Region 1 的初始判斷值
    float d1 = ry2 - rx2 * ry + 0.25f * rx2;

    // Region 1：以 x 的移動為主
    while (dx < dy) {
        // 畫出四個對稱點
        drawPoint(cx + px, cy + py, color(0, 0, 0));
        drawPoint(cx - px, cy + py, color(0, 0, 0));
        drawPoint(cx + px, cy - py, color(0, 0, 0));
        drawPoint(cx - px, cy - py, color(0, 0, 0));

        if (d1 < 0) {
            // 選 E
            px++;
            dx += 2 * ry2;
            d1 += dx + ry2;
        } else {
            // 選 SE
            px++;
            py--;
            dx += 2 * ry2;
            dy -= 2 * rx2;
            d1 += dx - dy + ry2;
        }
    }

    // Region 2 的初始判斷值
    float d2 = ry2 * (px + 0.5f) * (px + 0.5f)
             + rx2 * (py - 1) * (py - 1)
             - rx2 * ry2;

    // Region 2：以 y 的移動為主
    while (py >= 0) {
        // 畫出四個對稱點
        drawPoint(cx + px, cy + py, color(0, 0, 0));
        drawPoint(cx - px, cy + py, color(0, 0, 0));
        drawPoint(cx + px, cy - py, color(0, 0, 0));
        drawPoint(cx - px, cy - py, color(0, 0, 0));

        if (d2 > 0) {
            // 選 S
            py--;
            dy -= 2 * rx2;
            d2 += rx2 - dy;
        } else {
            // 選 SE
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
    // 先算控制點之間的距離
    float d1 = sqrt(sq(p2.x - p1.x) + sq(p2.y - p1.y));
    float d2 = sqrt(sq(p3.x - p2.x) + sq(p3.y - p2.y));
    float d3 = sqrt(sq(p4.x - p3.x) + sq(p4.y - p3.y));

    float length = d1 + d2 + d3;

    // 根據距離決定取樣次數
    int steps = ceil(length * 3);

    for (int i = 0; i <= steps; i++) {
        // t 從 0 到 1
        float t = (float)i / steps;
        float u = 1 - t;

        // 計算四個權重
        float a = u * u * u;
        float b = 3 * u * u * t;
        float c = 3 * u * t * t;
        float d = t * t * t;

        // 計算曲線上的 x
        float px = a * p1.x + b * p2.x + c * p3.x + d * p4.x;

        // 計算曲線上的 y
        float py = a * p1.y + b * p2.y + c * p3.y + d * p4.y;

        // 把算出的點畫出來
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

    // 找出矩形的範圍
    int xMin = min(p1x, p2x);
    int xMax = max(p1x, p2x);
    int yMin = min(p1y, p2y);
    int yMax = max(p1y, p2y);

    // 把範圍內的點改成背景色
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
