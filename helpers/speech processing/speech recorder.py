import speech_recognition as sr
import argparse
import os.path
import sys

# Command line arguments
parser = argparse.ArgumentParser(description="Casper Speech Recorder")
parser.add_argument("-l", "--location", dest="location", help="Where the audio file should be saved", required=True)
parser.add_argument("-n", "--name", dest="name", help="The name you would like for the recorded audio file", required=True)
args = parser.parse_args()

location = args.location
name = args.name

# Obtain audio from the microphone
r = sr.Recognizer()
with sr.Microphone() as source:
    # Allow compensation for background noise
    r.dynamic_energy_threshold = True
    # Listen for 1 second to calibrate the energy threshold for ambient noise levels
    print("Compensating for background noise (1 second)...")
    r.adjust_for_ambient_noise(source)
    # Start listening for a phrase
    print("Say something!")
    audio = r.listen(source)

# Convert the recorded audio to FLAC data (byte string)
data = audio.get_flac_data()

# Save the data to the file, close and exit
try:
    with open(os.path.join(location, name + ".flac"), "wb") as file:
        file.write(data)
        sys.exit("Success!")
except IOError as (errno, strerror):
    sys.exit("I/O error({0}): {1}".format(errno, strerror))
