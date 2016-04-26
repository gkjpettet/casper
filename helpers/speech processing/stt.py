# ====================================================================
# listens for a phrase of speech (compensating for background noise),
# stops when a period of silence is detected and then converts the
# speech to text using the specified STT engine.
# ====================================================================
import speech_recognition as sr
import argparse
import sys

def print_now(str):
    # Immediately prints the passed string by printing to stdout and flushing
    print(str)
    sys.stdout.flush()
    return

# Command line arguments
parser = argparse.ArgumentParser(description="Casper's speech to text (STT) converter")
engine_help = """
                The underlying speech-to-text engine to use for the conversion.\n
                Options are:\n
                'google'\tGoogle's STT engine. Uses a public API key but can take your personal key\n
                'api'\tThe api.ai STT engine. Requires an API key\n
                'wit'\tThe wit.ai STT engine. Requires an API key
              """
key_help = "The API key for the chosen STT engine. Not required for Google's engine"
parser.add_argument("-e", "--engine", dest="engine", help=engine_help, default="google")
parser.add_argument("-k", "--key", dest = "key", help=key_help, default="")
args = parser.parse_args()

# Get the command line arguments
engine = args.engine
api_key = args.key

# Has a valid engine been specified?
if engine.lower() != "google" and engine.lower() != "api" and engine.lower() != "wit":
    sys.exit("Invalid STT engine specified. Valid options are: 'google', 'api' and 'wit'")

if engine.lower() != "google":
    # Check that an API key has been provided (not essential for Google)
    if api_key == "":
        sys.exit("You must provide a valid API key for the " + engine + " STT engine")

# Obtain audio from the microphone
r = sr.Recognizer()
with sr.Microphone() as source:
    # Allow compensation for background noise
    r.dynamic_energy_threshold = True
    # Listen for 1 second to calibrate the energy threshold for ambient noise levels
    print_now("Compensating for background noise (1 second)...")
    r.adjust_for_ambient_noise(source)
    # Start listening for a phrase
    print_now("Listening...")
    audio = r.listen(source)

if engine.lower() == "google":
    # recognize speech using Google Speech Recognition
    print_now("Converting speech to text with Google's STT engine...")
    try:
        # for testing purposes, we're just using the default API key
        # to use another API key, use `r.recognize_google(audio, key="GOOGLE_SPEECH_RECOGNITION_API_KEY")`
        # instead of `r.recognize_google(audio)`
        if api_key == "":
            print_now("STT output:" + r.recognize_google(audio))
            sys.exit(0)
        else:
            print("STT output:" + r.recognize_google(audio, key=api_key))
            print_now(0)
    except sr.UnknownValueError:
        sys.exit("Google Speech Recognition could not understand audio")
    except sr.RequestError as e:
        sys.exit("Could not request results from Google Speech Recognition service; {0}".format(e))
elif engine.lower() == "wit":
    # recognize speech using Wit.ai
    print("Converting speech to text with the Wit.ai STT engine...")
    try:
        print_now("STT output:" + r.recognize_wit(audio, key=api_key))
        sys.exit(0)
    except sr.UnknownValueError:
        sys.exit("Wit.ai could not understand audio")
    except sr.RequestError as e:
        sys.exit("Could not request results from Wit.ai service; {0}".format(e))
elif engine.lower() == "api":
    # recognize speech using api.ai
    print_now("Converting speech to text with the api.ai STT engine...")
    try:
        print_now("STT output:" + r.recognize_api(audio, client_access_token=api_key))
        sys.exit(0)
    except sr.UnknownValueError:
        sys.exit("api.ai could not understand audio")
    except sr.RequestError as e:
        sys.exit("Could not request results from api.ai service; {0}".format(e))
