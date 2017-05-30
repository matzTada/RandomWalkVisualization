//2017/5/29 
//Random Walk Visualization

int DEPTH_MAX = 100;
int WIDTH_MAX = DEPTH_MAX * 2;
int startPos = WIDTH_MAX / 2;
int currentPos = startPos;
int currentDepth = 0;
float dim;

int updatePastMillis = millis();

ArrayList<HashMap<Integer, Integer>> passed = new ArrayList<HashMap<Integer, Integer>>(); //value corresponds numnber of passed Walk
int active[] = new int[DEPTH_MAX];

//visualizing variables
int centerUB, centerLR, centerFB;
int pastMouseX, pastMouseY;
float mouseRotX, mouseRotY;
float viewRotX, viewRotY, viewRotZ;

int startFlag = 1;

void setup() {
  size(1600, 1600, P3D);

  //initialize core variables
  for (int d = 0; d < DEPTH_MAX; d++) {
    passed.add(new HashMap<Integer, Integer>());
    active[d] = WIDTH_MAX;
  }

  for (int d = 0; d < DEPTH_MAX * 10; d++) {
    randomWalk();
  }

  //initialize view variables
  pastMouseX = mouseX;
  pastMouseY = mouseY;

  //memomemo nice value
  mouseRotX=0.6675885; 
  mouseRotY=0.0824668; 
  centerFB=1050; 
  centerUB=30; 
  centerLR=0; 
  viewRotX=0.10000002; 
  viewRotY=-0.09999999; 
  viewRotZ=0.70000005;
}

void draw() {
  //calculating
  if (startFlag == 1) { 
    //if (millis() - updatePastMillis > 10) {
    //  updatePastMillis = millis();
    //  randomWalk();
    //}
    randomWalk();
  }

  //drawing functions  
  background(0);

  //2D histogram
  HashMap<Integer, Integer> histData = passed.get(currentDepth);

  histogram(histData, WIDTH_MAX * 3 / 8, WIDTH_MAX * 5 / 8, 0, 100, 0, 0, 400, 400, color(0, 255, 0));


  //3D random walk vision
  pushMatrix(); //first stage matrix
  { 
    //lighting
    ambientLight(63, 31, 31);
    directionalLight(255, 255, 255, -1, 0, 0);
    pointLight(63, 127, 255, mouseX, mouseY, 200);
    spotLight(100, 100, 100, mouseX, mouseY, 200, 0, 0, -1, PI, 2);
    //camera(mouseX, mouseY, 200, width/2.0, height/2.0, 0, 0, 1, 0);  

    //positioning variables
    translate(width/2 + centerLR, height/2 + centerUB, centerFB); //move axis by this specified length
    rotateX(mouseRotX);
    rotateY(mouseRotY);
    rotateX(viewRotX);
    rotateY(viewRotY);
    rotateZ(viewRotZ);  

    //boxes
    dim = (float)width / WIDTH_MAX / 4;

    for (int d = 0; d < DEPTH_MAX; d++) {
      for (int w = 0; w < WIDTH_MAX; w++) {
        if (passed.get(d).containsKey(w)) {
          int val = passed.get(d).get(w); 

          pushMatrix();
          {
            //color according to the number of passed walk
            if (active[d] == w && val == 1) {//first time
              fill(255, 0, 0);
              stroke(255, 0, 0, 100);
            } else if (active[d] == w && val > 1) {//second or later time
              fill(0, 0, 255);
              stroke(0, 0, 255, 100);
            } else {
              fill(255);
              stroke(255, 100);
            }
            translate(dim * (d - DEPTH_MAX/2), dim * (w - WIDTH_MAX/2), dim * val / 2); 
            box(dim, dim, dim * val);
          }
          popMatrix();
        }
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

void histogram(HashMap<Integer, Integer> vs, int vwMin, int vwMax, int vhMin, int vhMax, int viewX, int viewY, int viewWidth, int viewHeight, color c) {
  float strapWidth = (float)viewWidth/(vwMax - vwMin);
  println(strapWidth);
  fill(c);
  stroke(255, 150);
  for (int x = vwMin; x < vwMax; x++) { 
    if (vs.containsKey(x)) {
      int val = vs.get(x);

      rect(viewX + strapWidth * map(x, vwMin, vwMax, 0, vwMax - vwMin), viewY + viewHeight - map(val, vhMin, vhMax, 0, viewHeight), strapWidth, map(val, vhMin, vhMax, 0, viewHeight));
    }
  }
  noStroke();
  noFill();
}

void mouseDragged() {
  if (
    (0 < mouseX && mouseX < 4 * height/10 && height - 3 * height/10 < mouseY && mouseY < height) 
    || (width - height/5 < mouseX && mouseX < width)
    ) {
  } else {
    pastMouseX = mouseX;
    pastMouseY = mouseY;

    mouseRotX = -(pastMouseY - 0.5 * height) / (0.5 * height)  * PI;
    mouseRotY = (pastMouseX - 0.5 * width) / (0.5 * width)  * PI;

    println(""
      +" mouseRotX=" + mouseRotX +";"
      +" mouseRotY=" + mouseRotY +";"
      +" centerFB="+centerFB +";"
      +" centerUB="+centerUB +";"
      +" centerLR="+centerLR +";"
      +" viewRotX="+viewRotX +";"
      +" viewRotY="+viewRotY +";"
      +" viewRotZ="+viewRotZ +";"   
      +" width=" + width +";"
      +" height=" + height  +";");
  }
}

void keyPressed() {  
  switch(key) {
  case ' ': 
    startFlag = 1-startFlag;
    break;
    //view change
    //reset
  case 'R':
    centerFB = 0;
    centerUB = 0;
    centerLR = 0;
    viewRotX = 0;
    viewRotY = 0;
    viewRotZ = 0;
    break;
    //depth
  case 'd':
    centerFB+= 50;
    break;
  case 'D':
    centerFB-= 50;
    break;
    //rotation
  case 'x':
    viewRotX += 0.1;
    break;
  case 'X':
    viewRotX -= 0.1;
    break;
  case 'c':
    viewRotY += 0.1;
    break;
  case 'C':
    viewRotY -= 0.1;
    break;
  case 'z':
    viewRotZ += 0.1;
    break;
  case 'Z':
    viewRotZ -= 0.1;
    break;
    //case 'S':
    //  String saveImageFileName = MAIN_PROGRAM_PATH + "/tmp/" + savedSchedulingAlgorithmName + "_ts_" + wn3d_currentTS + "_" + year() + "_" + month() + "_" + day() + "_" +hour() + "_" +minute() + "_" +second() + ".jpg";
    //  println(saveImageFileName);
    //  save(saveImageFileName);
    //  break;
  case CODED:
    switch(keyCode) {
    case UP:
      centerUB -= 10;
      break;
    case DOWN:
      centerUB += 10;
      break;
    case LEFT:
      centerLR -= 10;
      break;
    case RIGHT:
      centerLR += 10;
      break;
    }
    break;
  default:
    break;
  }
  println(""
    +" mouseRotX=" + mouseRotX +";"
    +" mouseRotY=" + mouseRotY +";"
    +" centerFB="+centerFB +";"
    +" centerUB="+centerUB +";"
    +" centerLR="+centerLR +";"
    +" viewRotX="+viewRotX +";"
    +" viewRotY="+viewRotY +";"
    +" viewRotZ="+viewRotZ +";"   
    +" width=" + width +";"
    +" height=" + height  +";");
}