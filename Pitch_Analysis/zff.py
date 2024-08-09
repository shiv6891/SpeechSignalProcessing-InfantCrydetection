#!/usr/bin/python2
#Extract epochs as described in "Epoch extraction from speech signals", KSR Murty, B Yegnanarayana, in IEEE Transactions on Audio, Speech, and Language Processing 16 (8), 1602-1613

import numpy as np
import scipy.io.wavfile as wav
import sys
import os
import matplotlib.pyplot as plt

def extract_epochs(wavFileName, original_folder='.', output_folder=None):
  rate, data = wav.read(os.path.join(original_folder,wavFileName))
  data = data.astype(float)
  data = data / (float(np.max(np.abs(data))))

  x = np.zeros((data.shape[0],))
  x[0] = 0
  for i in range(1,len(data)):
    x[i] = data[i] - data[i-1]

  y1=np.zeros((x.shape[0],))
  y2=np.zeros((x.shape[0],))

  y1[0]=0
  y1[1]=0
  for i in range(2,len(y1)):
    y1[i]=x[i]+2*y1[i-1]-y1[i-2]

  y2[0]=0
  y2[1]=0
  for i in range(2,len(y2)):
    y2[i]=y1[i]+2*y2[i-1]-y2[i-2]
  

  y=np.zeros((x.shape[0],))
  N=80 #corresponds to 5ms
  #for i in range(4,N):
  #  y[i]=y2[i]-np.mean(y2[i:i+2*N+1])
  for i in range(N,len(y2)-N-1):
    y[i]=y2[i]-np.mean(y2[i-N:i+N+1])
  #for i in range(len(y2)-N-1,len(y2)-4):
  #  y[i]=y2[i]-np.mean(y2[i-2*N-1:i])


  f=np.zeros((x.shape[0],))
  #for i in range(4,N):
  #  f[i]=y[i]-np.mean(y[i:i+2*N+1])
  for i in range(N,len(f)-N-1):
    f[i]=y[i]-np.mean(y[i-N:i+N+1])
  #for i in range(len(y2)-N-1,len(y2)-4):
  #  f[i]=y[i]-np.mean(y[i-2*N-1:i])

  f=f.astype(np.int16)

  if output_folder == None:
    plt.plot(f[2*N:len(f) - 2*N-1])
    plt.show()
  else:
    outputFile=os.path.join(output_folder,wavFileName)
    if not os.path.isdir("/".join(outputFile.split("/")[:-1])):
      os.system("mkdir -p "+"/".join(outputFile.split("/")[:-1]))
    wav.write(outputFile, rate, f[2*N:len(f) - 2*N-1])

def read_file(fileName, original_folder, output_folder, idx0=0, idx1=-1):
  f=open(fileName)
  text=f.read().splitlines()
  f.close()
  if idx1==-1:
    idx1=len(text)
  if(idx1>len(text)):
    idx1=len(text)
  for i in range(idx0,idx1):
    print(i)
    extract_epochs(text[i], original_folder, output_folder)

if __name__ == '__main__':
  if len(sys.argv) == 2:
    extract_epochs (sys.argv[1])
  else:
    #arguments: [1]=fileName (without any prefix/suffix),[2]=folder containing audio files,[3]=folder in which to write the output, [4]=where to start reading in the score files (useful to parallelize computations), [5]=where to stop reading in the score files (useful to parallelize computations)
    read_file(sys.argv[1], sys.argv[2], sys.argv[3], int(sys.argv[4]), int(sys.argv[5]))


