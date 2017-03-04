/* vhs like effect by teisu https://github.com/bobvk/sketches/vhs/ 
 click mouse to retry interlacing, 
 when interactive = true, mouseposition on click sets saturation/brightness */

PImage img1, timg; 
String txt = "it only gets worse from here";
int virtw = 400, virth = 300;
Boolean interactive = true;

void setup() {
  size(100,100,P2D);
  surface.setResizable(true);
}

void draw() {   
  timg = loadImage("source.jpg");
  img1 = createImage(virtw,virth,RGB);
  img1.copy(timg,0,0,timg.width,timg.height,0,0,img1.width,img1.height);
  surface.setSize(timg.width, timg.height);

  if (frameCount == 1 ) // skip 1st frame as setSize happens NEXT frame ...
    return;

  PImage hai = new Subtitle(txt).run(img1);
  PImage hay = sinwav(hai,1+(int)(random(1)*6),1+(int)(random(1)*6));
  PImage result = createImage(timg.width,timg.height,RGB);
  result.copy(interlaceImages(hai,hay),0,0,virtw,virth,0,0,result.width,result.height);
  int btx = 45+(int)(random(1)*10);
  int bty = 20+(int)(random(1)*40);
  if ( interactive ) { 
    btx = (int)map(mouseX,0,width,0,100);
    bty = (int)map(mouseY,0,width,0,100);
  }
  image( result = basstreble(result,btx,bty) , 0, 0);
  result.save("result.png");
  exit();
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



PImage basstreble(PImage img, int xp, int yp) { 
  float dB_bass = map(xp, 0, 100, -15, 15);
  float dB_treble = map(yp, 0, 100, -15, 15);
  PImage result = createImage(img.width, img.height, RGB);
  float slope = 0.4;
  double hzBass = 250.0;
  double hzTreble = 4000.0; 
  float b0, b1, b2, a0, a1, a2, xn2Bass, xn1Bass, yn2Bass, yn1Bass, b0Bass, b1Bass, b2Bass, xn1Treble, xn2Treble, yn1Treble, yn2Treble, a0Bass, a1Bass, a2Bass, a0Treble, a1Treble, a2Treble, b0Treble, b1Treble, b2Treble;
  double mMax = 0.0;
  double mSampleRate = 44000;

  xn1Bass = xn2Bass = yn1Bass = yn2Bass = 0.0;
  xn1Treble = xn2Treble = yn1Treble = yn2Treble = 0.0;

  float w = (float)(2 * PI * hzBass / mSampleRate);
  float a = exp((float)(log(10.0) *  dB_bass / 40));
  float b = sqrt((float)((a * a + 1) / slope - (pow((float)(a - 1), 2))));

  b0Bass = a * ((a + 1) - (a - 1) * cos(w) + b * sin(w));
  b1Bass = 2 * a * ((a - 1) - (a + 1) * cos(w));
  b2Bass = a * ((a + 1) - (a - 1) * cos(w) - b * sin(w));
  a0Bass = ((a + 1) + (a - 1) * cos(w) + b * sin(w));
  a1Bass = -2 * ((a - 1) + (a + 1) * cos(w));
  a2Bass = (a + 1) + (a - 1) * cos(w) - b * sin(w);

  w = (float)(2 * PI * hzTreble / mSampleRate);
  a = exp((float)(log(10.0) * dB_treble / 40));
  b = sqrt((float)((a * a + 1) / slope - (pow((float)(a - 1), 2))));



  b0Treble = a * ((a + 1) + (a - 1) * cos(w) + b * sin(w));
  b1Treble = -2 * a * ((a - 1) + (a + 1) * cos(w));
  b2Treble = a * ((a + 1) + (a - 1) * cos(w) - b * sin(w));
  a0Treble = ((a + 1) - (a - 1) * cos(w) + b * sin(w));
  a1Treble = 2 * ((a - 1) - (a + 1) * cos(w));
  a2Treble = (a + 1) - (a - 1) * cos(w) - b * sin(w);


  img.loadPixels(); 
  result.loadPixels();
  for ( int i = 0, l = img.pixels.length; i<l; i++) { 
    int[] rgb = new int[3];
    rgb[0] = (int)red(img.pixels[i]);
    rgb[1] = (int)green(img.pixels[i]);
    rgb[2] = (int)blue(img.pixels[i]);
    for ( int ri = 0; ri<3; ri++ ) { 
      float in = map(rgb[ri], 0, 255, 0, 1);

      float out = (b0Bass * in + b1Bass * xn1Bass + b2Bass * xn2Bass - a1Bass * yn1Bass - a2Bass * yn2Bass ) / a0Bass;
      //println(a0Bass);
      xn2Bass = xn1Bass;
      xn1Bass = in;
      yn2Bass = yn1Bass;
      yn1Bass = out;
      //treble filter
      in = out;
      out = (b0Treble * in + b1Treble * xn1Treble + b2Treble * xn2Treble - a1Treble * yn1Treble - a2Treble * yn2Treble) / a0Treble;
      xn2Treble = xn1Treble;
      xn1Treble = in;
      yn2Treble = yn1Treble;
      yn1Treble = out;

      //retain max value for use in normalization
      if ( mMax < abs(out))
        mMax = abs(out);




      rgb[ri] = (int)map(out, 0, 1, 0, 255);
    }
    result.pixels[i] = color(rgb[0], rgb[1], rgb[2]);
  }
  result.updatePixels();

  return result;
}