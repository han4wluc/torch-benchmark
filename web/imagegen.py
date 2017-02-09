
import argparse

# Initialize argument parse object
parser = argparse.ArgumentParser()

# This would be an argument you could pass in from command line
parser.add_argument('--inputPath',type=str, required=True)
parser.add_argument('--outputPath',type=str, required=True)
parser.add_argument('--title',type=str, required=False)

# Parse the arguments
inargs = parser.parse_args()
inputPath = inargs.inputPath
outputPath = inargs.outputPath
title = inargs.title or 'Training Loss'

import numpy as np
import matplotlib as mpl
import matplotlib.pyplot as plt
import matplotlib.patches as mpatches
import seaborn as sns

mpl.rcParams['figure.figsize'] = (10.0, 8.0)

data = np.genfromtxt(inputPath, delimiter='\t', skip_header=0, names=True)
train_loss = data['train_loss']
validation_loss = data['validation_loss']

red_patch = mpatches.Patch(color='b', label='train_loss')
green_patch = mpatches.Patch(color='g', label='validation_loss')
plt.legend(handles=[red_patch, green_patch])

plt.title(title)
plt.xlabel('loss')
plt.ylabel('epoch')
plt.plot(train_loss, c='b')
plt.plot(validation_loss, c='g')
plt.savefig(outputPath)
