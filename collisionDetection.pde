void plateCollisionCheck() {
    for(int i = 0; i < balloonList.length; i++){
      Balloon thisBalloon = balloonList[i];   
      for(int j=0; j < plateArray.length; j++){//check if balloon has collided with any plate
        if(thisBalloon.xPos > plateArray[j].xPos - thisBalloon.balloonWidth/2 && 
        thisBalloon.xPos < plateArray[j].xPos + plateArray[j].plateWidth + thisBalloon.balloonWidth/2 && 
        thisBalloon.yPos > plateArray[j].yPos - thisBalloon.balloonWidth/2 && 
        thisBalloon.yPos < plateArray[j].yPos + plateArray[j].plateHeight + thisBalloon.balloonWidth/2){
        thisBalloon.xSpeed = 0;
        thisBalloon.ySpeed = 0; 
        thisBalloon.xPos = constrain(thisBalloon.xPos, thisBalloon.balloonWidth + 1, plate_R.xPos - thisBalloon.balloonWidth - 1);
        thisBalloon.yPos = constrain(thisBalloon.yPos, thisBalloon.balloonWidth + 1, plate_B.yPos - thisBalloon.balloonWidth - 1); 

      if(thisBalloon.sign == 1 && plateArray[j].charge <= 0){ //if balloon is positive, and plate is not positive, dump positive charge on plate
            thisBalloon.sign--;
            thisBalloon.mass--;
            plateArray[j].numPos_M++;
            thisBalloon.xPos = random(3*thisBalloon.balloonWidth,mainArena.arenaWidth - 3*thisBalloon.balloonWidth);
            thisBalloon.yPos = random(3*thisBalloon.balloonWidth,mainArena.arenaHeight - 3*thisBalloon.balloonWidth);
          } else
      if(thisBalloon.sign == -1 && plateArray[j].charge >= 0){ //if balloon is negative, and plate is not negative, dump negative charge on plate
          thisBalloon.sign++;
          thisBalloon.mass--;
          plateArray[j].numNeg_M++;
            thisBalloon.xPos = random(3*thisBalloon.balloonWidth,mainArena.arenaWidth - 3*thisBalloon.balloonWidth);
            thisBalloon.yPos = random(3*thisBalloon.balloonWidth,mainArena.arenaHeight - 3*thisBalloon.balloonWidth);
          

      } else 
        if(thisBalloon.sign == 0) { //if balloon is neutral...  
          if(plateArray[j].charge > 1 && plateArray[j].numPos_M > 0){//...and plate is positively charged and some of that charge is moveable, pickup charge
          thisBalloon.sign++;
          plateArray[j].numPos_M--;
          thisBalloon.mass++;
        } else
          if(plateArray[j].charge < -1 && plateArray[j].numNeg_M > 0){//...and plate is negatively charged and some of that charge is moveable, pickup charge
          thisBalloon.sign--;
          plateArray[j].numNeg_M--;
          thisBalloon.mass++;
          }      
      } 

    }    
   } 
  }
}


void chargeCollisionCheck(){
  for(int i=0; i < chargeList.size(); i++){
    Charge thisCharge = (Charge) chargeList.get(i);
    float kineticEnergy = 0.5*thisCharge.mass*(sq(thisCharge.xSpeed) + sq(thisCharge.ySpeed));
        for(int j = 0; j < plateArray.length; j++){
          if(thisCharge.xPos >= plateArray[j].xPos && 
             thisCharge.xPos <= plateArray[j].xPos + plateArray[j].plateWidth && 
             thisCharge.yPos >= plateArray[j].yPos && 
             thisCharge.yPos <= plateArray[j].yPos + plateArray[j].plateHeight){

             
             
             if(kineticEnergy > ejectionThreshold){
               int numPos_Moved;
               int numNeg_Moved;
               if(plateArray[j].numPos_M > 0){
                numPos_Moved = ceil(random(1, plateArray[j].numPos_M)%ejectionMax);
               } else {
                numPos_Moved = 0;
               }
               if(plateArray[j].numNeg_M > 0){
                numNeg_Moved = ceil(random(1, plateArray[j].numNeg_M)%(ejectionMax-numPos_Moved));
               } else {
                numNeg_Moved = 0;
               }
                float energyShare = kineticEnergy/(1.*numNeg_Moved + numPos_Moved);
                  for(int k = 0; k < numPos_Moved; k++){
                    float newXSpeed;
                    float newYSpeed;
                     if(plateArray[j] == plate_T || plateArray[j] == plate_B){
                        newXSpeed = ejectionDamping*(thisCharge.xSpeed/abs(thisCharge.xSpeed))*random(-0.5*sqrt(2*thisCharge.mass*(energyShare)), sqrt(2*thisCharge.mass*(energyShare)));
                     } else {
                        newXSpeed = -1*ejectionDamping*(thisCharge.xSpeed/abs(thisCharge.xSpeed))*random(-0.5*sqrt(2*thisCharge.mass*(energyShare)), sqrt(2*thisCharge.mass*(energyShare)));
                     }
                     if(plateArray[j] == plate_R || plateArray[j] == plate_L){
                       newYSpeed = ejectionDamping*(thisCharge.ySpeed/abs(thisCharge.ySpeed))*sqrt(2*thisCharge.mass*(energyShare) - 0.5*thisCharge.mass*sq(newXSpeed));
                     } else {
                       newYSpeed = -1*ejectionDamping*(thisCharge.ySpeed/abs(thisCharge.ySpeed))*sqrt(2*thisCharge.mass*(energyShare) - 0.5*thisCharge.mass*sq(newXSpeed));
                     }
                     Charge freshCharge = new Charge(thisCharge.xPos + newXSpeed, thisCharge.yPos + newYSpeed, 1,newXSpeed,newYSpeed, chargeMass, false);
                     chargeList.add(freshCharge);
                     plateArray[j].numPos_M--;
                   }
                   for(int m = 0; m < numNeg_Moved; m++){ //if a collision happens with enough energy, eject moveable charges!
                    float newXSpeed;
                    float newYSpeed;
                     if(plateArray[j] == plate_T || plateArray[j] == plate_B){
                      newXSpeed = ejectionDamping*(thisCharge.xSpeed/abs(thisCharge.xSpeed))*random(-0.2*sqrt(2*chargeMass*(energyShare)), sqrt(2*chargeMass*(energyShare)));
                    } else {
                      newXSpeed = -1*ejectionDamping*(thisCharge.xSpeed/abs(thisCharge.xSpeed))*random(-0.2*sqrt(2*chargeMass*(energyShare)), sqrt(2*chargeMass*(energyShare)));
                    }
                    if(plateArray[j] == plate_R || plateArray[j] == plate_L){
                     newYSpeed = ejectionDamping*(thisCharge.ySpeed/abs(thisCharge.ySpeed))*sqrt(2*chargeMass*(energyShare) - 0.5*thisCharge.mass*sq(newXSpeed));
                    } else {
                     newYSpeed = -1*ejectionDamping*(thisCharge.ySpeed/abs(thisCharge.ySpeed))*sqrt(2*chargeMass*(energyShare) - 0.5*thisCharge.mass*sq(newXSpeed));
                    }

                    Charge freshCharge = new Charge(thisCharge.xPos + newXSpeed, thisCharge.yPos + newYSpeed, -1,newXSpeed,newYSpeed, chargeMass, false);
                    chargeList.add(freshCharge);
                    plateArray[j].numNeg_M--;
                  
                } 

             }

           if(thisCharge.sign == -1){
             plateArray[j].numNeg_M++;
           } else
           if(thisCharge.sign == 1){
             plateArray[j].numPos_M++;
           }
           if(thisCharge.player){
             if(j == 0 && kineticEnergy < ejectionThreshold){
               score = score + bonusMultiplier*difficultyMultiplier*1;
               currentStreak++;
             } else {
               currentStreak = 0;
             }
           }
           if(thisCharge.timerS > highShotTime){
             highShotTime = thisCharge.timerS;
           }
           chargeList.remove(i);
           break;
          } 
       } 
    } 
  

        for(int j=0; j < balloonList.length;j++){
           if(chargeList.size() > 0){
              for(int i = 0; i < chargeList.size(); i++){
        Charge thisCharge = (Charge) chargeList.get(i);
          Balloon thisBalloon = balloonList[j];
            if(thisCharge.xPos < thisBalloon.xPos + 0.5*thisBalloon.balloonWidth &&
               thisCharge.xPos > thisBalloon.xPos - 0.5*thisBalloon.balloonWidth &&
               thisCharge.yPos < thisBalloon.yPos + 0.5*thisBalloon.balloonWidth &&
               thisCharge.yPos > thisBalloon.yPos - 0.5*thisBalloon.balloonWidth){

               if(thisBalloon.sign == 0){
                 if(thisCharge.sign == -1){
                   thisBalloon.sign --;
                   thisBalloon.mass++;
                 } else 
                 if(thisCharge.sign == 1){
                   thisBalloon.sign ++;
                   thisBalloon.mass++;
                 }
               if(thisCharge.player){
                 currentStreak = 0;
               }
             if(thisCharge.timerS > highShotTime){
             highShotTime = thisCharge.timerS;
           }
               chargeList.remove(i);
             }
           }
         }
      }
}
}



                
              

