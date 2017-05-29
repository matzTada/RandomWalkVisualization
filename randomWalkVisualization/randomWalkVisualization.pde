//2017/5/29 
//Random Walk Visualization

int DEPTH_MAX = 100;
int WIDTH_MAX = DEPTH_MAX * 2;
int startPos = WIDTH_MAX / 2;
int currentPos = startPos;
int currentDepth = 0;
float dim;

int updatePastMillis = millis();

//int[][] passed  = new int [WIDTH_MAX][DEPTH_MAX]; //value corresponds numnber of passed Walk
ArrayList<HashMap<Integer, Integer>> passed = new ArrayList<HashMap<Integer, Integer>>(); 
int active[] = new int[DEPTH_MAX];

void setup() {
  size(1600, 1600, P3D);

  for (int d = 0; d < DEPTH_MAX; d++) {
    passed.add(new HashMap<Integer, Integer>()); //initialize
    active[d] = WIDTH_MAX;
  }

  //for (int num = 0; num < 500; num++) {
  //  randomWalk();
  //}

  //for (int w = 0; w < WIDTH_MAX; w++) if (passed.get(DEPTH_MAX-1).containsKey(w)) print(passed.get(DEPTH_MAX-1).get(w)+ " "); 
  //println("");
}

void draw() {
  //if (millis() - updatePastMillis > 10) {
  //  updatePastMillis = millis();
  //  randomWalk();
  //}
  randomWalk();

  //drawing functions  
  background(0);

  pushMatrix(); //first stage matrix
  {  //camera
    ambientLight(63, 31, 31);
    directionalLight(255, 255, 255, -1, 0, 0);
    pointLight(63, 127, 255, mouseX, mouseY, 200);
    spotLight(100, 100, 100, mouseX, mouseY, 200, 0, 0, -1, PI, 2);
    camera(mouseX, mouseY, 200, width/2.0, height/2.0, 0, 0, 1, 0);  //カメラを定義、マウスの位置でカメラの位置が変化する

    translate(width / 2, height / 2, -20);

    ////small 3D axis
    //pushMatrix();
    //strokeWeight(0.005 * height);
    //stroke(255, 0, 0);  
    //line(0, 0, 0, width/10, 0, 0);
    //stroke(0, 255, 0);
    //line(0, 0, 0, 0, width/10, 0);
    //stroke(0, 0, 255);
    //line(0, 0, 0, 0, 0, width/10);

    //textSize(width/30);
    //text("X", width/10, 0, 0);
    //text("Y", 0, width/10, 0);
    //text("Z", 0, 0, width/10);
    //popMatrix();

    //boxes
    dim = (float)width / WIDTH_MAX / 10;
    //println(dim);

    for (int d = 0; d < DEPTH_MAX; d++) {
      for (int w = 0; w < WIDTH_MAX; w++) {
        if (!passed.get(d).containsKey(w)) continue;
        int val = passed.get(d).get(w); 
        pushMatrix();

        if (active[d] == w) {
          if (val == 1) { //first time
            fill(255, 0, 0);
            stroke(255, 0, 0, 100);
          } else {//second or later time
            fill(0, 0, 255);
            stroke(0, 0, 255, 100);
          }
        } else {
          fill(255);
          stroke(255, 100);
        }

        translate(
          map(d * dim, 0, DEPTH_MAX * dim, -WIDTH_MAX/2 * dim, WIDTH_MAX/2 * dim)
          //d*dim
          , 
          map(w * dim, 0, WIDTH_MAX * dim, -WIDTH_MAX/2 * dim, WIDTH_MAX/2 * dim)
          //w*dim
          , 
          dim * val / 2
          ); //positioning
        box(
          dim
          , 
          dim
          , 
          dim * val
          );        
        popMatrix();
      }
    }

    popMatrix(); //first stage matrix
  }

  //println(frameRate);
}

void randomWalk() {
  int pastVal = (passed.get(currentDepth).containsKey(currentPos)) ? (pastVal = passed.get(currentDepth).get(currentPos)) : 0;
  passed.get(currentDepth).put(currentPos, pastVal + 1);
  currentPos += (random(0, 1) < 0.5) ? -1 : 1;
  currentDepth++;
  if (currentDepth >= DEPTH_MAX) {
    currentPos = startPos;
    currentDepth = 0;
    for (int d = 0; d < DEPTH_MAX; d++) active[d] = WIDTH_MAX;
  }
  active[currentDepth] = currentPos;
}

void keyPressed() {
  switch(key) {
  case ' ': 
    randomWalk();
    break;
  default: 
    break;
  }
}