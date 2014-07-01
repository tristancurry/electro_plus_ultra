class Windough {
  
  int outWidth;
  int outHeight;
  int inWidth;
  int inHeight;
  int borderWidth;
  
  color windowColour;
  color borderColour;
  
  //Constructor
  
  Windough(int tempOutWidth, int tempOutHeight, int tempInWidth, int tempInHeight, color tempWindowColour, color tempBorderColour){
    outWidth = tempOutWidth;
    outHeight = tempOutHeight;
    inWidth = tempInWidth;
    inHeight = tempInHeight;
  
    windowColour = tempWindowColour;
    borderColour = tempBorderColour; 
    borderWidth = (outWidth - inWidth)/2;
  }
  
  
  void display(){
    noStroke();
    fill(borderColour);
    rectMode(CORNER);
    rect(0,0, outWidth, outHeight);
    
    fill(windowColour);
    rectMode(CENTER);
    rect(outWidth/2, outHeight/2, inWidth, inHeight);
  
  }
  
}
