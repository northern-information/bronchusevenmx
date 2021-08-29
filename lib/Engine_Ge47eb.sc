// Engine_Ge47eb
// copy pasta from goldeneye
// https://github.com/northern-information/goldeneye/blob/ef20e19029bd449da33d22bc41f1c2d628a69100/lib/Engine_Goldeneye.sc

// Inherit methods from CroneEngine
Engine_Ge47eb : CroneEngine {

	// <Ge47eb> 
	var bufGe47eb;
	var synGe47eb;
	// </Ge47eb>

	*new { arg context, doneCallback;
		^super.new(context, doneCallback);
	}

	alloc {
		// <Ge47eb> 
		bufGe47eb=Dictionary.new(128);
		synGe47eb=Dictionary.new(128);

		context.server.sync;

		SynthDef("playerGe47ebStereo",{ 
				arg bufnum, amp=0, ampLag=0, t_trig=0,
				sampleStart=0,sampleEnd=1,loop=0,
				rate=1,decay=999;

				var snd;
				var frames = BufFrames.kr(bufnum);

				// lag the amp for doing fade out
				amp = Lag.kr(amp,ampLag);
				// use envelope for doing fade in
				amp = amp * EnvGen.ar(Env([0,1],[ampLag]));
        // use percussive envelope for doing percussive things
        amp = amp * EnvGen.kr(Env.perc(0, decay), t_trig);
				
				// playbuf
				snd = PlayBuf.ar(
					numChannels:2, 
					bufnum:bufnum,
					rate:BufRateScale.kr(bufnum)*rate,
					startPos: ((sampleEnd*(rate<0))*(frames-10))+(sampleStart*frames*(rate>0)),
					trigger:t_trig,
					loop:loop,
					doneAction:2,
				);

				// multiple by amp
				snd = snd * amp;

				// if looping, free up synth if no output
				DetectSilence.ar(snd,doneAction:2);

				Out.ar(0,snd)
		}).add;	

		SynthDef("playerGe47ebMono",{ 
				arg bufnum, amp=0, ampLag=0, t_trig=0,
				sampleStart=0,sampleEnd=1,loop=0,
				rate=1, decay=999;

				var snd;
				var frames = BufFrames.kr(bufnum);

				// lag the amp for doing fade in/out
				amp = Lag.kr(amp,ampLag);
				// use envelope for doing fade in
				amp = amp * EnvGen.ar(Env([0,1],[ampLag]));
        // use percussive envelope for doing percussive things
        amp = amp * EnvGen.kr(Env.perc(0, decay), t_trig);
				
				// playbuf
				snd = PlayBuf.ar(
					numChannels:1, 
					bufnum:bufnum,
					rate:BufRateScale.kr(bufnum)*rate,
					startPos: ((sampleEnd*(rate<0))*(frames-10))+(sampleStart*frames*(rate>0)),
					trigger:t_trig,
					loop:loop,
					doneAction:2,
				);

				snd = Pan2.ar(snd,0);

				// multiple by amp
				snd = snd * amp;

				// if looping, free up synth if no output
				DetectSilence.ar(snd,doneAction:2);

				Out.ar(0,snd)
		}).add;	


		this.addCommand("play","sffffffff", { arg msg;
			var filename=msg[1];
			var synName="playerGe47ebMono";
      ("decay is " + msg[9]).postln;
			if (bufGe47eb.at(filename)==nil,{
				// load buffer
				Buffer.read(context.server,filename,action:{
					arg bufnum;
					if (bufnum.numChannels>1,{
						synName="playerGe47ebStereo";
					});
					bufGe47eb.put(filename,bufnum);
					synGe47eb.put(filename,Synth(synName,[
						\bufnum,bufnum,
						\amp,msg[2],
						\ampLag,msg[3],
						\sampleStart,msg[4],
						\sampleEnd,msg[5],
						\loop,msg[6],
						\rate,msg[7],
						\t_trig,msg[8],
						\decay,msg[9],
					],target:context.server).onFree({
						// ("freed "++filename).postln;
					}));
					NodeWatcher.register(synGe47eb.at(filename));
				});
			},{
				// buffer already loaded, just play it
				if (bufGe47eb.at(filename).numChannels>1,{
					synName="playerGe47ebStereo";
				});
				if (synGe47eb.at(filename).isRunning==true,{
					synGe47eb.at(filename).set(
						\bufnum,bufGe47eb.at(filename),
						\amp,msg[2],
						\ampLag,msg[3],
						\sampleStart,msg[4],
						\sampleEnd,msg[5],
						\loop,msg[6],
						\rate,msg[7],
						\t_trig,msg[8],
						\decay,msg[9],
					);
				},{
					synGe47eb.put(filename,Synth(synName,[
						\bufnum,bufGe47eb.at(filename),
						\amp,msg[2],
						\ampLag,msg[3],
						\sampleStart,msg[4],
						\sampleEnd,msg[5],
						\loop,msg[6],
						\rate,msg[7],
						\t_trig,msg[8],
					],target:context.server).onFree({
						// ("freed "++filename).postln;
					}));
					NodeWatcher.register(synGe47eb.at(filename));
				});
			});
		});
		// </Ge47eb> 

	}

	free {
		// <Ge47eb> 
		synGe47eb.keysValuesDo({ arg key, value; value.free; });
		bufGe47eb.keysValuesDo({ arg key, value; value.free; });
		// </Ge47eb> 
	}
}
