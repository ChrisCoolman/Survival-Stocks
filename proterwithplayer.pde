import org.guilhermesilveira.Timers;

int tileSize = 15; // higher is zoomed in
float scale = 0.01; // lower is more quality
float rizz = 0.2;
long seed = round(random(0, 10000000));
float xoff = 500;
float yoff = 500;
float speed = 0.01;
boolean ui = false;
int money = 0;
boolean up = false;
boolean down = false;
boolean left = false;
boolean right = false;
int frameNum = 0;
int speedChange = 2; // higher the number the slower the player (doesnt break everything when slowing down)
String currentTile = "";
float skib;
int screen = 1;
int rectX, rectY;      // Position of square button
int rectLength, rectWidth;
color rectColor, baseColor;
color rectHighlight;
color currentColor;
boolean rectOver = false;
boolean rectOver2 = false;
ArrayList<TEXTBOX> textboxes = new ArrayList<TEXTBOX>();
boolean send = false;
String msg = "";
String save = "";
String saveYoff = "", saveXoff = "", saveSeed = "", saveMoney = "", saveCodAmount = "", saveSandAmount = "", saveDirtAmount = "", saveTwigAmount = "", saveRockAmount = "", savePurewaterAmount = "", saveCodPrice = "", saveSandPrice = "", saveDirtPrice = "", saveTwigPrice = "", saveRockPrice = "", savePurewaterPrice = "";
int saveStage = 1;

// ITEMS

//ocean
item cod;
//beach
item sand;
//plains
item dirt;
//forest
item twig;
//mountain
item rock;
//snow
item purewater;
void setup() {
  size(1920, 1080);
  // runs every second, 10 times, invokes a lambda
  new Timers(this).add(1000, 10, () -> tick());
  noStroke();
  colorMode(HSB);
  //  noiseDetail(8, 0.6); // changes stuff check docs
  noiseSeed(seed);
  textSize(50);
  frameRate(60);
  rectColor = color(0);
  rectHighlight = color(51);
  baseColor = color(102);
  currentColor = baseColor;
  rectX = 770;
  rectY = 540;
  rectLength = 300;
  rectWidth = 100;
  //   tick();
  // items

  //walter white refrence???!?!?!?!!
  cod = new item(2, 0, 1);
  //beach
  sand = new item(1, 0, 1);
  //grass
  dirt = new item(2, 0, 1);
  //forest
  twig = new item(3, 0, 1);
  //mountain
  rock = new item(3, 0, 1);
  //snow
  purewater = new item(5, 0, 2);
}

void draw() {
  if (screen == 1) {
    textSize(200);
    background(100, 255, 255);
    fill(0);
    text("Survival Stocks!", 300, 340);
    textSize(50);
    update();
    drawButton(rectX, rectY, rectLength, rectWidth, "Start");
    drawButton2(rectX, rectY + 120, rectLength, rectWidth, "Load");
    InitLayout();
  }
  if (screen == 2) {
    background(0);
    fill(255);
    textSize(100);
    text("Enter save code:", width/2 - 350, 400);
    for (TEXTBOX t : textboxes) {
      t.DRAW();
    }
    if (send) {
      readSave();
      screen = 4;
    }
  }
  if (screen == 3) {
  }
  if (screen == 4) {
    currentTile = checkColor();
    frameNum++;
    noStroke();
    //  cod.update();
    drawTerrain();
    checkMovement();
    drawPlayer();
    ui();
    textSize(50);
    fill(0);
    //text("Cod: " + cod.getAmount(), 50, 50);
    textAlign(BASELINE);
    text("Biome: " + currentTile, 50, 50); // keep this in final version
    text(mouseX, 50, 100);
    text(mouseY, 50, 150);

    // amount of items
    text("Cod: " + cod.getAmount(), 1650, 50);
    text("Sand: " + sand.getAmount(), 1650, 100);
    text("Dirt: " + dirt.getAmount(), 1650, 150);
    text("Twig: " + twig.getAmount(), 1650, 200);
    text("Rock: " + rock.getAmount(), 1650, 250);
    text("Purewater: " + purewater.getAmount(), 1650, 300);
    fill(0);
  }
  if (screen == 5) {
  }
}

void tick()
{
  cod.update();
  sand.update();
  dirt.update();
  twig.update();
  rock.update();
  purewater.update(); // its pure becasue it from the snow melting !?!?!??!?!??!
}

void ui() {
  if (ui)
  {
    strokeWeight(12);
    stroke(#7E3E1D);
    fill(#AF6A47); // menu color
    rect(450, 150, 1050, 800); // menu
    textAlign(CENTER);
    fill(#25D100); // money color
    text("$" + money, width / 2, height / 2 - 300); // money
    textSize(20);
    fill(#7E3E1D);
    rect(500, 275, 100, 50);
    fill(255);
    text("Sell Cod: $" + cod.getPrice(), 550, 305); // cod button
  }
}

void mousePressed() {
  print("Mouse Pressed");
  if (ui) // if ui is open
  {
    print("UI OPEN");
    if (mouseX >= 500 && mouseX <= 600 && mouseY >= 600 && mouseY <= 650)
    {
      print("MOUSE IN POSITION");
      if (cod.getAmount() > 0)
      {
        print("cod");
        money+=cod.getPrice();
        cod.addAmount(-1);
      }
    }
  }
  if (rectOver) {
    screen = 4;
    // currentColor = rectColor;
  }
  if (rectOver2) {
    screen = 2;
  }
  for (TEXTBOX t : textboxes) {
    t.PRESSED(mouseX, mouseY);
  }
}

void drawPlayer() {
  fill(0);
  rect(width / 2, height / 2, tileSize, tileSize);
}

void drawTerrain() {
  for (int i = 0; i < width/tileSize; i++) {
    for (int j = 0; j < height/tileSize; j++) {
      fill(getColour(i, j));
      rect(i * tileSize, j * tileSize, tileSize, tileSize);
    }
  }
}

void keyPressed() {
  /*
  if(key == ' ') {
   seed = round(random(0, 10000000));
   noiseSeed(seed);
   drawTerrain();
   }
   */
  if (key == 'g')
  {
    if (checkColor().equals("Deep Ocean"))
    {
      skib = random(1, 1);
      if (skib == 1)
      {
        cod.addAmount(1);
      }
    } else if (checkColor().equals("Ocean"))
    {
      skib = random(1, 1);
      if (skib == 1)
      {
        cod.addAmount(1);
      }
    } else if (checkColor().equals("Beach"))
    {
      skib = random(1, 1);
      if (skib == 1)
      {
        sand.addAmount(1);
      }
    } else if (checkColor().equals("Plains"))
    {
      skib = random(1, 1);
      if (skib == 1)
      {
        dirt.addAmount(1);
      }
    } else if (checkColor().equals("Forest"))
    {
      skib = random(1, 1);
      if (skib == 1)
      {
        twig.addAmount(1);
      }
    } else if (checkColor().equals("Low Mountain"))
    {
      skib = random(1, 1);
      if (skib == 1)
      {
        rock.addAmount(1);
      }
    } else if (checkColor().equals("High Mountain"))
    {
      skib = random(1, 1);
      if (skib == 1)
      {
        rock.addAmount(1);
      }
    } else if (checkColor().equals("Mountain Peak"))
    {
      skib = random(1, 1);
      if (skib == 1)
      {
        purewater.addAmount(1);
      }
    }
  }
  if (key == 'f')
  {
    if (ui == true)
      ui = false;
    else
      ui = true;
  }
  if (key == 'w' && yoff > 0 + speed)
  {
    up = true;
  }
  if (key == 's')
  {
    down = true;
  }
  if (key == 'a' && xoff > 0 + speed)
  {
    left = true;
  }
  if (key == 'd')
  {
    right = true;
  }
  if (key == 't') {
    save = xoff + "*" + yoff + "*" + seed + "*" + money + "*" + cod.getAmount() + "*" + sand.getAmount() + "*" + dirt.getAmount() + "*" + twig.getAmount() + "*" + rock.getAmount() + "*" + purewater.getAmount() + "*" + cod.getPrice() + "*" + sand.getPrice() + "*" + dirt.getPrice() + "*" + twig.getPrice() + "*" + rock.getPrice() + "*" + purewater.getPrice();
    System.out.println(save);
  }
  for (TEXTBOX t : textboxes) {
    if (t.KEYPRESSED(key, keyCode)) {
      send = true;
      msg = textboxes.get(0).Text;
    }
  }
}
/*
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
 */
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
  if (key == 'c') {
    checkColor();
    System.out.println(xoff + ", " + yoff);
  }
}

void readSave() {
  for (int i = 0; i < msg.length(); i++) {
    char c = msg.charAt(i);
    if (Character.isLetter(c)) {
      exit();
    } else if (c == '*') {
      saveStage++;
    } else if (Character.isDigit(c) || c == '.') {
      if (saveStage == 1) {
        saveXoff = saveXoff + c;
      } else if (saveStage == 2) {
        saveYoff = saveYoff + c;
      } else if (saveStage == 3) {
        saveSeed = saveSeed + c;
      } else if (saveStage == 4) {
        saveMoney = saveMoney + c;
      } else if (saveStage == 5) {
        saveCodAmount = saveCodAmount + c;
      } else if (saveStage == 6) {
        saveSandAmount = saveSandAmount + c;
      } else if (saveStage == 7) {
        saveDirtAmount = saveDirtAmount + c;
      } else if (saveStage == 8) {
        saveTwigAmount = saveTwigAmount + c;
      } else if (saveStage == 9) {
        saveRockAmount = saveRockAmount + c;
      } else if (saveStage == 10) {
        savePurewaterAmount = savePurewaterAmount + c;
      } else if (saveStage == 11) {
        saveCodPrice = saveCodPrice + c;
      } else if (saveStage == 12) {
        saveSandPrice = saveSandPrice + c;
      } else if (saveStage == 13) {
        saveDirtPrice = saveDirtPrice + c;
      } else if (saveStage == 14) {
        saveTwigPrice = saveTwigPrice + c;
      } else if (saveStage == 15) {
        saveRockPrice = saveRockPrice + c;
      } else if (saveStage == 16) {
        savePurewaterPrice = savePurewaterPrice + c;
      }
    }
  }
  xoff = Float.parseFloat(saveXoff);
  yoff = Float.parseFloat(saveYoff);
  seed = Long.parseLong(saveSeed);
  money = Integer.parseInt(saveMoney);
  cod.setAmount(Integer.parseInt(saveCodAmount));
  sand.setAmount(Integer.parseInt(saveSandAmount));
  dirt.setAmount(Integer.parseInt(saveDirtAmount));
  twig.setAmount(Integer.parseInt(saveDirtAmount));
  rock.setAmount(Integer.parseInt(saveRockAmount));
  purewater.setAmount(Integer.parseInt(savePurewaterAmount));
  cod.setPrice(Integer.parseInt(saveCodPrice));
  sand.setPrice(Integer.parseInt(saveSandPrice));
  dirt.setPrice(Integer.parseInt(saveDirtPrice));
  twig.setPrice(Integer.parseInt(saveDirtPrice));
  rock.setPrice(Integer.parseInt(saveRockPrice));
  purewater.setPrice(Integer.parseInt(savePurewaterPrice));
  noiseSeed(seed);
}

String checkColor() {
  float blockColor = noise(xoff + 9.65/tileSize, yoff + 5.46/tileSize) - rizz; //mostly works on all sizes now // for 5: 1.93, 1.09
  if (blockColor < 0.1)
  {
    return "Deep Ocean";
  } else if (blockColor < 0.2)
  {
    return "Ocean";
  } else if (blockColor < 0.3)
  {
    return "Beach";
  } else if (blockColor < 0.4)
  {
    return "Plains";
  } else if (blockColor < 0.5)
  {
    return "Forest";
  } else if (blockColor < 0.6)
  {
    return "Low Mountain";
  } else if (blockColor < 0.7)
  {
    return "High Mountain";
  } else
  {
    return "Mountain Peak";
  }
}

void update() {
  if ( overRect(rectX, rectY, rectLength, rectWidth) ) {
    rectOver = true;
    rectOver2 = false;
  } else if (overRect(rectX, rectY + 120, rectLength, rectWidth)) {
    rectOver = false;
    rectOver2 = true;
  } else {
    rectOver = false;
    rectOver2 = false;
  }
}

boolean overRect(int x, int y, int width, int height) {
  if (mouseX >= x && mouseX <= x+width &&
    mouseY >= y && mouseY <= y+height) {
    return true;
  } else {
    return false;
  }
}

void drawButton(int x, int y, int l, int w, String text) {
  if (rectOver) {
    fill(rectHighlight);
  } else {
    fill(rectColor);
  }
  stroke(255);
  rect(x, y, l, w);
  textSize(100);
  fill(255);
  text(text, rectX + 45, rectY + 80);
}

void drawButton2(int x, int y, int l, int w, String text) {
  if (rectOver2) {
    fill(rectHighlight);
  } else {
    fill(rectColor);
  }
  stroke(255);
  rect(x, y, l, w);
  textSize(100);
  fill(255);
  text(text, rectX + 45, rectY + 200);
}

void InitLayout() {
  TEXTBOX receiver = new TEXTBOX();
  receiver.W = 1000;
  receiver.H = 50;
  receiver.X = (width - receiver.W) / 2;
  receiver.Y = 500;
  textboxes.add(receiver);
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
  if (v < 0.1)
  {
    return color(#08CBFF);
  } else if (v < 0.2)
  {
    return color(#0ADCFF);
  } else if (v < 0.3)
  {
    return color(#FFD80F);
  } else if (v < 0.4)
  {
    return color(#1FB72A);
  } else if (v < 0.5)
  {
    return color(#106A16);
  } else if (v < 0.6)
  {
    return color(#C4C4C4);
  } else if (v < 0.7)
  {
    return color(#717171);
  } else
  {
    return color(255);
  }
}
