class Cannon {

int mode = 0;
float lowerLimit;
float upperLimit;
float cannonWidth;
float xPos;
float yPos;
float ySpeed;
float speedLimit;

Cannon() {
  cannonWidth = plate_R.plateWidth;
  lowerLimit = plate_R.yPos + plate_R.plateHeight - 0.5*cannonWidth;
  upperLimit = plate_R.yPos + 0.5*cannonWidth;
  speedLimit = 3;
  ySpeed = 0;
  yPos = (lowerLimit + upperLimit)/2;
  xPos = plate_R.xPos + plate_R.plateWidth/2;
}

void setMode(int tempMode){
  mode = tempMode;
}

void move(){
    if(downKeys[119] || downKeys[87] && ySpeed > -1*speedLimit){
      ySpeed = ySpeed - 0.3;    
    }
    if(downKeys[115]||downKeys[83] && ySpeed < speedLimit){
      ySpeed = ySpeed + 0.3;
    }
    yPos = yPos + ySpeed;
    if(yPos >= lowerLimit && ySpeed > 0){
      yPos = lowerLimit;
      ySpeed = -1*ySpeed;
    };
    if(yPos <= upperLimit && ySpeed < 0){
      yPos = upperLimit;
      ySpeed = -1*ySpeed;
    };
  ySpeed = 0.9*ySpeed;
}

  
void display() {
  float angle;
  noStroke();
  if(mode == 1){
    fill(posF_col);
  } else if(mode == -1) {
    fill(negF_col);
  } else {
    fill(255);
  }
  
  angle = atan((aimPointY)/(aimPointX));
  rectMode(CENTER);
  rect(xPos, yPos, cannonWidth,cannonWidth);
  
  pushMatrix();

  translate(xPos,yPos);
  rotate(angle);

   if(mode == 1){
    fill(posM_col);
    stroke(posF_col);
  } else if(mode == -1) {
    fill(negM_col);
    stroke(negF_col);
  } else {
    fill(160);
  }
  ellipseMode(CENTER);
  ellipse(-cannonWidth/2 + 5,0,5,5);
  popMatrix();

  }

}

