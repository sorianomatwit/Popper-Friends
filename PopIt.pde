//Pop it

Screen game;
Screen menu;
Player[] players;
void setup() {
  size(800, 600);
  //game screen
  game = new Screen("Main Game");
  game.addScreenObject(new Board(0));
  game.getBoard(0).setPlayers(players);
  
  players = new Player[2];
  players[0] = new Player("Player 1", 1, (Board) game.getSObject(0));
  players[1] = new Player("Player 2", 2, (Board) game.getSObject(0));
  
  //menu screen
  menu = new Screen("Menu");
  menu.addScreenObject(players);
}

void draw() {
  background(0);
  menu.display();
  game.display();
  game.turnScreenOff();
  fill(255);
  text(mouseX+" "+mouseY, 10, 10);
}
