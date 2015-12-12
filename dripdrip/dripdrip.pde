
String fn = "source.jpg";
int maxsteps = 100;
int minsteps = 2;
Boolean brightmode = false;
Boolean autotoggle = false;
PImage img;
void setup() { 
  img = loadImage(fn);
  size(img.width, img.height, P2D);
  //image(img, 0, 0);
  noLoop();
}

void draw() { 
  img.loadPixels();
  int steps;
  for ( int x = 0, w = img.width; x<w; x++) { 
    for ( int h = img.height, y = h-1; y>-1; y--) { 
      if ( autotoggle ) { 
        brightmode = y > h/2;
      }
      float rat = 1.0;
      int pos = x + y * w;
      color c = img.pixels[pos];
      int ty = y;
      steps = (int)map(random(1), 0, 1, minsteps, maxsteps);
      while ( rat > 1.0/steps*2 ) { 
        ty++;
        if ( ty >= h ) break;
        int tpos = x + ty * w;
        color tc = img.pixels[tpos];
        if ( 
        ( !brightmode && brightness(tc) < brightness(c) ) 
          || ( brightmode && brightness(tc) > brightness(c) )
          ) break;
        img.pixels[tpos] = blendC(tc, c, rat);
        rat-= rat/steps;
      }
    }
  }
  img.updatePixels();
  image(img, 0, 0);
  save("result.png");
}
color blendC(color tc, color sc, float rat) { 
  return color(
  (red(tc)*(1.0-rat))+(red(sc)*rat), 
  (green(tc)*(1.0-rat))+(green(sc)*rat), 
  (blue(tc)*(1.0-rat))+(blue(sc)*rat)
    );
}

