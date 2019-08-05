PVector pos = new PVector();
PVector v = new PVector();
PVector a = new PVector();
PVector mouse = new PVector(mouseX, mouseY);
float V_FACTOR = 0.01;
float A_FACTOR = 1000;
float GRAVITY = 0.1;
int RADIUS = 25;
int oldTime, deltaTime;
boolean gameover = true;
int START_DELAY = 1000;
int timer;
int endtime, gametimer;

int BARWIDTH = 50;
float BAR_V_FACTOR = 0.1;
int BAR_START_GAP = 450;
float GAP_SHRINK_FACTOR = 0.005;
int GAPJUMP = 100;
int BARTIME = 800;

int bartimer;
float bargapGlobal = BAR_START_GAP;
int barold;
float[] bargap = new float [16];
int[] bar = new int [16];
float[] barY = new float [16];
boolean[] barAlive = new boolean [16];



void setup() {
  size(1000, 1000);
  frameRate(100);

  pos.set(width/2, height/4 );

  oldTime = millis();
  textAlign(CENTER);
  // rectMode(CENTER);
  barold = width/2-BAR_START_GAP/2;
  background(0);
  for (int i= 0; i<barAlive.length; i++) {
    barAlive[i] = false;
    bargap[i] = BAR_START_GAP;
  }
}


void draw() {
  int deltaTime = millis()-oldTime;
  oldTime = millis();
  // deltaTime *=100 ;
  //println(deltaTime);
  timer += deltaTime;
  if (!gameover) {
    background(255);
    fill(0);
    circle(pos.x, pos.y, RADIUS*2);

    if (timer>= START_DELAY) {
      gametimer += deltaTime;



      bartimer+= deltaTime;
      bargapGlobal -= deltaTime*GAP_SHRINK_FACTOR;
      if (bartimer >= BARTIME) {
        bartimer -= BARTIME;
        for (int i = 0; i< bar.length; i++) {
          if (!barAlive[i]) {
            barY[i] = -BARWIDTH;
            barAlive[i] = true;
            bar[i] = barold += random(-GAPJUMP, GAPJUMP);
            bargap[i] = bargapGlobal;
            println(bargap[i]);
            if (bar[i]<= 0) {
              bar[i] = 0;
              bar[i] += random(GAPJUMP);
            } else if (bar[i]+bargap[i] >= width) {
              bar[i] = width-int(bargap[i]);
              bar[i] -= random(GAPJUMP);
            }
            barold = bar[i];
            break;
          }
        }
      }
      for (int i = 0; i < bar.length; i++) {
        if (barAlive[i]) {
          barY[i] += deltaTime*BAR_V_FACTOR;
          if (barY[i] >= height) {
            barAlive[i] = false;
          } 
          rect(0, barY[i], bar[i], BARWIDTH);
          rect(bar[i]+bargap[i], barY[i], width-bar[i]-bargap[i], BARWIDTH);
        }
      }

      mouse.set(mouseX, mouseY);
      a.set(PVector.sub(pos, mouse));
      a.setMag(1/sq(a.mag()));
      //   a.setMag(1/a.mag());
      v.add(PVector.mult(a, deltaTime*A_FACTOR));
      v.y += GRAVITY*deltaTime;
      pos.add(PVector.mult(v, deltaTime*V_FACTOR));

      if (pos.x >= width - RADIUS || pos.x <= 0+RADIUS || pos.y >= height-RADIUS|| pos.y <= 0+RADIUS) {

        gameover = true;
        endtime = gametimer;
      }
      for (int i= 0; i< bar.length; i++) {
        if (pos.y-RADIUS <= barY[i]+BARWIDTH && pos.y +RADIUS >= barY[i]) {
          if (pos.x-RADIUS <= bar[i] || pos.x+RADIUS >= bar[i]+bargap[i]) {
            gameover = true;
            endtime = gametimer;
          }
        }
      }
    } else {
      float resttime = float((START_DELAY-timer)/100)/10;
      //println(resttime);
      text(int (resttime) + "." + (int(resttime *10))%10, width/2, height/2);
    }
  } else {
    fill(255);
    background(0);
    textSize(100);
    text("GAMEOVER", width/2, height/2);
    textSize(50);
    text("SCORE: " + endtime, width/2, height/2+100);
  }
}
void keyPressed() {
  if ( key == ' ' && gameover) {
    gameover = false;
    pos.set(width/2, height/5);
    v.set(0, 0);
    a.set(0, 0);
    timer = 0;
    gametimer = 0;
    bartimer = 0;
    barold = width/2-BAR_START_GAP/2;
    bargapGlobal = BAR_START_GAP;
    for (int i= 0; i<barAlive.length; i++) {
      barAlive[i] = false;
      barY[i] = -BARWIDTH;
      bar[i] = 0;
      bargap[i] = BAR_START_GAP;
    }
  }
}
