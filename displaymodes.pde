/*

at the press of a button, set the displayMode


each mode is an array like this

MODE = [displayNumber, 
        resolution
        displayCharges (0,1), 
        displayBalloons (0,1),
        displayPlateCharges (0,1),
        posM_col,
        posF_col,
        negM_col,
        negF_col,
        potential or field display (P,F),
        equipotentials (0,1);
        
        P/F amplification,
        chargeDisplaySize,
        chargeTrailLength]
        

so for instance,

displayMode 1 = [1,resolution,1,1,1,color(whatever),color(255,0,0),color(0,255,255),color(0,0,255),P,0,0.7,5,5];
displayMode 2 = [2,resolution,1,1,1,color(whatever),color(255,0,0),color(0,255,255),color(0,0,255),P,0,1,0,0];
displayMode 3 = [3,resolution,1,1,1,color(255),color(200,200,200,125),color(0),color(50,50,50,125),P,0,1,5,0];
displayMode 4 = [4,resolution,1,1,1,color(whatever),color(255,0,0),color(0,255,255),color(0,0,255),P,1,0.7,5,0];
displayMode 5 = [4,10,1,1,1,color(whatever),color(255,0,0),color(0,255,255),color(0,0,255),F,0,1,5,0];


*/
