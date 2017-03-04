/* Processing port of Audacity's wahwah filter, released under the GPL 
 * Visit audacity.org for licencing details
 * Ported to processing by Bob Verkouteren http://applesandchickens.com */

PImage img1;
int arg1 = 3; // 0-100
int arg2 = 20; // 0-100

void setup() {
  size(100,100,P2D);
  img1 = loadImage("source.jpg");
  surface.setSize(img1.width,img1.height);
}


void draw() { 
  background(0);
  image(wahwah(img1,arg1,arg2),0,0);
  save("result.png");
  exit();
}


PImage wahwah(PImage img, int xp, int yp) { 
  float phase, lfoskip, xn1, xn2, yn1, yn2, b0, b1, b2, a0, a1, a2, freqofs, freq, freqoff, startphase, res, depth; 
  float mCurRate = 0.4, skipcount = 0;
  int lfoskipsamples = 0;
  float frequency, omega, sn, cs, alpha;
  float in, out;
  float val;
  PImage result = createImage(img.width, img.height, RGB);
  freq = 1.5;
  startphase = 0.2;
  depth = 0.8;
  freqofs = 0.9;
  res = 12.5;
  lfoskip = freq * 2 * PI / mCurRate;
  skipcount = xn1 = xn2 = yn1 = yn2 = b0 = b1 = b2 = a0 = a1 = a2 = 0;
  phase = startphase;
  res=map(xp, 0, 100, 1, 100);
  depth=map(yp, 0, 100, 0, 1);
  img.loadPixels(); 
  result.loadPixels();
  float[] rgb = new float[3];
  for ( int i = 0, len = img.pixels.length; i < len; i++) { 
    rgb[0] = red(img.pixels[i]); 
    rgb[1] = green(img.pixels[i]);
    rgb[2] = blue(img.pixels[i]);
    for ( int ri = 0; ri < 3; ri++ ) { 
      in = map(rgb[ri], 0, 255, 0, 1);
      if (true || (skipcount++) % lfoskipsamples == 0) { 
        frequency = (1+cos(skipcount * lfoskip + phase ))/2;
        frequency = frequency * depth * (1-freqofs) + freqofs;
        frequency = exp((frequency - 1) * 6 );
        omega = PI * frequency;
        sn = sin(omega);
        cs = cos(omega);
        alpha = sn/(2*res);
        b0 = (1-cs) /2;
        b1 = 1 - cs;
        b2 = (1-cs)/2;
        a0 = 1 + alpha;
        a1 = -2 * cs;
        a2 = 1 - alpha;
      }
      out = ( b0 * in + b1 * xn1 + b2 * xn2 - a1 * yn1 - a2 * yn2 ) / a0;
      xn2 = xn1;
      xn1 = in;
      yn2 = yn1;
      yn1 = out;
      rgb[ri] = map(out, 0, 1, 0, 255);
    }
    result.pixels[i] = color(rgb[0], rgb[1], rgb[2]);
  }
  result.updatePixels();
  return result;
}