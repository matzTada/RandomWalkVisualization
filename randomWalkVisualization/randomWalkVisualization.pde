//2017/5/29 
//Random Walk Visualization

int WIDTH_MAX = 101;
int DEPTH_MAX = 101;

int[][] passed  = new int [WIDTH_MAX][DEPTH_MAX]; //value corresponds numnber of passed Walk

int startPos = WIDTH_MAX / 2;
int currentPos = WIDTH_MAX / 2;

void setup() {
  size(800, 800, P3D);

  currentPos = startPos;
  for (int d = 0; d < DEPTH_MAX; d++) {
    passed[currentPos][d]++;
    currentPos += (random(0, 1) < 0) ? -1 : 1;
  }
}

void draw() {
  background(0);

  pushMatrix(); //first stage matrix
  {  //camera
    ambientLight(63, 31, 31);
    directionalLight(255, 255, 255, -1, 0, 0);
    pointLight(63, 127, 255, mouseX, mouseY, 200);
    spotLight(100, 100, 100, mouseX, mouseY, 200, 0, 0, -1, PI, 2);
    camera(mouseX, mouseY, 200, width/2.0, height/2.0, 0, 0, 1, 0);  //カメラを定義、マウスの位置でカメラの位置が変化する

    translate(width / 2, height / 2, -20);

    {
      pushMatrix();
      //translate(tempBox.x, tempBox.y); //positioning
      //box
      noFill();
      stroke(255, 100);
      //box(dim*0.7, dim*0.8, dim*0.1);        
      ////text
      //textSize(dim);
      //textMode(SHAPE);        
      //textAlign(CENTER, CENTER);
      //fill(255, 200);
      //text(loopCnt++%10, 0, 0);
      popMatrix();
    }

    popMatrix(); //first stage matrix
  }
}