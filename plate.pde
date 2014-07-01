class Plate {
  int numPos_M;
  int numPos_F;
  int numNeg_M; 
  int numNeg_F;
  
  int xPos;
  int yPos;
  int plateWidth;
  int plateHeight;
  
  int control;
  
  int charge;
  int charges;
  int numNeg;
  int numPos;
  
  int squaresWide;
  int squaresHigh;
  int squaresNeg_M;
  int squaresNeg_F;
  int squaresPos_M;
  int squaresPos_F;
  int fixedArray[][];
  
  float posFactor;
  
  Plate(int tempXPos, int tempYPos, int tempWidth, int tempHeight, int tempNumPos_M, int tempNumPos_F, int tempNumNeg_M, int tempNumNeg_F, int tempControl) {
    numPos_M = tempNumPos_M;
    numPos_F = tempNumPos_F; 
    numNeg_M = tempNumNeg_M; 
    numNeg_F = tempNumNeg_F;
    
    xPos = tempXPos;
    yPos = tempYPos;
    plateWidth = tempWidth;
    plateHeight = tempHeight;
    
    numPos = numPos_M + numPos_F;
    numNeg = numNeg_M + numNeg_F;
    charge = numPos - numNeg;
    charges = numPos + numNeg; 
    
    squaresWide = round(1.*plateWidth/plateSquareWidth);
    squaresHigh = round(1.*plateHeight/plateSquareWidth);
     
    squaresNeg_F = numNeg_F; //record numbers of fixed charges
    squaresPos_F = numPos_F;
    
    control = tempControl;
    
    fixedArray = new int[squaresWide][squaresHigh];
    
    buildArray();


  }
  
  
  void update() { //update values related to fixed and movable charges
    numPos = numPos_M + numPos_F;
    numNeg = numNeg_M + numNeg_F;
    charge = numPos - numNeg;
    charges = numPos + numNeg;


    
    posFactor = 0.5 + 0.5*(1.*charge/(totalCharges)); 
    

  
  
  }
  
  void display() { //draw the plate, colour according to charge
  
      
  
    noStroke();
    rectMode(CORNER);
    rect(xPos,yPos,plateWidth,plateHeight);
    
    refreshCharges(); 
    displayCharges();
    
    
}

void buildArray(){
  for(int i = 0; i < squaresWide; i++){
    for(int j = 0; j < squaresHigh; j++){
      fixedArray[i][j] = 0;
    }    
  }
  
  for (int i = 0; i < numNeg_F + numPos_F; i++){
    int coord1 = round(random(squaresWide-1));
    int coord2 = round(random(squaresHigh-1));
    if(fixedArray[coord1][coord2] == 0){
      if(squaresNeg_F > 0){
        fixedArray[coord1][coord2] = -1;
        squaresNeg_F--;
      } else 
      if(squaresPos_F > 0){
        fixedArray[coord1][coord2] = 1;
        squaresPos_F--; 
       } 
     }
  }
}

   
 void refreshCharges(){
    squaresNeg_M = numNeg_M;
    squaresPos_M = numPos_M;
    
     for(int i = 0; i < squaresWide; i++){
      for(int j = 0; j < squaresHigh; j++){
        if(abs(fixedArray[i][j]) > 1){
          fixedArray[i][j] = 0;
        }
      }
    }
   
    for(int i = 0; i < numNeg_M + numPos_M; i++){
      int coord1 = round(random(squaresWide-1));
      int coord2 = round(random(squaresHigh-1));
      if(fixedArray[coord1][coord2] == 0){
        if(squaresNeg_M > 0){
          fixedArray[coord1][coord2] = -2;
          squaresNeg_M--;
        } else 
        if(squaresPos_M > 0){
          fixedArray[coord1][coord2] = 2;
          squaresPos_M--; 
        } 
      }

   }
 }
 
 void displayCharges() {
   for(int i = 0; i < plateWidth/5 ; i++){
      for(int j = 0; j < plateHeight/5; j++){
 
        if(fixedArray[i][j] == 1){
          fill(posF_col);
        } else
        if(fixedArray[i][j] == -1){
          fill(negF_col);
        } else
        if(fixedArray[i][j] == 2){
          fill(posM_col);
        } else
        if(fixedArray[i][j] == -2){
          fill(negM_col);
        } else {
          color minceMeat =  color(posFactor*255, 0,(1-posFactor)*255);
          fill(minceMeat);
          
        }
        rect(xPos + 5*i, yPos + 5*j, 5, 5);
      }
    }
  }
}
