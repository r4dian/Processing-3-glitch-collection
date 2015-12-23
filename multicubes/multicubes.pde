/* multicubes by teisu */
String imgPath = "source.jpg";
String resultPath = "result.jpg";
float scale = 1.618;
int w = 800, h = 800;
int bw = 10; //block width
int bm = 10; //block margin
int margin = 50; //at 0 rotation, border around cubes
color bgclr = 0;//color(230, 230, 230);
Boolean autoColor = true; //grab last pixel from the image for background color
int dropfloor = -60; //drop the floor (move camera up)
float degrX = 30; //rotateX
float degrY = 12; //rotateY
float degrZ = 0; //rotateZ
PImage img;
void setup() { 
  PImage _img = loadImage(imgPath);
  img = createImage((int)(_img.width*scale), (int)(_img.height*scale), RGB);
  img.copy(_img, 0, 0, _img.width, _img.height, 0, 0, img.width, img.height);
  size(w+(2*margin), h+(2*margin), P3D);
  if ( autoColor ) 
    bgclr = img.pixels[img.pixels.length-1];
  noLoop();
}

void draw() { 
  background(bgclr);
  noStroke();
  translate(margin, margin, 0);
  rotateX(radians(degrX));
  rotateY(radians(degrY));
  rotateZ(radians(degrZ));
  for ( int z = 0; z<255; z+= (bw+bm) ) { 
    for ( int x = 0; x<w; x+= (bw+bm) ) { 
      for ( int y = 0; y<h; y+= (bw+bm) ) { 
        color c = getcolor(img, x, y, w, h);
        pushMatrix();
        translate(x, y, dropfloor+z);
        fill(c);
        box(bw);
        popMatrix();
      }
    }
  }
  save(resultPath);
}

float opax = 127;
color getcolor(PImage img, int mx, int my, int mw, int mh) { 
  int sx = (int)map(mx, 0, mw, 0, img.width);
  int sy = (int)map(my, 0, mh, 0, img.height);
  color c = img.pixels[sx + sy * img.width];
  return color(red(c), green(c), blue(c), opax);
}

