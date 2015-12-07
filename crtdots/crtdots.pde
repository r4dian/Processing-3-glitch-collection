/* crtdots by Bob Verkouteren, sloppy sketch to draw crt like dots */

PImage img;
int dotspersize = 50;
String sourceImage = "source.jpg";
String resultImage = "result.png";
void setup() { 
  img = loadImage(sourceImage);
  size(img.width, img.height, P2D);
  noLoop();
}
//lol, sue me, this code could be so much more efficient
//but it works, and its called a sketch, so fsckit
void draw() { 
  background(0);
  int rad = (int)((float)width/3.0/dotspersize);
  int skip = 0;
  println(rad);
  noStroke();
  int pos = 0;
  color c = 0;
  for ( int y = rad, h = height; y<h; y+= rad ) { 
    if ( skip  <= -(rad*3) ) skip = 0;
    for ( int x = skip, w = width; x<w; x+= rad*3 ) {
      pos = x + y * w;
      if ( pos >= 0 && pos < img.pixels.length ) {
        c = img.pixels[pos]; 
        fill(color(red(c), 0, 0));
        ellipse(x, y, rad-1, rad-1);
      }
    }
    for ( int x = skip+rad, w = width; x<w; x+= rad*3 ) {
      pos = x + y * w;
      if ( pos >= 0 && pos < img.pixels.length ) {
        c = img.pixels[pos]; 
        fill(color(0, green(c), 0));
        ellipse(x, y, rad-1, rad-1);
      }
    }
    for ( int x = skip+rad*2, w = width; x<w; x+= rad*3 ) {
      pos = x + y * w;
      if ( pos >= 0 && pos < img.pixels.length ) {
        c = img.pixels[pos]; 
        fill(color(0, 0, blue(c)));
        ellipse(x, y, rad-1, rad-1);
      }
    }
    skip-=rad;
  }
  save(resultImage);
  println("Saved "+resultImage);
}

