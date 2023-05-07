



import os


# create new file structure
    # tuh new
        # ⎿ train
            # ⎿ seizure
            # ⎿ background

# for file in training:
    # for 1st directory only
        # while  a subdirectory exists:
        # get to patient files
        # for every group of 4 files:
            # load edf
            # load tse_bi
            # for every 2500 samples create new pickled file with an array
                # if file is over, fill with 0's
            # if time is in range of seizure, put in seizure
            # else put in background


# pip install pyedflib



from nedc_pystream import *
import os



# rootdir is the directory of the TUH dataset you want to process

rootdir = '/Users/gavinpereira/Desktop/TUHData/edf/train/02_tcp_le/'
rootdir = '/Users/gavinpereira/Desktop/TUHData/edf/dev_test/01_tcp_ar/002'
import numpy as np


# where to put the seizure files
seizuredir = '/Users/gavinpereira/Desktop/TUHSorted/train/seiz/'

# where to put the background files
backgrounddir = '/Users/gavinpereira/Desktop/TUHSorted/train/bckg/'




## iterate through all subdirectories in the data
for subdir, dirs, files in os.walk(rootdir):
    for file in files:
        # print(os.path.join(subdir, file))
        filename = file.split(".")[0]
        if(file.endswith('.edf')):
            # get tse_bi
            with open(os.path.join(subdir, filename + ".tse_bi"), "r", encoding='utf-8-sig') as tse_bi:
                tseString = tse_bi.read()

            # get edf data
            with open(os.path.join(subdir, filename + ".edf"), "r", encoding='utf-8-sig') as edf:
                fileData = nedc_load_edf(os.path.join(subdir, filename + ".edf"))
                frequencies = fileData[0]
                signals = fileData[1]



            # timestamps
            tse = tseString.splitlines()[2:]
            # print("TSE File: ")
            # print(tse)
            # print(labelTimes(6400, 7000, tse, frequencies[0]))

            # for each channel in the eeg
            writeSignals(fileData, tse, file)

            print("e o f\n")
            tse_bi.close()
            edf.close()


# params:
#       edf start index,
#       edf end index,
#       tse array,
#       edf sample rate
#
# out: either 'bckg' or 'seiz'
def labelTimes(start, end, tse, samplerate):
    for i in range(len(tse)):
        # convert time signature to list
        times = tse[i].split(" ")
        # convert times in list to index
        convertedTimes = [0, 0]
        for i in range(2):
            times[i] = float(times[i])
            convertedTimes[i] = convertSeconds(times[i], samplerate)
        if((start >= convertedTimes[0] and start <= convertedTimes[1]) or
            (end >= convertedTimes[0] and end <= convertedTimes[1] ) ):
            if overlap_percentage(convertedTimes, [start, end]) > 0.5:
                return times[2]
            else:
                return opposite(times[2])



# returns the percentage overlap of the edfList onto the tseList
def overlap_percentage(tseList, edfList):
    min1 = min(tseList)
    max1 = max(tseList)
    min2 = min( edfList)
    max2 = max( edfList)

    overlap = max(0, min(max1, max2) - max(min1, min2))
    lengthx = max1-min1
    lengthy = max2-min2

    return  overlap/lengthy

# helper to labelTimes
# returns seizure for background and background for seizure
def opposite(type):
    if type == "seiz":
        return "bckg"
    else:
        return "seiz"


# converts seconds to an index
def convertSeconds(seconds, samplerate):
    return int(round(float(seconds) * float(samplerate)))


# params: filedata: the python file object for one edf
#         tseArray: the array of the tse time stamps
#         fileName: the name of the edf file
def writeSignals(filedata, tseArray, fileName):
    signals = filedata[1]
    frequencies = filedata[0]
    edfLength = len(signals[1])

    # for every channel
    for i in range(len(signals)):
        index = 0
        for array in range(edfLength // 2500):
            signals_2500 = np.empty(2500)
            end = index + 2500
            seiz = False
            if(labelTimes(index, end, tseArray, frequencies[i]) == 'seiz'):
                seiz = True
            for sample in range(2500):
                signals_2500[sample] = signals[i][index]
                index = index + 1
            if(seiz):
                np.save(seizuredir + filename + "_channel" + str(i) + "_array" + str(array), signals_2500)
            else:
                np.save(backgrounddir + filename + "_channel" + str(i) + "_array" + str(array), signals_2500)




def bruteforce(signals):
    print(len(signals[0]))
    print(len(signals))
    # brute force (could be made more optimal)
    row = 0
    col = 0
    signals_2500 =[]
    while row != len(signals):
      elem = []
      while len(elem) != 2500:
        if col == (len(signals[0]) - 1):
          col = 0
          row+=1
          # print("row", row, "col", col)
        if row == len(signals): break
        elem.append(signals[row][col])
        col+=1
      if row == len(signals): break
      signals_2500.append(elem)

    print('signals_2500 (brute force method)', len(signals_2500))
    print(len(signals_2500[404]))
    # printing error about IOPub data rate exeeded,
    # think we cant print whole thing bc it's massive, brute force works tho
