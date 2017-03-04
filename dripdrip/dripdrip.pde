
String fn = "source.jpg";
int maxsteps = 100;  //maximum fade length in px
int minsteps = 2;   //minimum fade length in px
Boolean brightmode = false;  //if enabled will fade light over dark
Boolean autotoggle = true;  //switch brightmode at pivot point
float autotogglepivot = 0.58;  //where on the y axis (0-1) to switch
Boolean alternatetoggle = false;
PImage img;
void setup() {
  size(100,100,P2D);
  img = loadImage(fn);
  surface.setSize(img.width,img.height);
}

void draw() { 
  background(0);

  if (frameCount == 1 ) // skip 1st frame as setSize happens NEXT frame ...
    return;

  img.loadPixels();
  int steps;
  for ( int x = 0, w = img.width; x<w; x++) { 
    for ( int h = img.height, y = h-1; y>-1; y--) { 
      if ( alternatetoggle ) { 
        brightmode = !brightmode;
      } else { 
        if ( autotoggle ) { 
          brightmode = y > (h*autotogglepivot);
        }
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
  exit();
}
color blendC(color tc, color sc, float rat) { 
  return color(
  (red(tc)*(1.0-rat))+(red(sc)*rat), 
  (green(tc)*(1.0-rat))+(green(sc)*rat), 
  (blue(tc)*(1.0-rat))+(blue(sc)*rat)
    );
}