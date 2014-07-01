//boxsize = arenasize/resolution
//trouble is if arenasize/reso isn't an integer.
//if boxsize - round(floor(boxsize)) !=0
// make arenasize fit an integer number of boxes?
//pick next suitable resolution that will fit.


class ChargeBox {
  
  int xPos;
  int yPos;
  float eField[];
  float V;
  //float eMagnitude;
  //float eDirection;
  
  
  ChargeBox(int tempXPos, int tempYPos){
    xPos = tempXPos;
    yPos = tempYPos;

    
    
  }
  
  
  void updateField(){
    eFieldX = 0;
    eFieldY = 0;
    

    
   eFieldX = eFieldX + eFieldUniformX;
   eFieldY = eFieldY + eFieldUniformY;
    
    
   for(int i = 0; i < chargeList.size(); i++){
        Charge thisCharge = (Charge) chargeList.get(i);
        float xDisp = thisCharge.xPos - xPos;
        float yDisp = thisCharge.yPos - yPos;
        if(abs(xDisp) < 0.1){
          xDisp = 0.1;
        }
        if(abs(yDisp) < 0.1){
          yDisp = 0.1;
        }
        float radiusSq = sq(xDisp) + sq(yDisp);
        float xCompSq = sq(xDisp)/radiusSq;
        float yCompSq = sq(yDisp)/radiusSq;
        float eFieldChargeX = (xDisp/abs(xDisp))*fieldConstantRadial*thisCharge.sign*sqrt(xCompSq)/(radiusSq);
        float eFieldChargeY = (yDisp/abs(yDisp))*fieldConstantRadial*thisCharge.sign*sqrt(yCompSq)/(radiusSq);
        eFieldX = eFieldX + eFieldChargeX;
        eFieldY = eFieldY + eFieldChargeY;
      }
   for(int i = 0; i < balloonList.length; i++){
        Balloon thisBalloon = balloonList[i];
        float xDisp = thisBalloon.xPos - xPos;
        float yDisp = thisBalloon.yPos - yPos;
        if(abs(xDisp) < 0.1){
          xDisp = 0.1;
        }
        if(abs(yDisp) < 0.1){
          yDisp = 0.1;
        }
        float radiusSq = sq(xDisp) + sq(yDisp);
        float xCompSq = sq(xDisp)/radiusSq;
        float yCompSq = sq(yDisp)/radiusSq;
        float eFieldBalloonX = (xDisp/abs(xDisp))*fieldConstantRadial*thisBalloon.sign*sqrt(xCompSq)/(radiusSq);
        float eFieldBalloonY = (yDisp/abs(yDisp))*fieldConstantRadial*thisBalloon.sign*sqrt(yCompSq)/(radiusSq);
        eFieldX = eFieldX + eFieldBalloonX;
        eFieldY = eFieldY + eFieldBalloonY;
        
      }

  }
  
  void displayField(){
    float lineX;
    float lineY;
    float angle;
    angle = atan(eFieldY/eFieldX);
    if(eFieldY > 0 && eFieldX < 0){
      angle = angle + PI;
    }
    if(eFieldX > 0 && eFieldY < 0){
      angle = angle;
    }
    if(eFieldX < 0 && eFieldY < 0){
      angle = angle + PI;
    }
    if(eFieldX > 0 && eFieldY > 0){
      angle = angle;
    }
    pushMatrix();
    translate(xPos + 0.5*resolution,yPos + 0.5*resolution);
    noStroke();
    if(displayMode == 5){
    fill(255*200*sqrt((sq(eFieldX)+ sq(eFieldY))));
    rectMode(CENTER);
    rect(0,0,resolution,resolution);
    }
    //println(sqrt(sq(eFieldX)+ sq(eFieldY)));

    rotate(angle);
    fill(255);
    ellipseMode(CENTER);
    triangle(-0.4*resolution,0,-0.2*resolution,0.2*resolution,-0.2*resolution,-0.2*resolution);
    stroke(255);
    strokeWeight(1);
    line(-0.4*resolution, 0,0.4*resolution,0);
    popMatrix();
    
    
  }

 void updatePotential(){
   V = 0;
   if(chargeList.size() != 0){
   for(int i = 0; i < chargeList.size(); i++){
      Charge thisCharge = (Charge) chargeList.get(i);
      float xDisp = thisCharge.xPos - xPos;
      float yDisp = thisCharge.yPos - yPos;
      if(abs(xDisp) < 0.1){
        xDisp = 0.1;
       }
       if(abs(yDisp) < 0.1){
         yDisp = 0.1;
       }
      float radiusSq = sq(xDisp) + sq(yDisp);
      float xCompSq = sq(xDisp)/radiusSq;
      float yCompSq = sq(yDisp)/radiusSq;
      float ePotential = fieldConstantRadial*thisCharge.sign/(sqrt(radiusSq));
      
      V = V + 1000*ePotential;  
      }
      }
      
   if(balloonList.length != 0){
   for(int i = 0; i < balloonList.length; i++){
        Balloon thisBalloon = balloonList[i];
        float xDisp = thisBalloon.xPos - xPos;
        float yDisp = thisBalloon.yPos - yPos;
        if(abs(xDisp) < 0.1){
          xDisp = 0.1;
         }
        if(abs(yDisp) < 0.1){
         yDisp = 0.1;
        }
        float radiusSq = sq(xDisp) + sq(yDisp);
        float xCompSq = sq(xDisp)/radiusSq;
        float yCompSq = sq(yDisp)/radiusSq;
        float ePotential = fieldConstantRadial*thisBalloon.sign/(sqrt(radiusSq));
        
        V = V + 2000*ePotential;
      }
   }
     V = V + 50*((xPos*voltageUseful/mainArena.arenaWidth)) + 50*((yPos*voltageVertical/mainArena.arenaHeight));
  }  
  void display(){

    float adjV =  (4*V + 125);
    pushMatrix();
    translate(xPos,yPos);
    noStroke();
    rectMode(CORNER);
    if(displayMode == 1 || displayMode == 6){
    fill(0.7*adjV,0,0.7*(255-adjV));
    rect(0,0,resolution,resolution);

   }else
    if(displayMode == 2){
    fill(adjV,0,(255-adjV));
    rect(0,0,resolution,resolution);
    } else 
    if(displayMode == 3){
    fill(0.5*adjV);
    rect(0,0,resolution,resolution);
    } else
    if(displayMode == 4){
     if(adjV > 4&& adjV < 6||
       adjV > 19&& adjV < 21 ||
       adjV > 39&& adjV < 41 ||
       adjV > 59&& adjV < 61 ||
       adjV > 79&& adjV < 81||
       adjV > 99&& adjV < 101||
       adjV > 119&& adjV < 121||
       adjV > 139&& adjV < 141||
       adjV > 159&& adjV < 161||
       adjV > 179&& adjV < 181||
       adjV > 199&& adjV < 201||
       adjV > 219&& adjV < 221||
       adjV > 239&& adjV < 241||
       adjV > 249&& adjV < 251){

    fill(adjV,0,255-adjV);
    rect(0,0,resolution,resolution);

    }
    }
  popMatrix();
  }
  
  }


