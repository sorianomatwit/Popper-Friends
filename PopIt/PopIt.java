import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class PopIt extends PApplet {

//Pop it

Screen menu;
Screen game;
Screen gameEnd;
Player[] players;
boolean clicked = false;
public void setup() {
  
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
public void draw() {
  background(0);
  menu.display();
  menu.addText("Goal: Don't be the Last One to Press a Popper",width/2,height*.2f,28,color(255));
  game.display(); 
  gameEnd.display();
  gameEnd.addText("Lost",width/2,height*.4f,48,color(255,0,0));
  if (menu.button(width/2, height*.7f, 70, 30, "Play") && (((Selector) (menu.getSObject(2))).getDecision() != -1)) {
    game.turnScreenOn();
    menu.turnScreenOff();
    ((Board) (game.getSObject(0))).setTurn(((Selector) (menu.getSObject(2))).getDecision());
  }
  
  if (game.button(60, height*.8f, 100, 30, "Back")) {
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
  
  if (gameEnd.button(width*.4f, height/2, 100, 40, "Play again")) {
    ((Player) gameEnd.getSObject(0)).gamemode = 0;
    gameEnd.turnScreenOff();
    menu.turnScreenOn();
    menu.reset();
    game.reset();
  }
  if (gameEnd.button(width*.6f, height/2, 100, 40, "Quit")) exit();
}
class Board implements Screen_Object {

  float x, y;
  float size;
  float start;
  float[] chords = {124.225f, 157.133f, 166.7f, 166.665f, 157.133f, 124.225f};
  float[] chord = new float[6];
  ArrayList<Popper[]> pins = new ArrayList<Popper[]>();
  int filler = color(255, 255, 255);
  int background;
  int theOne = -1;// set the selected row

  boolean[] canSelect = new boolean[6];// checks if row can be selected
  int[] f = new int[6];// checks if player hit new pin
  boolean locked = false;//locks player into their row
  boolean play = false;//allows to play the game used to wait so it doesnt autoclick the gameboard
  int turn = -1;//used to control which turn we are on
  int v = 0;//controls the changing of turns
  Player[] gamers;
  Screen imon;

  Board(int background, Screen imon) {
    this.imon = imon;
    x = width/2;
    y = height/2;
    size = (x+y)/1.5f;
    start = y - size/2;
    this.background = background;
    pins.add(new Popper[3]);
    pins.add(new Popper[5]);
    pins.add(new Popper[6]);
    pins.add(new Popper[6]);
    pins.add(new Popper[5]);
    pins.add(new Popper[3]);
    float n = 5;
    for (int i = 0; i < chord.length; i++) {
      chord[i] = size * (chords[i]/333.33f);
      canSelect[i] = true;
      float tempY = start+(i*(size/6)) + ((size/6))/2;
      float tempS = (size/6)*3/4;
      if (i < 3) {
        n = n - (n-1)/2;
      } else if (i == 3) {
        n = 1.5f;
      } else n = n + (n-1);

      float tempX = x-(chord[i]/n);
      Popper[] list = pins.get(i);

      for (int k = 0; k < list.length; k++) {
        list[k] = new Popper();
        Popper p = list[k];
        p.setVars(tempX+2*k + tempS*k, tempY, tempS, tempS);
      }
    }
  }

  public void setPlayers(Player[] Players) {
    gamers = Players;
  }
  public void reset() {
    play = false;
    theOne = -1;
    turn = -1;
    locked = false;
    for (Popper[] list : pins) {
      for (Popper c : list) {
        c.hasbeenPushed = false;
        c.filler = 0;
      }
    }
    for (int i = 0; i < canSelect.length; i++) {
      canSelect[i] = true;
      f[i] = 0;
    }
    v = 0;
  }

  public void unlock() {
    theOne = -1;
    locked = false;
    if (!gameOver()) {
      if (turn == 0 && v == 0) {
        turn = 1;
        v++;
      } else if (turn == 1 && v == 0) {
        turn = 0;
        v++;
      }
    }
  }

  public void display() { 
    int g = 0;//how many clicked
    //int c = 0;// how many not clicked

    if (theOne != -1) {
      for (Popper a : pins.get(theOne)) {
        a.clicked();
        if (a.hasbeenPushed) {
          g++;
        }// else c++;
      }
    }

    for (int i = 0; i < chord.length; i++) {
      float tempX = x-chord[i];
      float tempY = start+(i*(size/6));
      float tempSX = chord[i]*2;
      float tempSY = size/6;
      int n = 0;
      for (Popper b : pins.get(i)) {
        if (b.hasbeenPushed) {
          n++;
        }
      }
      if (n == pins.get(i).length) {
        canSelect[i] = false;
      }
      //select row
      if (mouseOver(tempX, tempY, tempSX, tempSY) && mousePressed && mouseButton == LEFT && canSelect[i] && !locked && play) {
        theOne = i;
        locked = true;
        v = 0;
        //println("reeeeeeeeeee");
      }

      //changes turns
      if (theOne != -1) {
        //if (keyPressed  && g > f[theOne]) {
        //  if (key == CODED) {
        //    if (keyCode == SHIFT) {
        //      f[theOne] = g;
        //      unlock();
        //    }
        //  }
        //}
        //if (g > f[theOne]) {
        //  if (mousePressed && mouseButton == RIGHT) {
        //    f[theOne] = g;
        //    unlock();
        //  }
        //}
        if (g > f[theOne]) {
          if (imon.button(width - 60, height*.8f, 100, 30, "Next Turn")) {
            f[theOne] = g;
            unlock();
          }
        }
      }
      //automatically unlocked when selecting all pins
      if (!canSelect[i] && theOne == i) {
        unlock();
      }
      //visual shit
      if (theOne == i && locked) {
        switch(turn) {
        case 0:
          filler = color(0, 0, 255);
          break;
        case 1:
          filler = color(255, 165, 0);
          break;
        }
      }
      pushMatrix();
      fill(filler);
      stroke(255, 0, 255);
      strokeWeight(2);
      rectMode(CORNER);
      rect(tempX, tempY, tempSX, tempSY);
      popMatrix();
    }
    for (Popper[] list : pins) {
      for (Popper p : list) {
        p.display();
      }
    }



    noFill();
    stroke(background);
    //strokeWeight(1);
    //ellipse(x, y, size, size);
    strokeWeight(size/6);
    rectMode(CENTER);
    ellipse(x, y, size+size/6, size+size/6);
    //rect(x, y, size+size/6, size+size/6);
    endShape();
    pushMatrix();
    textSize(48);
    textAlign(CENTER, CENTER);
    fill(255);
    text(gamers[turn].toString(), width/2, height*.05f);
    popMatrix();
    if (gameOver()) {
      System.out.printf("%s lost%n ", gamers[turn]);
    }
    if (!mousePressed) play = true;
  }
  public boolean gameOver() {
    int n = 0;
    for (boolean m : canSelect) {
      if (!m) {
        n++;
      }
    }
    if (n == canSelect.length) {    
      return true;
    }
    return false;
  }
  public void setTurn(int t) {
    play = false;
    turn = t;
  }
  public Player getLoser() {
    if (gameOver()) {
      return gamers[turn];
    }
    return null;
  }
  public boolean mouseOver(float x, float y, float wid, float len) {
    float dx = mouseX - this.x;
    float dy = mouseY - this.y;
    float distance = sqrt((dx*dx) + (dy*dy));
    if (distance < size/2 + 1) {
      if (mouseX < x+wid && mouseX > x && mouseY < y+len && mouseY > y) {
        filler = 127;
        if (locked) filler = 255;
        return true;
      }
    }
    filler = 255;
    return false;
  }
  public String toString() {
    return "Turn:"+turn;
  }
}

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
  public void display() {
    switch(gamemode) {
    case 0:
      pushMatrix();
      fill(255);
      textAlign(LEFT);
      textSize(48);
      text(name, .6f*width/pow(playerNum, 2), height/2);
      rectMode(CORNER);
      if (playerNum == 2) {
        fill(0, 0, 255, 50);
      } else fill(255, 165, 0, 50);
      noStroke();
      rect(0 +abs(playerNum - 2)*.6f*width/pow(playerNum, 2) - 10*abs(playerNum - 2), 0, 10+.6f*width/pow(playerNum, 2) + (playerNum - 1)*185, height);
      popMatrix();
      break;
    case 1:
    pushMatrix();
      fill(255);
      textAlign(CENTER,CENTER);
      textSize(48);
      text(name, width/2,height*.3f);
      popMatrix();
      break;
    }
  }

  public void reset() {
  }

  //void skipTurn
  public String toString() {
    String s = String.format("%s", name);
    return  s;
  }
}

class Popper {

  float x, y;
  float sizeX, sizeY;
  int filler = color(0, 0, 0);
  boolean hasbeenPushed = false;
  Popper() {
  }
  public void setVars(float x, float y, float sizeX, float sizeY) {
    this.x = x;
    this.y = y;
    this.sizeX = sizeX;
    this.sizeY = sizeY;
  }
  public void display() {
    if (hasbeenPushed) {
      filler = color(255, 0, 0);
    }
    if (!hasbeenPushed && !mouseOver()) {
      filler = 0;
    }
    fill(filler);
    noStroke();
    ellipse(x, y, sizeX, sizeY);
  }

  public boolean mouseOver() {
    float dx = x - mouseX;
    float dy = y - mouseY;
    float distance = sqrt((dx*dx) + (dy*dy));
    if (distance < sizeX/2) {
      return true;
    }
    return false;
  }
  public void clicked() {
    if (mouseOver()) {
      filler = color(70, 255, 70);
      if (mousePressed && mouseButton == LEFT) {
        hasbeenPushed = true;
      }
    }
  }
}
class Screen implements Screen_Object {
  ArrayList<Screen_Object> screenlist = new ArrayList<Screen_Object>();
  String screenName;
  boolean screenOn = true;
  Screen(String screenName) {
    this.screenName = screenName;
  }

  public void display() {
    if (screenOn) {
      for (Screen_Object o : screenlist) {
        o.display();
      }
    }
  }
  public void reset() {
    for (Screen_Object o : screenlist) {
      o.reset();
    }
  }
  public Screen_Object getSObject(int index ) {
    //System.out.printf("%s%n", screenlist.get(index));
    return screenlist.get(index);
  }
  public Board getBoard(int index) {
    for (int i = 0; i < screenlist.size(); i++) {
      Screen_Object p = screenlist.get(i);
      if (p instanceof Board && i == index) {
        return (Board) p;
      }
    }
    return null;
  }
  public void addScreenObject(Screen_Object o) {
    screenlist.add(o);
  }
  public void addScreenObject(Screen_Object[] o) {
    for (Screen_Object p : o) screenlist.add(p);
  }

  public void removeScreenObject(Screen_Object o) {
    for (int i = 0; i < screenlist.size(); i++) {
      if (screenlist.get(i) == o) {
        screenlist.remove(i);
      }
    }
  }
  public void turnScreenOff() {
    screenOn = false;
  }

  public void turnScreenOn() {
    screenOn = true;
  }

  public String toString() {
    return screenName;
  }
  public void addText(String s, float x, float y, int size, int c) {
    if (screenOn) {
      pushMatrix();
      fill(c);
      textSize(size);
      textAlign(CENTER, CENTER);
      text(s, x, y);
      popMatrix();
    }
  }
  public boolean button(float x, float y, float wid, float len, String text) {
    if (screenOn) {
      pushMatrix();
      stroke(255);
      strokeWeight(2);
      fill(127);
      rectMode(CENTER);
      rect(x, y, wid, len);
      fill(255);
      textAlign(CENTER, CENTER);
      textSize(18);
      text(text, x, y, wid, len);
      popMatrix();

      if (mousePressed && mouseButton == LEFT && (mouseX < x+wid/2 && mouseX > x-wid/2 && mouseY < y+len/2 && mouseY > y-len/2)) {
        //println(text+" has been clicked");
        return true;
      }
    }
    return false;
  }
}

interface Screen_Object {
  public void display();
  public void reset();
  public String toString();
}
class Selector implements Screen_Object {
  PImage arrow;
  float rotation;
  boolean rotating = true;
  int decide = -1;
  float spd = 8;
  Screen imon;
  Player[] gamers; 
  Selector(Player[] pl,Screen s) {
    imon = s;
    arrow = loadImage("arrow2.png");
    gamers = pl;
  }
  float angle = 0;
  boolean been_clicked = false;
  public void display() {
    
    if(angle < 6){
      angle = rotation*TWO_PI/360;
    } else {
      angle = 0;
      rotation = 0;
    }
    if(imon.button(width/2,height*.3f,70,30,"Pick")){
      been_clicked = true;
    }
    rotation+=spd;
    if(been_clicked){
      if(spd > 0){
        spd-=0.05f;
      } else spd = 0;
    }
    if(spd == 0){
      if(round(angle) <= 4 && round(angle) > 1){
        decide = 0;
      }else decide = 1;
    }
    pushMatrix();
    translate(width*.5f, height*.5f);
    if (rotating) {
      rotate(angle);
    }
    translate(-60, -60);
    image(arrow, 0, 0,120,120);
    popMatrix();
    //println("Angle: "+round(angle)+" SPD: "+spd+" Rotation: "+rotation+" decide: "+decide );
    if(keyPressed && key == ENTER) reset();
  }
  public void reset() {
    spd = 8;
    been_clicked = false;
    decide = -1;
  }
  public int getDecision(){
    return decide;
  }
  public String toString(){
    String s = String.format("Selector decide: %d",decide);
    return s;
  }
}

  public void settings() {  size(800, 600); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "PopIt" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
