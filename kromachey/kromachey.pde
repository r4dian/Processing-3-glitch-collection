PImage fgimg, bgimg, output, fgmap;
int redmin = -1, redmax = 20;
int greenmin = 150, greenmax = 190;
int bluemin = 170, bluemax = 250;

void setup() {
  size(100,100,P3D);
  fgimg = loadImage("fg.jpg");
  bgimg = loadImage("bg.png");
  surface.setSize(bgimg.width,bgimg.height);
}

Boolean iscromcol(color c) { 
  int blue = (int)blue(c);
  int red = (int)red(c);
  int green = (int)green(c);
  return blue > bluemin && blue < bluemax && 
    green > greenmin && green < greenmax &&
    red > redmin && red < redmax;
}
void draw() { 
  background(0);
  fgimg.loadPixels();
  bgimg.loadPixels();
  output = createImage(bgimg.width, bgimg.height, RGB);
  fgmap = createImage(bgimg.width, bgimg.height, RGB);
  fgmap.copy(fgimg, 0, 0, fgimg.width, fgimg.height, 0, 0, fgmap.width, fgmap.height);
  fgmap.loadPixels();
  for ( int x = 0, w = output.width; x<w; x++ ) { 
    for ( int y = 0, h = output.height; y<h; y++ ) { 
      int p = x + y * w;
      color c = bgimg.pixels[p];
      color fc = fgmap.pixels[p];
      if ( !iscromcol(fc)) { 
        c = fgmap.pixels[p];
      }      
      output.pixels[p] = c;
    }
  }
  output.updatePixels();
  image(output, 0, 0);
  output.save("result.png");
  exit();
}

void mouseMoved() { 
  int p = mouseX + mouseY * width;
  color c = fgmap.pixels[p];
  println("R: "+(int)red(c)+", G: "+(int)green(c)+", B: "+(int)blue(c));
}