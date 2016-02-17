/* zigzag (moire) - a hidden image generator thingy doing zigzags, modified from mware.pde, same rounding error here as there, deal with it and play with barwidth if uncool glitched result  
 copyright(c) 2015 - mpd, released in the public domain 
 */

PImage img;
int barwidth = 6;
int picspace = 2;
int minbright = 20;
int zigheight = 40;
int dir = -1;
Boolean bothsides = true;
void settings() { 
  img = loadImage("source.jpg");
  size(img.width, img.height, P2D);
}

void setup() {
  noLoop();
  frameRate(1);
}
void draw() {
  Boolean bw = true;
  img.loadPixels();
  for (int y = 0, h = img.height; y<h; y++) { 
      if ( y % zigheight == 0 ) dir = -dir;
    for (int x = 0, w = img.width; x<w; x+=barwidth) { 
      for ( int i = 0; i < barwidth; i++ ) {
        int pos = (x+(dir*y)) + i + y * w;
        if ( pos >= img.pixels.length ) continue;
        int b = (int)brightness(img.pixels[pos]);
        b=constrain(minbright+(int)((float)b*1.618), 0, 255);//100;
        color c = color(b, b, b);
        if ( bw ) img.pixels[pos] = color(0);
        else 
          if ( ( bothsides && ( i < 0 + picspace || i >= barwidth-picspace ) ) ||
          ( !bothsides && i < 0 + picspace ) ) {
          img.pixels[pos] = c;
        } else { 
          img.pixels[pos] = color(255);
        } 
        if ( i == barwidth - 1 ) { 
          bw = !bw;
        }
      }
    }
  }

  image(img, 0, 0);
  save("result.png");
  println("Saved result.png");
}