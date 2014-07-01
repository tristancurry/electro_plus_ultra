//code for determining, maintaining, displaying sciency numbers

void displayScience(){

textFont(strad16);
textAlign(LEFT);
 fill(255);
 pushMatrix();
 translate(20,scoreWindough.outHeight + 40);
 text("capacitance:",0,0);
 translate(scoreWindough.inWidth - 20,20);
 textAlign(RIGHT);
 text(str(1.*round(capacitance*1.6*1000)/1000)+ "x10^-19 F",0,0);
 textAlign(LEFT);
 translate(-1*(scoreWindough.inWidth - 20),20);
 text("scatter:",0,0);
 translate((scoreWindough.inWidth - 20),20);
 textAlign(RIGHT);
 text(str(1.*(round(ejectionThreshold*1000)/1000)/4000)+ " eV",0,0);
 textAlign(LEFT);
  translate(-1*(scoreWindough.inWidth - 20),20);
  fill(posM_col);
 text("+ve ions:",0,0);
 translate(scoreWindough.inWidth - 20,20);
 textAlign(RIGHT);
 fill(255);
 text(str(plate_R.numPos_M)+ " moveable",0,0);
 textAlign(LEFT);
  translate(-1*(scoreWindough.inWidth - 20),20);
    fill(negM_col);
 text("-ve ions:",0,0);
 translate(scoreWindough.inWidth - 20,20);
 fill(255);
 textAlign(RIGHT);
 text(str(plate_R.numNeg_M)+ " moveable",0,0);
popMatrix();

}
