# import sounddevice as sd
# import numpy as np
# import librosa
# import tensorflow as tf
# import json
# import queue
# import time
# import os
# dataset_path = 'C:\\Users\\NIHAL\\Music\\Animal-SDataset\\'
# file_paths = []
# labels = []
# label_names = sorted(os.listdir(dataset_path))
# # ================= CONFIG =================
# MODEL_PATH = "AnimalSounds.keras"
# LABELS_PATH = "labels.json"
# SAMPLE_RATE = 16000
# DURATION = 2.0        # seconds per prediction
# N_MELS = 128
# MAX_LEN = 128
# # ==========================================
#
# # Load model
# model = tf.keras.models.load_model(MODEL_PATH)
#
# # # Load labels
# # with open(LABELS_PATH, "r") as f:
# #     label_to_index = json.load(f)
# #
# # index_to_label = {v: k for k, v in label_to_index.items()}
#
# audio_queue = queue.Queue()
#
# def audio_callback(indata, frames, time_info, status):
#     if status:
#         print(status)
#     audio_queue.put(indata.copy())
#
# def audio_to_melspectrogram(y):
#     spectrogram = librosa.feature.melspectrogram(
#         y=y,
#         sr=SAMPLE_RATE,
#         n_mels=N_MELS
#     )
#     spectrogram_db = librosa.power_to_db(spectrogram, ref=np.max)
#
#     # Pad / trim
#     if spectrogram_db.shape[1] < MAX_LEN:
#         pad_width = MAX_LEN - spectrogram_db.shape[1]
#         spectrogram_db = np.pad(
#             spectrogram_db,
#             ((0, 0), (0, pad_width)),
#             mode="constant"
#         )
#     else:
#         spectrogram_db = spectrogram_db[:, :MAX_LEN]
#
#     return spectrogram_db
#
#
# print("🎙️ Listening... Press Ctrl+C to stop")
#
# with sd.InputStream(
#     samplerate=SAMPLE_RATE,
#     channels=1,
#     callback=audio_callback
# ):
#     try:
#         while True:
#             frames = []
#             start_time = time.time()
#
#             while time.time() - start_time < DURATION:
#                 frames.append(audio_queue.get())
#
#             audio = np.concatenate(frames, axis=0).flatten()
#
#             mel = audio_to_melspectrogram(audio)
#             mel = mel[np.newaxis, ..., np.newaxis]
#
#             predictions = model.predict(mel, verbose=0)
#             predicted_index = np.argmax(predictions)
#             confidence = np.max(predictions)
#
#             label = label_names[predicted_index]
#             # label=predicted_index
#
#             print(f"🐾 Predicted: {label} ({confidence:.2f})")
#
#     except KeyboardInterrupt:
#         print("\n🛑 Stopped")




import os
import django
import sounddevice as sd
import numpy as np
import librosa
import tensorflow as tf
import queue
import time
from django.utils import timezone

# ================= DJANGO SETUP =================
os.environ.setdefault("DJANGO_SETTINGS_MODULE", "forest.settings")  # CHANGE THIS
django.setup()

from myapp.models import Detect_Alert   # CHANGE THIS

# ================= CONFIG =================
MODEL_PATH = "AnimalSounds.keras"
SAMPLE_RATE = 16000
DURATION = 2.0        # seconds per prediction
N_MELS = 128
MAX_LEN = 128
confidence_threshold = 0.80
cooldown = 10   # seconds between database saves
# ==========================================

# Load model
model = tf.keras.models.load_model(MODEL_PATH)

# Load label names from dataset folder
dataset_path = 'C:\\Users\\NIHAL\\Music\\Animal-SDataset\\'
label_names = sorted(os.listdir(dataset_path))

audio_queue = queue.Queue()
last_saved_time = 0

# ================= AUDIO CALLBACK =================
def audio_callback(indata, frames, time_info, status):
    if status:
        print(status)
    audio_queue.put(indata.copy())

# ================= MEL SPECTROGRAM FUNCTION =================
def audio_to_melspectrogram(y):
    spectrogram = librosa.feature.melspectrogram(
        y=y,
        sr=SAMPLE_RATE,
        n_mels=N_MELS
    )
    spectrogram_db = librosa.power_to_db(spectrogram, ref=np.max)

    # Pad / Trim
    if spectrogram_db.shape[1] < MAX_LEN:
        pad_width = MAX_LEN - spectrogram_db.shape[1]
        spectrogram_db = np.pad(
            spectrogram_db,
            ((0, 0), (0, pad_width)),
            mode="constant"
        )
    else:
        spectrogram_db = spectrogram_db[:, :MAX_LEN]

    return spectrogram_db

# ================= START LISTENING =================
print("🎙️ Listening... Press Ctrl+C to stop")

with sd.InputStream(
    samplerate=SAMPLE_RATE,
    channels=1,
    callback=audio_callback
):
    try:
        while True:
            frames = []
            start_time = time.time()

            while time.time() - start_time < DURATION:
                frames.append(audio_queue.get())

            audio = np.concatenate(frames, axis=0).flatten()

            mel = audio_to_melspectrogram(audio)
            mel = mel[np.newaxis, ..., np.newaxis]

            # Predict
            predictions = model.predict(mel, verbose=0)
            predicted_index = np.argmax(predictions)
            confidence = np.max(predictions)

            label = label_names[predicted_index]

            print(f"🐾 Predicted: {label} ({confidence:.2f})")

            # Save to DB if confidence high + cooldown passed
            current_time = time.time()

            if confidence > confidence_threshold and (current_time - last_saved_time > cooldown):

                Detect_Alert.objects.create(
                    latitude="11.2588",  # Replace with real GPS
                    longitude="75.7804",
                    message=f"{label} sound detected with {confidence:.2f} confidence",
                    animal_name=label,
                    animal_image=f"animals/{label}.jpg",
                    date=timezone.now().date()
                )

                last_saved_time = current_time
                print("✅ Alert Stored in Database")

    except KeyboardInterrupt:
        print("\n🛑 Stopped")