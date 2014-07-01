class Arena {
  float capacitance;
  int arenaWidth;
  int arenaHeight;
  int xPos;
  int yPos;
  
  Arena(int tempXPos, int tempYPos, int tempArenaWidth, int tempArenaHeight, float tempCapacitance){
    
    capacitance = tempCapacitance;
    arenaWidth = tempArenaWidth;
    arenaHeight = tempArenaHeight;
    xPos = tempXPos;
    yPos = tempYPos;
    
  }
 //SETTERS
  void set_Capacitance(float tempCapacitance){
    capacitance = tempCapacitance;
  }
  
}
