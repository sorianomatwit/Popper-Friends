//Pop it

Screen menu;
Screen game;
Screen gameEnd;
Player[] players;
boolean clicked = false;
void setup() {
  size(800, 600);
  //frameRate(1);
  //game screen
  game = new Screen("Main Game");
  game.addScreenObject(new Board(0,game));

  players = new Player[2];
  players[0] = new Player("Player 1", 2, (Board) game.getSObject(0));
  players[1] = new Player("Player 2", 1, (Board) game.getSObject(0));
  game.getBoard(0).setPlayers(players);
  game.turnScreenOff();

  //menu screen
  menu = new Screen("Menu");
  menu.addScreenObject(players);
  menu.addScreenObject(new Selector(players, menu));

  //game over screen
  gameEnd = new Screen("Game Over");
  gameEnd.turnScreenOff();
}
void draw() {
  background(0);
  menu.display();
  menu.addText("Goal: Don't be the Last One to Press a Popper",width/2,height*.2,28,color(255));
  game.display(); 
  gameEnd.display();
  gameEnd.addText("Lost",width/2,height*.4,48,color(255,0,0));
  if (menu.button(width/2, height*.7, 70, 30, "Play") && (((Selector) (menu.getSObject(2))).getDecision() != -1)) {
    game.turnScreenOn();
    menu.turnScreenOff();
    ((Board) (game.getSObject(0))).setTurn(((Selector) (menu.getSObject(2))).getDecision());
  }
  
  if (game.button(60, height*.8, 100, 30, "Back")) {
    game.turnScreenOff();
    menu.turnScreenOn();
    menu.reset();
    game.reset();
  }
  
  if (((Board) (game.getSObject(0))).gameOver()) {
    game.turnScreenOff();
    gameEnd.turnScreenOn();
    gameEnd.addScreenObject(((Board) (game.getSObject(0))).getLoser());
    ((Player) gameEnd.getSObject(0)).gamemode = 1;
    println(((Player) gameEnd.getSObject(0)));
  }
  
  if (gameEnd.button(width*.4, height/2, 100, 40, "Play again")) {
    ((Player) gameEnd.getSObject(0)).gamemode = 0;
    gameEnd.turnScreenOff();
    menu.turnScreenOn();
    menu.reset();
    game.reset();
  }
  if (gameEnd.button(width*.6, height/2, 100, 40, "Quit")) exit();
}
