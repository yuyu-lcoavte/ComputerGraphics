/**
 * Edge Filter
 * 
 * Apply a custom shader to the filter() function to affect the geometry drawn to the screen.
 * 
 * Press the mouse to turn the filter on and off.
 */
 
PShader edges;
boolean applyFilter = true;

void setup() {
  size(640, 360, P3D); //視窗大小+使用3D繪圖
  edges = loadShader("edges.glsl"); //載入邊緣偵測Shader 有白邊?顏色變成黑色(跟背景一樣的顏色)
  noStroke(); //沒有外框線
}

void draw() {
  background(0); //背景顏色 0->黑色
  lights(); //有光線可以看得出3D效果
  
  translate(width/2, height/2); //座標原本移到此視窗中間
  pushMatrix();//儲存目前座標
  rotateX(frameCount * 0.01);  //X軸旋轉 0.01控制旋轉速度
  rotateY(frameCount * 0.01);
  box(120);//方塊
  popMatrix();//恢復原本的座標
    
  if (applyFilter == true) {
    filter(edges); //因為在圓形建立前 所以圓形不會被干擾 //有白邊?顏色變成黑色(跟背景一樣的顏色)
  }
  
  // The sphere doesn't have the edge detection applied 
  // on it because it is drawn after filter() is called.
  rotateY(frameCount * 0.02);
  translate(150, 0); //將球向X軸正方向移動150
  sphere(40);//畫球 半徑40
}

void mousePressed() {
  applyFilter = !applyFilter;//滑鼠點擊
}
