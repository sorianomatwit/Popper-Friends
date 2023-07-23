class Player implements Screen_Object {
  String name;
  int PlayerNum;
  boolean input = false;
  Board gameBoard;
  PFont playerFont;
  int gamemode = 0;
  Player(String n, int pl, Board game) {
    playerFont = loadFont("BerlinSansFB-Bold-48.vlw");
    name = n;
    PlayerNum = pl; 
    gameBoard = game;
    textFont(playerFont,48);
  }
  void display() {
    text(name,width*(pow(.5,PlayerNum))  ,height/2);
  }

  void reset() {
  }
  
  //void skipTurn
  String toString() {
    String s = String.format("%s", name);
    return  s;
  }
}
