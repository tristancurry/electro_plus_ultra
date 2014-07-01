class Balloon {
  int sign = 0;
  float xPos;
  float yPos;
  float xSpeed;
  float ySpeed;
  float xAccn;
  float yAccn;
  float xUniformAccn;
  float yUniformAccn;
  float drift;
  float balloonWidth;
  float mass;
  
  
  Balloon(float tempXPos, float tempYPos, float tempDrift, float tempMass){
    balloonWidth = balloonDefaultWidth;
    xPos = tempXPos;
    yPos = tempYPos;
    drift = tempDrift;
    mass = tempMass;
  }
  

  
  void move() {


    xSpeed = xSpeed  + xAccn;
    ySpeed = ySpeed  + yAccn;
    
    
    xPos = xPos + xSpeed+ random(-drift,drift);
    yPos = yPos + ySpeed+ random(-drift,drift);
    
    xPos = constrain(xPos, -1, plate_R.xPos + 1);
    yPos = constrain(yPos, -1, plate_B.yPos + 1);
    
   
    
  }
  

  void display() {
    noStroke();
    
    if(sign < 0) {
      fill(negM_col);
    } else if(sign > 0) {
      fill(posM_col);
    } else {
      fill(255);
    }
    rectMode(CENTER);
    rect(xPos, yPos, balloonWidth, balloonWidth);   
  }
  


}

