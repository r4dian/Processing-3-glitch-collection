/* lame vhs like effect by teisu https://github.com/bobvk/sketches/vhs/ 
 click mouse to retry */

PImage img1,timg; 
String txt = "it only gets worse from here";
int virtw = 400, virth = 300;
void setup() {
  timg = loadImage("source.jpg");
  img1 = createImage(virtw,virth,RGB);
  img1.copy(timg,0,0,timg.width,timg.height,0,0,img1.width,img1.height);
  size(timg.width, timg.height, P2D);
  noLoop();
}

void draw() {   
  PImage hai = new Subtitle(txt).run(img1);
  PImage hay = sinwav(hai,1+(int)(random(1)*6),1+(int)(random(1)*6));
  PImage result = createImage(timg.width,timg.height,RGB);
  result.copy(interlaceImages(hai,hay),0,0,virtw,virth,0,0,result.width,result.height);
  image( result , 0, 0);
  result.save("result.png");
}

void mouseClicked() { 
  redraw();
}



class Subtitle implements IConfigurableEffect { 
  color _fgColor, _bgColor;
  String _txt;

  Subtitle(String text) { 
    _conf = new HashMap<String, Object>();
    _conf.put( "fgColor", color(0xff, 0xff, 0x00) );
    _conf.put( "bgColor", color(0x00, 0x00, 0x00) );
    _conf.put( "txt", text);
    loadConf();
  }  
  HashMap<String, Object> _conf = new HashMap<String, Object>();
  void config(HashMap<String, Object> conf) { 
    this._conf = conf;
    loadConf();
  }
  HashMap<String, Object> config() { 
    return this._conf;
  }

  void loadConf() { 
    _fgColor = (Integer)_conf.get("fgColor");
    _bgColor = (Integer)_conf.get("bgColor");
    _txt = (String)_conf.get("txt");
  }
  PImage run(PImage img) {

    PGraphics buffer = createGraphics(img.width, img.height);
    buffer.beginDraw();
    PFont subFont = loadFont("mono.vlw");
    buffer.textFont(subFont); 
    buffer.textAlign(LEFT, TOP);

    buffer.image(img, 0, 0);
    float phi = 1.618;
    int ts = buffer.height/22;
    int tl = _txt.length();
    int tw = tl * (int)(ts/phi);
    int tx = (buffer.width-tw)/2;
    int ty = buffer.height-(int)(2*ts); 

    buffer.textSize(ts);
    buffer.fill(_bgColor);

    buffer.text(_txt, tx-1, ty-1);
    buffer.text(_txt, tx-1, ty);
    buffer.text(_txt, tx+1, ty);

    buffer.text(_txt, tx+1, ty+1);
    buffer.fill(_fgColor);
    //ts = ts -2;
    tx = tx - 2;
    if ( tx < 0 ) tx = 1;
    buffer.textSize(ts);
    buffer.text(_txt, tx, ty);
    buffer.endDraw();
    PImage result = (PImage)buffer;
    return result;
  }
}
/* Univers 45
 Antique Olive
 Tiresias 
 http://lightsfilmschool.com/blog/subtitle-fonts-sizes/338/ 
 */
 
 
 
 interface IConfigurableEffect { 
  PImage run(PImage input);
  void config(HashMap<String, Object> conf);
  HashMap<String, Object> config();
}

PImage sinwav(PImage img, int xp, int yp) { 
  int ctr = 0;  
  img.loadPixels();
  float ylength = map(xp, 0, 100, 1, 100);
  float xlength = map(yp, 0, 100, 1, 100);
  PImage result = createImage(img.width, img.height, RGB);
  for ( int y =0, h = img.height; y<h; y++) { 
    for ( int x = 0, w = img.width; x<w; x++, ctr++) {
      int pos = x + y * w;
      color c = img.pixels[pos];
      int epos = (int)(( x + sin(y/ylength)*xlength)+ y * w);
      if ( epos < result.pixels.length )
        result.pixels[epos] = c;
      else
        result.pixels[pos] = c;
    }
  }
  result.updatePixels();
  return result;
}

PImage interlaceImages(PImage im1, PImage im2) { 
  im1.loadPixels();
  PImage result = createImage(im1.width, im1.height, RGB);
  for ( int y = 0, h = im1.height; y<h; y++) {
    for ( int x = 0, w = im1.width; x<w; x++) { 
      int y2 = (int)map(y, 0, h, 0, im2.height);
      int x2 = (int)map(x, 0, w, 0, im2.width);
      int p1 = x + y * w;
      int p2 = x2 + y2 * im2.width;
      color c = y % 2 == 0 ? im1.pixels[p1] : im2.pixels[p2];
      result.pixels[p1] = c;
    }
  }
  result.updatePixels();
  return result;
}

