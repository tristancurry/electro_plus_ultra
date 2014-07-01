void chargeAccn(){
  for(int i = 0; i < chargeList.size(); i++){
  Charge thisCharge = (Charge) chargeList.get(i);
  thisCharge.xAccn = -1*fieldConstantUniform*thisCharge.sign*eFieldUniformX/thisCharge.mass;
  thisCharge.yAccn = -1*fieldConstantUniform*thisCharge.sign*eFieldUniformY/thisCharge.mass;
  if(chargeList.size() > 1){
    for(int j = 0; j < chargeList.size(); j++){//accn on one charge from others
    if(i != j) {
      Charge thatCharge = (Charge) chargeList.get(j);
      float xDisp = thisCharge.xPos - thatCharge.xPos;
      float yDisp = thisCharge.yPos - thatCharge.yPos;
if(abs(xDisp) < 0.1){
          xDisp = 0.1;
        }
        if(abs(yDisp) < 0.1){
          yDisp = 0.1;
        }
        float radiusSq = sq(xDisp) + sq(yDisp);
        float xCompSq = sq(xDisp)/sq(xDisp)+sq(yDisp);
        float yCompSq = sq(yDisp)/sq(xDisp)+sq(yDisp);
        thisCharge.xAccn = thisCharge.xAccn + (xDisp/abs(xDisp))*fieldConstantRadial*thisCharge.sign*thatCharge.sign*sqrt(xCompSq)/(sqrt(radiusSq)*thisCharge.mass);
        thisCharge.yAccn = thisCharge.yAccn + (yDisp/abs(yDisp))*fieldConstantRadial*thisCharge.sign*thatCharge.sign*sqrt(yCompSq)/(sqrt(radiusSq)*thisCharge.mass);
    }
    }
    if(balloonList.length !=0){
    for(int k = 0; k < balloonList.length; k ++){
      Balloon thatBalloon = balloonList[k];
      float xDisp = thisCharge.xPos - thatBalloon.xPos;
      float yDisp = thisCharge.yPos - thatBalloon.yPos;
      if(abs(xDisp) < 0.1){
          xDisp = 0.1;
        }
        if(abs(yDisp) < 0.1){
          yDisp = 0.1;
        }  
        float radiusSq = sq(xDisp) + sq(yDisp);
        float xCompSq = sq(xDisp)/radiusSq;
        float yCompSq = sq(yDisp)/radiusSq;
        thisCharge.xAccn = thisCharge.xAccn + fieldConstantRadial*thisCharge.sign*thatBalloon.sign*(xDisp/abs(xDisp))*sqrt(xCompSq)/(sqrt(radiusSq)*thisCharge.mass);
        thisCharge.yAccn = thisCharge.yAccn + fieldConstantRadial*thisCharge.sign*thatBalloon.sign*(yDisp/abs(yDisp))*sqrt(yCompSq)/(sqrt(radiusSq)*thisCharge.mass);
    
    }
    }
  }
}
}
void balloonAccn(){
if(balloonList.length != 0){
for(int i = 0; i < balloonList.length; i++){
      Balloon thisBalloon = balloonList[i];
      thisBalloon.xAccn = (-1*fieldConstantUniform*eFieldUniformX*thisBalloon.sign)/thisBalloon.mass;
      thisBalloon.yAccn = (-1*fieldConstantUniform*eFieldUniformY*thisBalloon.sign)/thisBalloon.mass;
for(int j = 0; j < balloonList.length; j ++){
  if(i != j){
      Balloon thatBalloon = balloonList[j];
      float xDisp = thisBalloon.xPos - thatBalloon.xPos;
      float yDisp = thisBalloon.yPos - thatBalloon.yPos;
      if(abs(xDisp) < 0.1){
          xDisp = 0.1;
        }
        if(abs(yDisp) < 0.1){
          yDisp = 0.1;
        }
        float radiusSq = sq(xDisp) + sq(yDisp);
        float xCompSq = sq(xDisp)/radiusSq;
        float yCompSq = sq(yDisp)/radiusSq;
        thisBalloon.xAccn = thisBalloon.xAccn + fieldConstantRadial*thisBalloon.sign*thatBalloon.sign*(xDisp/abs(xDisp))*sqrt(xCompSq)/(sqrt(radiusSq)*thisBalloon.mass);
        thisBalloon.yAccn = thisBalloon.yAccn + fieldConstantRadial*thisBalloon.sign*thatBalloon.sign*(yDisp/abs(yDisp))*sqrt(yCompSq)/(sqrt(radiusSq)*thisBalloon.mass);
  }
  for(int k = 0; k < chargeList.size(); k ++){
    Charge thatCharge = (Charge) chargeList.get(k);
    float xDisp = thisBalloon.xPos - thatCharge.xPos;
    float yDisp = thisBalloon.yPos - thatCharge.yPos;
    if(abs(xDisp) < 0.1){
          xDisp = 0.1;
        }
        if(abs(yDisp) < 0.1){
          yDisp = 0.1;
        }
      float radiusSq = sq(xDisp) + sq(yDisp);
      float xCompSq = sq(xDisp)/radiusSq;
      float yCompSq = sq(yDisp)/radiusSq;
      thisBalloon.xAccn = thisBalloon.xAccn + fieldConstantRadial*thisBalloon.sign*thatCharge.sign*(xDisp/abs(xDisp))*sqrt(xCompSq)/(sqrt(radiusSq)*thisBalloon.mass);
      thisBalloon.yAccn = thisBalloon.yAccn + fieldConstantRadial*thisBalloon.sign*thatCharge.sign*(yDisp/abs(yDisp))*sqrt(yCompSq)/(sqrt(radiusSq)*thisBalloon.mass);  
   }
  }
}
}
}
