/* auecho - a (more realistic) processing port of audacity's Echo.cpp 
 * Original by Dominic Mazzoni and Vaughan Johnson ( released under the GPL)
 * Port by darusen@applesandchickens.com 
 * Copyright (C) 2015 - darusen@applesandchickens.com - all rights reserved */
 
String inPath = "source.jpg";
String outPath = "result.png";
PImage img1;
void settings() { 
  img1 = loadImage(inPath); 
  size(img1.width,img1.height,P2D);
}
void setup() {
  frameRate(4);//noLoop();
}

void draw() { 
  int xp = (int)map(mouseX,0,width,0,100);
  int yp = (int)map(mouseY,0,height,0,100);
  image(auEcho(img1,xp,yp),0,0);
  
}
 
void mouseClicked() { 
  println("Saving "+outPath);
   save(outPath); 
  println("Saved");
}


PImage auEcho(PImage img, int xp, int yp) { 
  PImage result = createImage(img.width, img.height, RGB);
  float _delay = map(xp, 0, 100, 0.001, 1.0);
  float decay = map(yp, 0, 100, 0.0, 1.0);
  int delay = (int)(img.pixels.length * _delay);
  color[] history = new color[img.pixels.length];
  int blendMode = BLEND;
  img.loadPixels(); 
  result.loadPixels();
  for ( int i = 0, l = img.pixels.length; i<l; i++) {
    history[i] = img.pixels[i];
  }
  for ( int i = 0, l = img.pixels.length; i<l; i++) {
    int fromPos = i-delay < 0 ? l-abs(i-delay) : i-delay;
    color fromColor = history[fromPos];
    float r = red(fromColor) * decay;
    float g = green(fromColor) * decay;
    float b = blue(fromColor) * decay;
    color origColor = history[i];
    color toColor = color(
    r = r + red(origColor) > 255 ? r + red(origColor) - 255 : r + red(origColor), // simulate overflow ;)
    g = g + green(origColor) > 255 ? g + green(origColor) - 255 : g + green(origColor), 
    b = b + blue(origColor) > 255 ? b + blue(origColor) - 255 : b + blue(origColor)  );

    result.pixels[i] = history[i] = toColor; //blendColor(origColor, toColor, blendMode);
  }  
  return result;
}