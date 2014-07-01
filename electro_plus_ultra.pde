boolean[] downKeys = new boolean[256];
int displayMode = 1; //0 no niceties, 1 default, 2 - no charges drawn, 3 - gunship mode, 4 - equipotentials drawn, 5 - field dirn flipbook (res>5)


//setup values for nice field/potential backgrounds
int defaultResolution = 4;
int defaultEPResolution = 2;
int slowFactor = 1; //set to 1 for 'reasonably fast' computer, 2 for slower machines
int resolution = defaultResolution;
int divisionsX;
int divisionsY;
ChargeBox boxArray[][];

//set some physical constants here
float balloonMass = 10;
float balloonDefaultWidth = 20;
int chargeMass = 1;
float fieldConstantRadial = 0.40;   //1 is strong enough to provoke very strong repulsion during rapid fire. 0.5 is good.
float fieldConstantUniform = 4000.00;  //4000 works pretty well, 7000 is a bit strong!

//declare windows and arenas
Arena mainArena;
Windough arenaWindough;
Windough scoreWindough;
Windough equipmentWindough;

//declare charge counting variables
int totalNeg;
int totalPos;
int totalCharges = 0; //variable to store the total NUMBER of movable charges


int chargeDiff;
int chargeDiffVert;

float voltageUseful;
float voltageVertical;
float eFieldX;
float eFieldY;
float eFieldUniformX;
float eFieldUniformY;

color posM_col = color(255, 80, 180, 255);
color negM_col = color(0, 255, 255, 255);
color posF_col = color(255,0,0,255);
color negF_col = color(0,0,255,255);



//idea from Brad: as a launch option - clump several charges

Cannon jamesCannon;
int shotCounter; //'spacer' to prevent too rapid a firing rate.
int shotDelay; 
float aimPointX;
float aimPointY;
float aimPointMagSq;

float ejectionThreshold = 170; 
int ejectionMax = 3;
float ejectionDamping = 0.3;
float capacitance = 100;
int numBalloons = 7;

Plate plate_L;
Plate plate_R;
Plate plate_T;
Plate plate_B;
Plate plateArray[] = new Plate[4];
int plateSquareWidth = 5;


Balloon balloonList[];
ArrayList chargeList;

PFont strad48;
PFont strad16;

void setup() {
  size(800,800);
  frameRate(24);
  shotDelay = 5;
  mainArena = new Arena(50,50,400,400,100);

  
  divisionsX = mainArena.arenaWidth/resolution;
  divisionsY = mainArena.arenaHeight/resolution;
  boxArray = new ChargeBox[divisionsX][divisionsY];
  


  balloonList = new Balloon[numBalloons];
  for (int i = 0; i < balloonList.length; i++) {
    balloonList[i] = new Balloon(random(mainArena.arenaWidth),random(mainArena.arenaHeight),5, balloonMass);
  }
  
  chargeList = new ArrayList();

  plate_L = new Plate(-25,0,25,mainArena.arenaHeight,100,100,100,100,0);
  plate_R = new Plate(mainArena.arenaWidth,0,25,mainArena.arenaHeight,100,100,100,100,1);
  plate_T = new Plate(0,-25, mainArena.arenaWidth,25,0,10,0,10,0);
  plate_B = new Plate(0,mainArena.arenaHeight, mainArena.arenaWidth,25,0,10,0,10,0);
  plateArray[0] = plate_L;
  plateArray[1] = plate_R;
  plateArray[2] = plate_T;
  plateArray[3] = plate_B;

  jamesCannon = new Cannon();
    
  for (int i = 0; i < plateArray.length; i++) {
    totalCharges = totalCharges + plateArray[i].charges;
  }
  

  
  strad48 = loadFont("Amstrad-CPC464-48.vlw");
  strad16 = loadFont("Amstrad-CPC464-16.vlw");


  
  
  
  initialiseScores();

  
  arenaWindough = new Windough(480,480,450,450,color(0,0,0),color(posM_col));
  scoreWindough = new Windough(280,480,250,450,color(0,0,0),color(negM_col));
  equipmentWindough = new Windough(50,100,20,70,color(255,255,0),color(0,0,0));

}

void draw() {
  pushMatrix();
  translate(50,50);
//UPDATES
  
  for(int i = 0; i < divisionsX; i++){
    for(int j = 0; j <divisionsY; j++ ){
      boxArray[i][j] = new ChargeBox(resolution*i, resolution*j);
    }
  }
  
  //update the electric field due to the plates
  
  chargeDiff = plate_R.charge - plate_L.charge;
  chargeDiffVert = plate_B.charge - plate_T.charge;
  voltageUseful = 1.*round(1000*chargeDiff/capacitance)/1000;
  voltageVertical = 1.*chargeDiffVert/capacitance;
    
  eFieldUniformX = voltageUseful/(plate_R.xPos - (plate_L.xPos + plate_L.plateWidth));

  eFieldUniformY = voltageVertical/(plate_B.yPos - (plate_T.yPos + plate_T.plateHeight));
  
  
  //determine accelerations of every object
  chargeAccn(); 
  balloonAccn();
  
   if(chargeList.size() != 0){ //if there are any charges in the arena
    for (int i = 0; i < chargeList.size(); i++) { //update all charges
      Charge charge = (Charge) chargeList.get(i);
      charge.move(); //move charges
    }
  }
  
  if(balloonList.length != 0){
   for (int i = 0; i < balloonList.length; i++) { //update all balloons
       balloonList[i].move();
   }
  }
   plateCollisionCheck();
   chargeCollisionCheck(); //check if charge has collided with a plate or balloon

  
  //DISPLAY THINGS

  background(0);
  
  
  //basic visual parameters
  
  if(displayMode == 3){    
    posM_col = color(255);
    negM_col = color(1,1,1,200);
    posF_col = color(200);
    negF_col = color(50,50,50,200);
   } else {
    posM_col = color(255, 80, 180, 255);
    negM_col = color(0, 255, 255, 255);
    posF_col = color(255,0,0,255);
    negF_col = color(0,0,255,255);
  }
  
  pushMatrix();
    translate(-plate_L.plateWidth -arenaWindough.borderWidth,-plate_T.plateHeight -arenaWindough.borderWidth);
    arenaWindough.display();
    displayInstructions();
    
    translate(arenaWindough.outWidth + 20, 0);
    scoreWindough.display();
    displayScores();
    displayScience();
  popMatrix();
  fill(255);
  cursor(CROSS);
  

  
  //display neat potential background
  
    if(displayMode != 5||displayMode != 0){  
    for (int i = 0; i <divisionsX; i++){
    for (int j = 0; j <divisionsY; j++){
    boxArray[i][j].updatePotential();
    boxArray[i][j].display();
    }
  } 
  }
  
    if(displayMode == 5 || displayMode ==6){  
    for (int i = 0; i <divisionsX; i++){
    for (int j = 0; j <divisionsY; j++){
    boxArray[i][j].updateField();
    boxArray[i][j].displayField();
    }
  } 
  }
      
  //display charges
    if(displayMode != 2 && displayMode != 3){
    for(int i = 0; i < chargeList.size(); i++) {
    Charge charge = (Charge) chargeList.get(i);
    charge.display();
    }
    }

  
  //display balloons
  if(displayMode != 2 && displayMode !=3){
  for (int i = 0; i < balloonList.length; i++) { //update all balloons
        balloonList[i].display();
  }   
  }

  
  //display something about the voltage
  int dropShadowOffset = 3;
    textFont(strad48);
  textAlign(CENTER);
  
  if(voltageUseful < 0){
    fill(1,1,1,50);
    text(str(1.*voltageUseful),dropShadowOffset + mainArena.arenaWidth/2,dropShadowOffset + mainArena.arenaHeight/2);
  } else
  if(chargeDiff > 0){
    fill(1,1,1,50);
    text("+"+str((voltageUseful)),dropShadowOffset + mainArena.arenaWidth/2, dropShadowOffset + mainArena.arenaHeight/2);
  } else {
    fill(1,1,1,50);
    text("0.00",dropShadowOffset + mainArena.arenaWidth/2, dropShadowOffset + mainArena.arenaHeight/2);
  }
  
  if(voltageUseful > targetVoltage - tolerance*targetVoltage && 
  voltageUseful < targetVoltage + tolerance*targetVoltage){
    float increment = (1/frameRate);
    //println(increment);
    timeAtTarget = 1.*round(100*(timeAtTarget + increment))/100;
    if(timeAtTarget > highTimeAtTarget){
      highTimeAtTarget = timeAtTarget;
    }
    fill(0,255,0);
  }else{
    timeAtTarget = 0;
    fill(255);
  }
  
  if(voltageUseful < 0){
    text(str(1.*voltageUseful),mainArena.arenaWidth/2, mainArena.arenaHeight/2);
  } else
  if(chargeDiff > 0){
    text("+"+str((voltageUseful)),mainArena.arenaWidth/2, mainArena.arenaHeight/2);
  } else {
    text("0.00",mainArena.arenaWidth/2, mainArena.arenaHeight/2);
  }


//CANNON-RELATED
  
  //increment shot timer (keeps firing rate manageable)
  shotCounter++;
  if(shotCounter > 2*shotDelay){
    shotCounter = 0;
  }
  
  //update number of charges on each plate, display accordingly
  for (int i = 0; i < plateArray.length; i++) { //update charge and related numbers on all wall
    plateArray[i].update();
    plateArray[i].display();
  }
  

  //change cannon mode between positive, negative    
  if(downKeys[97] || downKeys[65] && jamesCannon.mode != 1){
     jamesCannon.setMode(1);
   } else
   if(downKeys[100] || downKeys[68] && jamesCannon.mode != -1){
      jamesCannon.setMode(-1);
   }
//define and constrain 'aimPoint' for cannon display and shot trajectory
 aimPointX = (jamesCannon.xPos + 0.5*jamesCannon.cannonWidth  + mainArena.xPos - mouseX)/(5 - 4*(abs(jamesCannon.xPos + 0.5*jamesCannon.cannonWidth +mainArena.xPos-mouseX)/mainArena.arenaWidth));
 aimPointY = (jamesCannon.yPos + mainArena.yPos - mouseY)/(5 - 4*(abs(jamesCannon.yPos + mainArena.yPos - mouseY)/mainArena.arenaHeight));
 aimPointX = constrain(aimPointX, -200, 200);
 aimPointY = constrain(aimPointY, -200, 200);

 aimPointMagSq = sq(aimPointX) + sq(aimPointY);
 shotEnergy = (1.*round(1000*(0.5*chargeMass*aimPointMagSq/4000))/1000);

  //update cannon position and display
  jamesCannon.move();
  jamesCannon.display();

  //fire cannon if certain conditions are met
  if(downKeys[32]){

      if(jamesCannon.mode == -1 && plate_R.numNeg_M > 0 && chargeList.size() < 20 && shotCounter > shotDelay){
      Charge freshCharge = new Charge(mainArena.arenaWidth - 2, jamesCannon.yPos, jamesCannon.mode,-aimPointX,-aimPointY, chargeMass,true);
      chargeList.add(freshCharge);
      plate_R.numNeg_M--;
      shotCounter = 0;
      }
      if(jamesCannon.mode == 1 && plate_R.numPos_M > 0 && chargeList.size() < 20 && shotCounter > shotDelay){
      Charge freshCharge = new Charge(mainArena.arenaWidth -  2, jamesCannon.yPos, jamesCannon.mode,-aimPointX,-aimPointY, chargeMass,true);
      chargeList.add(freshCharge);
      plate_R.numPos_M--;
      shotCounter = 0;
      }
    }
    

    //myWindough.display();
    popMatrix();
    updateParams();
    updateScores();
      writeScores();
    changeDisplay();
}

void changeDisplay() {
     if(downKeys[91] && slowFactor == 1){
        slowFactor = 2;
        resolution = resolution*slowFactor;
    }
        if(downKeys[93] && slowFactor == 2){
        resolution = resolution/slowFactor;
        slowFactor = 1;

    }
   if(downKeys[48]){
      displayMode = 0;
      resolution = defaultResolution*slowFactor;
    }
    if(downKeys[49]){
      displayMode = 1;
      resolution = defaultResolution*slowFactor;
    }
    if(downKeys[50]){
      displayMode = 2;
      resolution = defaultResolution*slowFactor;
    }
    if(downKeys[51]){
      displayMode = 3;
      resolution = defaultResolution*slowFactor;
    }
    if(downKeys[52]){
      displayMode = 4;
      resolution = defaultEPResolution*slowFactor;
    }
    if(downKeys[53]){
      displayMode = 5;
      resolution = 10*slowFactor;
    }
    if(downKeys[54]){
      displayMode = 6;
      resolution = 10*slowFactor;
    }
  divisionsX = mainArena.arenaWidth/resolution;
  divisionsY = mainArena.arenaHeight/resolution;
  boxArray = new ChargeBox[divisionsX][divisionsY];
}

void updateParams(){
  if(downKeys[59]&& ejectionThreshold > 1){
      ejectionThreshold -= 10;
    }
    if(downKeys[39]){
      ejectionThreshold += 10;
    }
    if(downKeys[44] && capacitance > 10){
      capacitance-= 10;
    }
    if(downKeys[46]){
      capacitance+=10;
    }
    if(downKeys[114]||downKeys[82]){
      score = 0;
      highScore = 0;
      currentStreak = 0;
      highShotTime = 0;
      bestStreak = 0;
      timeAtTarget = 0;
      highTimeAtTarget = 0;
      writeScores();
    }
}

void displayInstructions(){
pushMatrix();
      translate(0,arenaWindough.outWidth + 40);
      textFont(strad16);
      textAlign(LEFT);
       fill(255,255,0);
       text("GAME CONTROLS",0,0);
       translate(0,20);
       fill(255);
       text("Aim/shoot: mouse/spacebar",0,0);
       translate(0,20);
       text("Gun movement up/down: W/S",0,0);
       translate(0,20);
       text("Shot type +ve/-ve: A/D",0,0);
       translate(0,30);
       fill(255,255,0);
       text("CONFIGURATION",0,0);
       translate(0,20);
       fill(255);
       text("Display mode: 0-6",0,0);
       translate(0,20);
       text("Resolution low/high: [/]",0,0);
        translate(0,20);
       text("Scatter up/down: '/;",0,0);
       translate(0,20);
       text("Capacitance up/down: >/<",0,0);
       translate(0,20);
       text("Reset score: R",0,0);
       
       
    popMatrix();
}

void keyPressed() {
 if (key<256) {
   downKeys[key] = true;
   /*for(int i = 0; i< downKeys.length; i++){
     if(downKeys[i]){
       println(i);
     }
   }*/
     
 }
}

void keyReleased() {
 if (key<256) {
   downKeys[key] = false;  
 }
 
}








