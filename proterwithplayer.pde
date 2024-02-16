int tileSize = 15; // higher is zoomed in
float scale = 0.01; // lower is more quality
float rizz = 0.2;
long seed = round(random(0, 10000000));
float xoff = 50;
float yoff = 50;
float speed = 0.01;
boolean ui = false;
int money = 0;
boolean up = false;
boolean down = false;
boolean left = false;
boolean right = false;
int frameNum = 0;
int speedChange = 2; // higher the number the slower the player (doesnt break everything when slowing down)

void setup() {
   size(1920, 1080);
   noStroke();
   colorMode(HSB);
 //  noiseDetail(8, 0.6); // changes stuff check docs
   noiseSeed(seed);
   drawTerrain();
   drawPlayer();
   textSize(50);
   frameRate(60);
}

void draw() {
  frameNum++;
  noStroke();
  drawTerrain();
  checkMovement();
  drawPlayer();
  ui();
  fill(0);
  text(rizz, 50, 50);
  text(mouseX, 50, 100);
  text(mouseY, 50, 150);
  fill(0);
}

void ui() {
  if(ui)
  {
    strokeWeight(12);
    stroke(#7E3E1D);
    fill(#AF6A47); // menu color
    rect(450, 150, 1050, 800); // menu
    textAlign(CENTER);
    fill(#25D100); // money color
    text("$" + money, width / 2, height / 2 - 300); // money
    fill(#7E3E1D);
    rect(900, 500, 100, 50);
    fill(255);
    text("Sell", 950, 540);
  }
}

void mousePressed() {
   if(ui)
   {
     if(mouseX >= 900 && mouseX <= 1000 && mouseY >= 500 && mouseY <= 550)
     {
       money++;
     }
   }
}

void drawPlayer() {
   fill(0);
   rect(width / 2, height / 2, tileSize * 2, tileSize * 2); 
}

void drawTerrain() {
     for(int i = 0; i < width/tileSize; i++) {
     for(int j = 0; j < height/tileSize; j++) {
       fill(getColour(i, j));
       rect(i * tileSize, j * tileSize, tileSize, tileSize);
     }
   }
}

void keyPressed() {
  if(key == ' ') {
    seed = round(random(0, 10000000));
    noiseSeed(seed);
    drawTerrain();
  }
  if(key == 'g')
  {
    ui = true;
  }
  if(key == 'f')
  {
    if(ui == true)
      ui = false;
    else
      ui = true;
  }
  if(key == 'w' && yoff > 0 + speed)
  {
    up = true;
  }
  if(key == 's')
  {
    down = true;
  }
  if(key == 'a' && xoff > 0 + speed)
  {
    left = true;
  }
  if(key == 'd')
  {
    right = true;
  }
}

void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  if(e < 0)
  {
    rizz+=0.001;
  } else
  {
    rizz-=0.001;
  }
}

void checkMovement() {
  if (up && frameNum % speedChange == 0) {
    yoff-=speed;
  }
  if (down && frameNum % speedChange == 0) {
    yoff+=speed;
  }
  if (left && frameNum % speedChange == 0) {
    xoff-=speed;
  }
  if (right && frameNum % speedChange == 0) {
    xoff+=speed;
  }
}

void keyReleased() {
if (key == 'w') {
    up = false;
  }
if (key == 's') {
    down = false;
  }
if (key == 'a') {
    left = false;
  }
if (key == 'd') {
    right = false;
  }
}

color getColour(int x, int y) {
  float v = noise(xoff + x * scale, yoff + y * scale) - rizz;
  /*
  if(v < 0.3) {
    return color(#0009E3);
  } else if(v < 0.4) {
    return color(30, 255, 255);
  } else if(v < 0.7) {
    return color(66, 255, 255);
  } else {
    return color(80, 255, 100);
  }
  */
  if(v < 0.1)
  {
    return color(#08CBFF);
  } else if(v < 0.2)
  {
    return color(#0ADCFF);
  } else if(v < 0.3)
  {
    return color(#FFD80F);
  } else if(v < 0.4)
  {
    return color(#1FB72A);
  } else if(v < 0.5)
  {
    return color(#106A16);
  } else if(v < 0.6)
  {
    return color(#C4C4C4);
  } else if(v < 0.7)
  {
    return color(#717171);
  } else
  {
    return color(255);
  }
}
