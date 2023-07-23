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
  void display() {
    
    if(angle < 6){
      angle = rotation*TWO_PI/360;
    } else {
      angle = 0;
      rotation = 0;
    }
    if(imon.button(width/2,height*.3,70,30,"Pick")){
      been_clicked = true;
    }
    rotation+=spd;
    if(been_clicked){
      if(spd > 0){
        spd-=0.05;
      } else spd = 0;
    }
    if(spd == 0){
      if(round(angle) <= 4 && round(angle) > 1){
        decide = 0;
      }else decide = 1;
    }
    pushMatrix();
    translate(width*.5, height*.5);
    if (rotating) {
      rotate(angle);
    }
    translate(-60, -60);
    image(arrow, 0, 0,120,120);
    popMatrix();
    //println("Angle: "+round(angle)+" SPD: "+spd+" Rotation: "+rotation+" decide: "+decide );
    if(keyPressed && key == ENTER) reset();
  }
  void reset() {
    spd = 8;
    been_clicked = false;
    decide = -1;
  }
  int getDecision(){
    return decide;
  }
  String toString(){
    String s = String.format("Selector decide: %d",decide);
    return s;
  }
}
