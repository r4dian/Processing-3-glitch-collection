/* Echo - a processing port of audacity's Echo.cpp 
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
  PImage result = createImage(img.width,img.height, RGB);
  float _delay = map(xp,0,100,0.001,1.0);
  float decay = map(yp,0,100,0.0,1.0);
  int delay = (int)(img.pixels.length * _delay);
  color[] history = new color[img.pixels.length];
  int blendMode = BLEND;
  img.loadPixels(); result.loadPixels();
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
      r + red(origColor),
      g + green(origColor),
      b + blue(origColor) );
    
    result.pixels[i] = history[i] = blendColor(origColor,toColor,blendMode);
  }  
  return result;
}

/*
PImage auEchoWTF(PImage img, int xp, int yp) { 
  PImage result = createImage(img.width,img.height, RGB);
  float delay = map(xp,0,100,0.001,5);
  float decay = map(yp,0,100,0.0,5.0);
  int histPos = 0;
  int histLen = img.pixels.length*3;
  float[] history = new float[histLen*3];
  
  img.loadPixels(); result.loadPixels();
  float ibuf = 0.0, obuf = 0.0;
  float[] rgb = new float[3];
  for ( int i = 0, l = img.pixels.length; i<l; i++, histPos++) { 
     color c = img.pixels[i];
     rgb[0] = map(red(c),0,255,0,1);
     rgb[1] = map(green(c),0,255,0,1);
     rgb[2] = map(blue(c),0,255,0,1);
     history[i] = rgb[0];
     history[i+1] = rgb[1];
     history[i+2] = rgb[2];
     
  }
  for ( int i = 0, l = img.pixels.length; i<l; i++, histPos++) { 
     color c = img.pixels[i];
     rgb[0] = map(red(c),0,255,0,1);
     rgb[1] = map(green(c),0,255,0,1);
     rgb[2] = map(blue(c),0,255,0,1);

     if ( histPos == histLen ) histPos = 0;
     for ( int ri = 0; ri < 3; ri++ ) { 
       history[histPos+ri] = rgb[ri] = rgb[ri] + history[histPos+ri] * decay;
     }
     color out = color( 
       (int)map(rgb[0],0,1,0,255),
       (int)map(rgb[1],0,1,0,255),
       (int)map(rgb[2],0,1,0,255));
     result.pixels[i] = out;
  }
  
  return result;
  
  
}

*/