class Charge {
  int sign;
  float xPos;
  float yPos;
  float xSpeed;
  float ySpeed;
  float xAccn;
  float yAccn;
  float xUniformAccn;
  float yUniformAccn;
  int mass;
  boolean player;
  int timer;
  float timerS;
  
  int trailLength = 5;
  float xPosArray[];
  float yPosArray[];
  
  Charge(float tempXPos, float tempYPos, int tempSign, float tempXSpeed, float tempYSpeed, int tempMass, boolean tempPlayer){
    
    sign = tempSign;
    xPos = tempXPos;
    yPos = tempYPos;
    xSpeed = tempXSpeed;
    ySpeed = tempYSpeed;
    mass = tempMass;
    player = tempPlayer;
    timer = 0;
    timerS = 0;
  
    xPosArray = new float[trailLength];
    yPosArray = new float[trailLength];  
    
    for(int i = 0; i < xPosArray.length; i++){ 
      xPosArray[i] = 0;
      yPosArray[i] = 0;
    }
  }
  
  void move() {
    xSpeed = xSpeed + xAccn;
    ySpeed = ySpeed + yAccn;
    
    if(xSpeed > 40||ySpeed > 40){
      xSpeed = 40;
      ySpeed = 40;
    }
    
    for(int i = xPosArray.length; i > 1; i--){
      xPosArray[i-1] = xPosArray[i-2];
      yPosArray[i-1] = yPosArray[i-2];
    }
    
    xPos = 1.*xPos + xSpeed;    
    yPos = 1.*yPos + ySpeed;
    xPos = constrain(xPos, -1, plate_R.xPos + 1);
    yPos = constrain(yPos, -1, plate_B.yPos + 1);
    

    
    if(xPos < plate_L.xPos + plate_L.plateWidth || xPos > mainArena.arenaWidth){
      if(yPos < plate_T.yPos + plate_T.plateHeight){
        yPos = 0;
      }
      if(yPos > mainArena.arenaHeight){
        yPos = mainArena.arenaHeight;
      }
    
    }

    xPosArray[0] = xPos;
    yPosArray[0] = yPos;
    
    if(player){
    timer ++;
    timerS = 1.*round(100*timer/frameRate)/100;
    }

    
  }
  
  void display() {
    color chargeCol;
    color posCol = color(255,80,120,255);
    color negCol = color(0,255,255,255);
    color alphaInc = color(0,0,0,255/(1.*trailLength));
    noStroke();
    if(sign < 0) {
      chargeCol = negM_col;
    } else if(sign > 0) {
      chargeCol = posM_col;
    } else {
      chargeCol = color(0,0,0,0);
    }
    rectMode(CENTER);
    for(int i = 0; i < xPosArray.length; i++){
    fill(chargeCol - i*alphaInc);
    rect(xPosArray[i], yPosArray[i], 5, 5); 
    }  
  }  
}

