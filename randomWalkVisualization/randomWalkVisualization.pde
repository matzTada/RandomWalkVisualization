//2017/5/29 
//Random Walk Visualization

int DEPTH_MAX = 100;
int WIDTH_MAX = DEPTH_MAX * 2 + 1;
int startPos = WIDTH_MAX / 2;
int currentPos;
float dim;


//int[][] passed  = new int [WIDTH_MAX][DEPTH_MAX]; //value corresponds numnber of passed Walk
ArrayList<HashMap<Integer, Integer>> passed = new ArrayList<HashMap<Integer, Integer>>(); 

void setup() {
  size(1600, 1600, P3D);

  for (int d = 0; d < DEPTH_MAX; d++) passed.add(new HashMap<Integer, Integer>()); //initialize

  for (int num = 0; num < 300; num++) {
    currentPos = startPos;
    for (int d = 0; d < DEPTH_MAX; d++) {
      //passed[currentPos][d]++;
      int pastVal = 0;
      if (passed.get(d).containsKey(currentPos)) pastVal = passed.get(d).get(currentPos);
      passed.get(d).put(currentPos, pastVal + 1);
      currentPos += (random(0, 1) < 0.5) ? -1 : 1;
    }
  }

  //for (int w = 0; w < WIDTH_MAX; w++) if (passed.get(DEPTH_MAX-1).containsKey(w)) print(passed.get(DEPTH_MAX-1).get(w)+ " "); 
  //println("");
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

    translate(width / 2, height / 2, -200);

    //small 3D axis
    pushMatrix();
    strokeWeight(0.005 * height);
    stroke(255, 0, 0);  
    line(0, 0, 0, width/10, 0, 0);
    stroke(0, 255, 0);
    line(0, 0, 0, 0, width/10, 0);
    stroke(0, 0, 255);
    line(0, 0, 0, 0, 0, width/10);

    textSize(width/30);
    text("X", width/10, 0, 0);
    text("Y", 0, width/10, 0);
    text("Z", 0, 0, width/10);
    popMatrix();

    //boxes
    fill(255);
    stroke(255, 100);
    dim = (float)height / WIDTH_MAX / 6;

    for (int d = 0; d < DEPTH_MAX; d++) {
      for (int w = 0; w < WIDTH_MAX; w++) {
        if (!passed.get(d).containsKey(w)) continue;
        int val = passed.get(d).get(w); 
        pushMatrix();

        translate(
          map(d, 0, DEPTH_MAX, 0, height/6)
          , 
          map(w, 0, WIDTH_MAX, -height/6, height/6)
          , 
          dim * val
          ); //positioning
        box(
          dim*0.7
          , 
          dim*0.7
          , 
          dim*0.7 * val
          );        
        popMatrix();
      }
    }

    popMatrix(); //first stage matrix
  }
}