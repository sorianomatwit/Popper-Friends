class Player implements Screen_Object {
  String name;
  int playerNum;
  boolean input = false;
  Board gameBoard;
  PFont playerFont;
  int gamemode = 0;
  Player(String n, int pl, Board game) {
    playerFont = loadFont("BerlinSansFB-Bold-48.vlw");
    name = n;
    playerNum = pl; 
    gameBoard = game;
    textFont(playerFont, 48);
  }
  void display() {
    switch(gamemode) {
    case 0:
      pushMatrix();
      fill(255);
      textAlign(LEFT);
      textSize(48);
      text(name, .6*width/pow(playerNum, 2), height/2);
      rectMode(CORNER);
      if (playerNum == 2) {
        fill(0, 0, 255, 50);
      } else fill(255, 165, 0, 50);
      noStroke();
      rect(0 +abs(playerNum - 2)*.6*width/pow(playerNum, 2) - 10*abs(playerNum - 2), 0, 10+.6*width/pow(playerNum, 2) + (playerNum - 1)*185, height);
      popMatrix();
      break;
    case 1:
    pushMatrix();
      fill(255);
      textAlign(CENTER,CENTER);
      textSize(48);
      text(name, width/2,height*.3);
      popMatrix();
      break;
    }
  }

  void reset() {
  }

  //void skipTurn
  String toString() {
    String s = String.format("%s", name);
    return  s;
  }
}
