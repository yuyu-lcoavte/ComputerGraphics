import javax.swing.JFileChooser;
import javax.swing.filechooser.FileNameExtensionFilter;

public Vector4 renderer_size;
static public float GH_FOV = 45.0f;
static public float GH_NEAR_MIN = 1e-3f;
static public float GH_NEAR_MAX = 1e-1f;
static public float GH_FAR = 1000.0f;

public boolean debug = true;

public float[] GH_DEPTH;
public PImage renderBuffer;

Engine engine;
Camera main_camera;
Vector3 cam_position;
Vector3 lookat;

boolean moveW = false;
boolean moveS = false;
boolean moveA = false;
boolean moveD = false;
boolean moveQ = false;
boolean moveE = false;

void setup() {
    size(1000, 600);
    renderer_size = new Vector4(20, 50, 520, 550);
    cam_position = new Vector3(0, 0, -10);
    lookat = new Vector3(0, 0, 0);
    setDepthBuffer();
    main_camera = new Camera();
    engine = new Engine();

}

void setDepthBuffer(){
    renderBuffer = new PImage(int(renderer_size.z - renderer_size.x) , int(renderer_size.w - renderer_size.y));
    GH_DEPTH = new float[int(renderer_size.z - renderer_size.x) * int(renderer_size.w - renderer_size.y)];
    for(int i = 0 ; i < GH_DEPTH.length;i++){
        GH_DEPTH[i] = 1.0;
        renderBuffer.pixels[i] = color(1.0*250);
    }
}

void draw() {
    background(255);
    cameraControl();
    engine.run();
}

String selectFile() {
    JFileChooser fileChooser = new JFileChooser();
    fileChooser.setCurrentDirectory(new File("."));
    fileChooser.setFileSelectionMode(JFileChooser.FILES_ONLY);
    FileNameExtensionFilter filter = new FileNameExtensionFilter("Obj Files", "obj");
    fileChooser.setFileFilter(filter);

    int result = fileChooser.showOpenDialog(null);
    if (result == JFileChooser.APPROVE_OPTION) {
        String filePath = fileChooser.getSelectedFile().getAbsolutePath();
        return filePath;
    }
    return "";
}

void cameraControl(){
    // You can write your own camera control function here.
    // Use setPositionOrientation(Vector3 position,Vector3 lookat) to modify the ViewMatrix.
    // Hint : Use keyboard event and mouse click event to change the position of the camera.       
    // TODO HW3
    // 使用鍵盤控制相機移動
    float speed = 0.1f;

    float dx = 0;
    float dy = 0;
    float dz = 0;

    // 前後移動
    if (moveW) dz += 1;
    if (moveS) dz -= 1;

    // 左右移動（配合 Template 的 Mirror）
    if (moveA) dx += 1;
    if (moveD) dx -= 1;

    // 上下移動
    if (moveQ) dy += 1;
    if (moveE) dy -= 1;

    // 將按鍵轉換成移動向量
    Vector3 movement = new Vector3(dx, dy, dz);

    if (!movement.near_zero()) {
        // 避免同時按兩個方向時速度變快
        movement.normalize();
        movement = movement.mult(speed);

        // 相機與觀看目標一起移動
        cam_position = cam_position.add(movement);
        lookat = lookat.add(movement);
    }

    // 更新 View Matrix
    main_camera.setPositionOrientation(cam_position, lookat);

}


void keyPressed() {
    char k = Character.toLowerCase(key);

    if (k == 'w') moveW = true;
    if (k == 's') moveS = true;
    if (k == 'a') moveA = true;
    if (k == 'd') moveD = true;
    if (k == 'q') moveQ = true;
    if (k == 'e') moveE = true;
}

void keyReleased() {
    char k = Character.toLowerCase(key);

    if (k == 'w') moveW = false;
    if (k == 's') moveS = false;
    if (k == 'a') moveA = false;
    if (k == 'd') moveD = false;
    if (k == 'q') moveQ = false;
    if (k == 'e') moveE = false;
}
