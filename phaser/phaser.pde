/* Phaser - a processing port of audacity's Phaser.cpp 
 * Original by Nasca Octavian Paul, Dominic Mazzoni and  Vaughan Johnson
 * Port by bobvk 
 * Copyright (C) 2015 - GPL */
// usage: move mouse to change parms
// click mouse to save result


String inPath = "source.jpg";
String outPath = "result.jpg";
float samplerate = 44100.0;

PImage img1;
void setup() { 
  img1 = loadImage(inPath); 
  size(img1.width,img1.height,P2D);
  frameRate(4);//noLoop();
}

void draw() { 
  int xp = (int)map(mouseX,0,width,0,100);
  int yp = (int)map(mouseY,0,height,0,100);
  image(phaser(img1,xp,yp),0,0);
  
}
 
void mouseClicked() { 
  println("Saving "+outPath);
   save(outPath); 
}
PImage phaser(PImage img, int xp, int yp) { 
  
  /* EffectPhaser::ProcessInitialize */
  //FIXME: no idea what to set these at:
  float mSampleRate = samplerate;
  //constants
  float phaserlfoshape = 4.0;
  int lfoskipsamples = 20; //how many samples are processed before recomputing lfo
  int numStages = 24;
  //defaults
  float mFreq = 0.4,  mPhase = 0;
  int mStages = 2, mDryWet = 128, mDepth = 100, mFeedback = 0;
  
  
  //getParams
  /*
    Phaser Parameters

 mFreq       - Phaser's LFO frequency
 mPhase      - Phaser's LFO startphase (radians), needed for stereo Phasers
 mDepth      - Phaser depth (0 - no depth, 255 - max depth)
 mStages     - Phaser stages (recomanded from 2 to 16-24, and EVEN NUMBER)
 mDryWet     - Dry/wet mix, (0 - dry, 128 - dry=wet, 255 - wet)
 mFeedback   - Phaser FeedBack (0 - no feedback, 100 = 100% Feedback,
                               -100 = -100% FeedBack)
*/
  mFreq = map(xp,0,100,0.4,4.0);
  mDryWet = (int) map(xp,0,100,0,255);
  mDepth = (int) map(xp,0,100,255,0);
  mFeedback = (int) map(yp,0,100,-100,100);
  
  // enable these for some more fun :)
  // mSampleRate = map(yp,0,100,1,512);
  // mStages = (int) ( 2*map(yp,0,100,1,12));

  
  //init
  float gain = 0,fbout = 0;
  float lfoskip = mFreq * 2 * PI / mSampleRate;
  float phase = mPhase * PI / 180;
  
  float[] old = new float[mStages];
  for ( int j = 0; j < mStages; j++) { 
    old[j] = 0.0;
  }
  
  /* EffectPhaser::ProcessBlock */
  int skipcount = 0;
  //start the show :)  
  PImage result = createImage(img.width, img.height, RGB);
  img.loadPixels(); result.loadPixels();
  
  float[] rgb = new float[3];
  for ( int i = 0, l = img.pixels.length; i<l; i++ ) { 
     color c = img.pixels[i];
     rgb[0] = map(red(c),0,255,0,1);
     rgb[1] = map(green(c),0,255,0,1);
     rgb[2] = map(blue(c),0,255,0,1);
     for ( int ci = 0; ci < 3; ci++) { 
       float in = rgb[ci];
       float m = in + fbout * mFeedback / 100;
       if ( (( skipcount++) % lfoskipsamples ) == 0 ) { //recomopute lfo
         gain = (1.0 + cos(skipcount * lfoskip + phase)) / 2.0; //compute sine between 0 and 1
         gain = exp(gain * phaserlfoshape) / exp(phaserlfoshape); // change lfo shape
         gain = 1.0 - gain / 255.0 * mDepth; // attenuate the lfo
       }
       //phasing routine
       for ( int j = 0; j<mStages; j++) {
         float tmp = old[j];
         old[j] = gain * tmp + m;
         m = tmp - gain * old[j];
       }
       fbout = m;
       rgb[ci] = (float) (( m * mDryWet + in * (255-mDryWet)) / 255);
     }
     color rc = color(
       map(rgb[0],0,1,0,255),
       map(rgb[1],0,1,0,255),
       map(rgb[2],0,1,0,255));
     result.pixels[i] = rc;
  }
  result.updatePixels();
  return result;
}

/* reference source: 

    Phaser Parameters

 mFreq       - Phaser's LFO frequency
 mPhase      - Phaser's LFO startphase (radians), needed for stereo Phasers
 mDepth      - Phaser depth (0 - no depth, 255 - max depth)
 mStages     - Phaser stages (recomanded from 2 to 16-24, and EVEN NUMBER)
 mDryWet     - Dry/wet mix, (0 - dry, 128 - dry=wet, 255 - wet)
 mFeedback   - Phaser FeedBack (0 - no feedback, 100 = 100% Feedback,
                               -100 = -100% FeedBack)

  mFreq = Freq;
   mFeedback = Feedback;
   mStages = Stages;
   mDryWet = DryWet;
   mDepth = Depth;
   mPhase = Phase;

// Define keys, defaults, minimums, and maximums for the effect parameters
//
//     Name       Type     Key               Def   Min   Max         Scale
Param( Stages,    int,     XO("Stages"),     2,    2,    NUM_STAGES, 1  );
Param( DryWet,    int,     XO("DryWet"),     128,  0,    255,        1  );
Param( Freq,      double,  XO("Freq"),       0.4,  0.1,  4.0,        10 );
Param( Phase,     double,  XO("Phase"),      0.0,  0.0,  359.0,      1  );
Param( Depth,     int,     XO("Depth"),      100,  0,    255,        1  );
Param( Feedback,  int,     XO("Feedback"),   0,    -100, 100,        1  );

#define phaserlfoshape 4.0

// How many samples are processed before recomputing the lfo value again
#define lfoskipsamples 20




bool EffectPhaser::ProcessInitialize(sampleCount WXUNUSED(totalLen), ChannelNames chanMap)
{
   for (int j = 0; j < mStages; j++)
   {
      old[j] = 0;
   }

   skipcount = 0;
   gain = 0;
   fbout = 0;
   lfoskip = mFreq * 2 * M_PI / mSampleRate;

   phase = mPhase * M_PI / 180;
   if (chanMap[0] == ChannelNameFrontRight)
   {
      phase += M_PI;
   }

   return true;
}

sampleCount EffectPhaser::ProcessBlock(float **inBlock, float **outBlock, sampleCount blockLen)
{
   float *ibuf = inBlock[0];
   float *obuf = outBlock[0];

   for (sampleCount i = 0; i < blockLen; i++)
   {
      double in = ibuf[i];

      double m = in + fbout * mFeedback / 100;

      if (((skipcount++) % lfoskipsamples) == 0)
      {
         //compute sine between 0 and 1
         gain = (1.0 + cos(skipcount * lfoskip + phase)) / 2.0;

         // change lfo shape
         gain = expm1(gain * phaserlfoshape) / expm1(phaserlfoshape);

         // attenuate the lfo
         gain = 1.0 - gain / 255.0 * mDepth;
      }

      // phasing routine
      for (int j = 0; j < mStages; j++)
      {
         double tmp = old[j];
         old[j] = gain * tmp + m;
         m = tmp - gain * old[j];
      }
      fbout = m;

      obuf[i] = (float) ((m * mDryWet + in * (255 - mDryWet)) / 255);
   }

   return blockLen;
}

*/

