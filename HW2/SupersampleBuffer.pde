// 2x2 Super-Sampling Anti-Aliasing for the existing 2D canvas.
// Every pixel has four independent (color, depth) samples.
// The sample buffer is shared across all shapes within the frame.
public class SupersampleBuffer {
    final int samplesPerPixel = 4;
    final float[] sampleDX = {0.25f, 0.75f, 0.25f, 0.75f};
    final float[] sampleDY = {0.25f, 0.25f, 0.75f, 0.75f};

    int canvasX, canvasY, canvasW, canvasH;
    int[] sampleColor;
    float[] sampleDepth;

    SupersampleBuffer(int x, int y, int w, int h) {
        canvasX = x;
        canvasY = y;
        canvasW = w;
        canvasH = h;
        int count = w * h * samplesPerPixel;
        sampleColor = new int[count];
        sampleDepth = new float[count];
    }

    int sampleIndex(int x, int y, int s) {
        return ((y - canvasY) * canvasW + (x - canvasX)) * samplesPerPixel + s;
    }

    // Initialize each sample to the canvas color; clear depth for this frame.
    void beginFrame() {
        loadPixels();
        for (int y = canvasY; y < canvasY + canvasH; y++) {
            for (int x = canvasX; x < canvasX + canvasW; x++) {
                int base = pixels[y * width + x];
                for (int s = 0; s < samplesPerPixel; s++) {
                    int k = sampleIndex(x, y, s);
                    sampleColor[k] = base;
                    sampleDepth[k] = Float.POSITIVE_INFINITY;
                }
            }
        }
    }

    // All supplied Rectangle and Star vertices share one Z value, but
    // the depth test is still done separately for every subpixel sample.
    void rasterize(Vector3[] polygon, int fillColor, int edgeColor) {
        if (polygon == null || polygon.length < 3) return;

        Vector3[] bound = findBoundBox(polygon);
        int left = max(canvasX, floor(bound[0].x) - 2);
        int top = max(canvasY, floor(bound[0].y) - 2);
        int right = min(canvasX + canvasW - 1, ceil(bound[1].x) + 2);
        int bottom = min(canvasY + canvasH - 1, ceil(bound[1].y) + 2);
        float z = polygon[0].z;

        for (int y = top; y <= bottom; y++) {
            for (int x = left; x <= right; x++) {
                for (int s = 0; s < samplesPerPixel; s++) {
                    float sx = x + sampleDX[s];
                    float sy = y + sampleDY[s];
                    boolean covered = pnpoly(sx, sy, polygon);
                    boolean edge = nearEdge(sx, sy, polygon, 0.5f);
                    if (!covered && !edge) continue;

                    int k = sampleIndex(x, y, s);
                    // Smaller Z is nearer; equal Z follows the template's draw order.
                    if (z <= sampleDepth[k]) {
                        sampleDepth[k] = z;
                        sampleColor[k] = edge ? edgeColor : fillColor;
                    }
                }
            }
        }
    }

    // Subpixel coverage of the original 1-pixel CGLine outline.
    boolean nearEdge(float x, float y, Vector3[] polygon, float halfWidth) {
        float dLimit = halfWidth * halfWidth;
        for (int i = 0; i < polygon.length; i++) {
            Vector3 A = polygon[i];
            Vector3 B = polygon[(i + 1) % polygon.length];
            float vx = B.x - A.x, vy = B.y - A.y;
            float len2 = vx * vx + vy * vy;
            float t = 0;
            if (len2 > 0) {
                t = constrain(((x - A.x) * vx + (y - A.y) * vy) / len2, 0, 1);
            }
            float closestX = A.x + t * vx;
            float closestY = A.y + t * vy;
            float dx = x - closestX, dy = y - closestY;
            if (dx * dx + dy * dy <= dLimit) return true;
        }
        return false;
    }

    // Resolve four color samples into the normal pixels[] image.
    void resolve() {
        for (int y = canvasY; y < canvasY + canvasH; y++) {
            for (int x = canvasX; x < canvasX + canvasW; x++) {
                float r = 0, g = 0, b = 0;
                for (int s = 0; s < samplesPerPixel; s++) {
                    int c = sampleColor[sampleIndex(x, y, s)];
                    r += red(c);
                    g += green(c);
                    b += blue(c);
                }
                pixels[y * width + x] = color(r / 4.0f, g / 4.0f, b / 4.0f);
            }
        }
        updatePixels();
    }
}
