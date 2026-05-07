import librosa
import librosa.display
import numpy as np
import matplotlib.pyplot as plt
import tensorflow as tf
from tensorflow.keras import layers, models
from tensorflow.keras.callbacks import ModelCheckpoint
from sklearn.model_selection import train_test_split
import os


def audio_to_melspectrogram(file_path, n_mels=128, max_len=128):
    y, sr = librosa.load(file_path, sr=16000)
    spectrogram = librosa.feature.melspectrogram(y=y, sr=sr, n_mels=n_mels)
    spectrogram_db = librosa.power_to_db(spectrogram, ref=np.max)

    # Padding/cutting to max_len
    if spectrogram_db.shape[1] < max_len:
        pad_width = max_len - spectrogram_db.shape[1]
        spectrogram_db = np.pad(spectrogram_db, ((0, 0), (0, pad_width)), mode='constant')
    else:
        spectrogram_db = spectrogram_db[:, :max_len]

    return spectrogram_db


def build_model(input_shape, num_classes):
    model = models.Sequential([
        layers.Input(shape=input_shape),

        layers.Conv2D(32, (3, 3), activation='relu', padding='same'),
        layers.MaxPooling2D((2, 2)),
        layers.BatchNormalization(),

        layers.Conv2D(64, (3, 3), activation='relu', padding='same'),
        layers.MaxPooling2D((2, 2)),
        layers.BatchNormalization(),

        layers.Conv2D(128, (3, 3), activation='relu', padding='same'),
        layers.MaxPooling2D((2, 2)),
        layers.BatchNormalization(),

        layers.Flatten(),
        layers.Dense(128, activation='relu'),
        layers.Dropout(0.3),
        layers.Dense(num_classes, activation='softmax')
    ])

    model.compile(optimizer='adam',
                  loss='sparse_categorical_crossentropy',
                  metrics=['accuracy'])
    return model


import os

dataset_path = 'C:\\Users\\NIHAL\\Music\\Animal-SDataset\\'
file_paths = []
labels = []
label_names = sorted(os.listdir(dataset_path))  # ['Bird', 'Cat', ...]

label_to_index = {name: idx for idx, name in enumerate(label_names)}  # {'Bird': 0, 'Cat': 1, ...}

# Recorremos cada carpeta
for label_name in label_names:
    folder_path = os.path.join(dataset_path, label_name)
    for file_name in os.listdir(folder_path):
        if file_name.endswith(('.wav', '.mp3')):
            file_paths.append(os.path.join(folder_path, file_name))
            labels.append(label_to_index[label_name])

X = np.array([audio_to_melspectrogram(path) for path in file_paths])
X = X[..., np.newaxis]
y = np.array(labels)

# train/test
X_train, X_test, y_train, y_test = train_test_split(X, y, stratify=y)

checkpoint = tf.keras.callbacks.ModelCheckpoint(
    filepath='AnimalSounds.keras',  # ✅ extensión válida
    monitor='val_accuracy',
    verbose=1,
    save_best_only=True
)
# Entrenamiento
model = build_model(X.shape[1:], num_classes=len(set(y)))
model.fit(X_train, y_train, epochs=50, validation_data=(X_test, y_test), batch_size=32, callbacks=[checkpoint])

import matplotlib.pyplot as plt

history = model.history

plt.figure(figsize=(14, 5))

# Accuracy
plt.subplot(1, 2, 1)
plt.plot(history.history['accuracy'], label='Train')
plt.plot(history.history['val_accuracy'], label='Val')
plt.title('Accuracy')
plt.xlabel('Epoch')
plt.ylabel('Accuracy')
plt.legend()

# Loss
plt.subplot(1, 2, 2)
plt.plot(history.history['loss'], label='Train')
plt.plot(history.history['val_loss'], label='Val')
plt.title('Loss')
plt.xlabel('Epoch')
plt.ylabel('Loss')
plt.legend()

plt.show()



