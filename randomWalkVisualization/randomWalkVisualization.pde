//2017/5/29 
//Random Walk Visualization

void setup() {
  size(800, 800, P3D);
}

void draw() {
  background(0);

  pushMatrix();
  //camera
  ambientLight(63, 31, 31);
  directionalLight(255, 255, 255, -1, 0, 0);
  pointLight(63, 127, 255, mouseX, mouseY, 200);
  spotLight(100, 100, 100, mouseX, mouseY, 200, 0, 0, -1, PI, 2);
  camera(mouseX, mouseY, 200, width/2.0, height/2.0, 0, 0, 1, 0);  //カメラを定義、マウスの位置でカメラの位置が変化する

  translate(width / 2, height / 2, -20);

  pushMatrix();
  translate(tempBox.x, tempBox.y, tempBox.z);
  //box
  noFill();
  stroke(255, 100);
  box(dim*0.7, dim*0.8, dim*0.1);        
  ////text
  //textSize(dim);
  //textMode(SHAPE);        
  //textAlign(CENTER, CENTER);
  //fill(255, 200);
  //text(loopCnt++%10, 0, 0);
  popMatrix();

  popMatrix();
}