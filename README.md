# drachtio-freeswitch-modules

An open-source collection of freeswitch modules, primarily built for for use with [drachtio](https://drachtio.org) applications utilizing [drachtio-fsrmf](https://www.npmjs.com/package/drachtio-fsmrf), but generally usable and useful with generic freeswitch applications.  These modules have beeen tested with Freeswitch version 1.8.

#### [mod_google_tts](modules/mod_google_tts/README.md)
A tts provider module that integrates with Google Cloud Text-to-Speech API and integrates into freeswitch's TTS framework (i.e., usable with the mod_dptools 'speak' application)

#### [mod_deepgram_transcribe](modules/mod_deepgram_transcribe/README.md)
Adds a Freeswitch API call to start (or stop) real-time transcription on a Freeswitch channel using deepgram streaming transcription.

#### [mod_bodhi_transcribe](modules/mod_bodhi_transcribe/README.md)
Adds a Freeswitch API call to start (or stop) real-time transcription on a Freeswitch channel using navana streaming transcription.


# Installation

These modules have dependencies that require a custom version of freeswitch to be built that has support for [grpc](https://github.com/grpc/grpc) (if any of the google modules are built) and [libwebsockets](https://libwebsockets.org). Specifically, mod_google_tts, mod_google_transcribe and mod_dialogflow require grpc, and mod_audio_fork requires libwebsockets.

#### Using docker

`docker pull drachtio/drachtio-freeswitch-mrf:v1.10.1-full` to get a docker image containing all of the above modules with the exception of mod_aws_transcribe.

## Configuring

The modules that access google services (mod_google_tts) require a JSON service key file to be installed on the Freeswitch server, and the environment variable named "GOOGLE_APPLICATION_CREDENTIALS" must point to that file location.
