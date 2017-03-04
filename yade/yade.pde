/* yade (yet another displacement effect) by teisu */
 
PImage img, _img, map;
int tiles = 40;
Boolean autobg  = false;
int mindisplace = 10, maxdisplace = 150;
int minrotate = -3, maxrotate = 30;
int blendmode = LIGHTEST;

void setup() {
  size(100,100,P3D);
  surface.setResizable(true);
}

void draw() { 
  _img = loadImage("source.jpg");
  map = loadImage("source.jpg");
  surface.setSize(_img.width, _img.height);
  img = _img;
  background(!autobg ? 0 : _img.pixels[1]);

  if (frameCount == 1 ) // skip 1st frame as setSize happens NEXT frame ...
    return;

  float x, y, h, w;
  float tw = (float)img.width/(float)tiles;
  float th = (float)img.height/(float)tiles;

  blend(img,0,0,img.width,img.height,0,0,width,height,blendmode);
  for ( x = 0, w = img.width; x<w; x+=tw ) { 
    for ( y = 0, h = img.height; y<h; y+=th ) { 
      pushMatrix(); 
      int  z = getz(x,y);
      rotateY(radians(map(z,mindisplace,maxdisplace,minrotate,maxrotate)));
      rotateX(radians(map(z,mindisplace,maxdisplace,minrotate,maxrotate)));
      translate(0, 0, z);
      PImage tile = createImage((int)tw, (int)th, RGB);
      tile.copy(img, (int)x, (int)y, (int)tw, (int)th, 0, 0, tile.width, tile.height);
      image(tile, (int)x, (int)y); 
      popMatrix();
    }
  }
  save("result.jpg");
  exit();
} 

int getz(float x, float y) { 
  //return map(random(1), 0, 1, -100, 100) 
  int tx = (int)map(x,0,img.width,0,map.width);
  int ty = (int)map(y,0,img.height,0,map.height);
  int pos = tx + ty * map.width;
  return (int)map(brightness(map.pixels[pos]),0,255,mindisplace,maxdisplace);
}