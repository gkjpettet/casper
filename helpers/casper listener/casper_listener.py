# ====================================================================
# Listens continuously for the keyphrase 'casper'. When detected it
# outputs a phrase informing us of this and then quits.
# ====================================================================

import sys, os
import pocketsphinx as ps
import sphinxbase
import pyaudio

parent_dir = os.path.dirname(os.path.abspath(__file__))
required_dir = os.path.join(parent_dir, 'required')

# Create a decoder with the default US dictionary and model definitions but
# define our keyphrase (casper) and thresholds
config = ps.Decoder.default_config()
config.set_string('-hmm', required_dir)
config.set_string('-dict', os.path.join(required_dir, 'cmudict-en-us.dict'))
config.set_string('-keyphrase', 'casper')
config.set_float('-kws_threshold', 1e-10)
config.set_float('-kws_delay', 0)

# Start recording from the microphone
p = pyaudio.PyAudio()
stream = p.open(format=pyaudio.paInt16, channels=1, rate=16000, input=True, frames_per_buffer=1024)
stream.start_stream()

# Process the audio chunk by chunk. On keyword detection, message and exit
decoder = ps.Decoder(config)
decoder.start_utt()
while True:
    buf = stream.read(1024)
    if buf:
         decoder.process_raw(buf, False, False)
    else:
         break
    if decoder.hyp() != None:
        sys.exit('Detected casper')
        # If we wanted to continue listening we'd run the code below instead of exiting...
        # decoder.end_utt()
        # decoder.start_utt()
