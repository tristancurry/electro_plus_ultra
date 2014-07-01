//code for determining scores, displaying.

int score;
float[] scoreArray;
int highScore;
int bonusMultiplier;
int difficultyMultiplier;
float highShotTime;
float highVoltage;
int highSustain;
float shotEnergy;
int currentStreak;
int bestStreak;
float targetVoltage = 0.25;
float tolerance = 0.05; //percent
float timeAtTarget;
float highTimeAtTarget;

void initialiseScores(){
score = 0;
bonusMultiplier = 1;
difficultyMultiplier = round(floor((170/ejectionThreshold)*(numBalloons/4)));
shotEnergy = 0.00;
timeAtTarget = 0;
String[] scoreString = loadStrings("data/skoors.txt");
scoreArray = float(split(scoreString[0], ','));
highScore = round(scoreArray[0]);
highShotTime = round(scoreArray[1]);
highVoltage = scoreArray[2];
highSustain = round(scoreArray[3]);
bestStreak = round(scoreArray[4]);
highTimeAtTarget = round(scoreArray[5]);
}

void writeScores(){
String scoresForWriting = str(highScore) +", "+ str(highShotTime) +", "+ str(highVoltage) +", "+ str(highSustain) +", "+ str(bestStreak) +", "+ str(highTimeAtTarget) +";";
String[] scoreList = split(scoresForWriting,';');
saveStrings("data/skoors.txt", scoreList);
}



void displayScores(){
textFont(strad16);
textAlign(LEFT);
 fill(255);
 pushMatrix();
 //SCORE
 translate(20,scoreWindough.borderWidth + 20);
 text("Score:",0,0);
 translate(scoreWindough.inWidth - 20,50);
 textAlign(RIGHT);
 textFont(strad48);
 text(str(score),0,0);
 textFont(strad16);
 //BONUSES
 textAlign(LEFT);
 translate(-1*(scoreWindough.inWidth - 20),20);
 text("bonus: x"+str(bonusMultiplier),0,0);
 translate(0,20);
 text("difficulty: x"+str(difficultyMultiplier),0,0);
 //STREAKS
 translate(0,30);
 fill(255,255,0);
 text("Streak:",0,0);
 translate(scoreWindough.inWidth - 20,15);
 textAlign(RIGHT);
 text(str(currentStreak),0,0);
 textAlign(LEFT);
 fill(255);
 translate(-1*(scoreWindough.inWidth - 20),15);
 text("Best streak:",0,0);
 translate(scoreWindough.inWidth - 20,15);
 textAlign(RIGHT);
 text(str(bestStreak),0,0);
 textAlign(LEFT);
 translate(-1*(scoreWindough.inWidth - 20),15);
 fill(255,255,0);
 text("Target:",0,0);
 translate(scoreWindough.inWidth - 20,10);
 textAlign(RIGHT);
 text(str(targetVoltage)+" V",0,0);
 textAlign(LEFT);
 translate(-1*(scoreWindough.inWidth - 20),20);
 fill(255);
 text("Time at target:",0,0);
 translate(scoreWindough.inWidth - 20,20);
 textAlign(RIGHT);
 text(str(timeAtTarget) +" s",0,0);
 textAlign(LEFT);
 translate(-1*(scoreWindough.inWidth - 20),20);
 text("-------------",0,0);
 translate(0,20);
 text("High Score:",0,0);
 translate(scoreWindough.inWidth - 20,20);
 textAlign(RIGHT);
 text(str(highScore),0,0);
 textAlign(LEFT);
 translate(-1*(scoreWindough.inWidth - 20),20);
  text("Longest shot:",0,0);
 translate(scoreWindough.inWidth - 20,20);
 textAlign(RIGHT);
 text(str(highShotTime) +" s",0,0);
 textAlign(LEFT);
 translate(-1*(scoreWindough.inWidth - 20),20);
 text("Longest time:",0,0);
 translate(scoreWindough.inWidth - 20,20);
 textAlign(RIGHT);
 text(str(highTimeAtTarget) +" s",0,0);
 textAlign(LEFT);
 translate(-1*(scoreWindough.inWidth - 20),15);
 text("-------------",0,0);
 translate(0,15);
 fill(0,255,0);
 text("Shot Energy:",0,0);
 translate(scoreWindough.inWidth - 20,20);
 textAlign(RIGHT);
 text(str(shotEnergy)+ " eV",0,0);
 textAlign(LEFT);
 fill(255);
 popMatrix();

}

void updateScores(){
  difficultyMultiplier = round(floor((170/ejectionThreshold)*(capacitance/100)*(numBalloons/4)));
  
  
  if(score > highScore){
    highScore = score;
  }
  if(currentStreak > bestStreak){
    bestStreak = currentStreak;
  }
  
  if(currentStreak == 3){
    bonusMultiplier = 2;
  }
  if(currentStreak == 6){
    bonusMultiplier = 3;
  }
  if(currentStreak == 10){
    bonusMultiplier = 4;
  }
  if(currentStreak == 15){
    bonusMultiplier = 5;
  }
  if(currentStreak == 21){
    bonusMultiplier = 10;
  }
    if(currentStreak == 0){
    bonusMultiplier = 1;
  }
  
}
