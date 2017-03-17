*Information about the data:
* N in the TFT Study (60_1) was 4
* N in the CRT Study (60_1.2) was 4
*To be used with tha data file: 60Hzcombined_results.sav

SORT CASES  BY Material.
SPLIT FILE LAYERED BY Material.
DESCRIPTIVES VARIABLES=Correct
  /STATISTICS=MEAN STDDEV MIN MAX.


SORT CASES  BY Material Hz.
SPLIT FILE LAYERED BY Material Hz.
DESCRIPTIVES VARIABLES=Correct
  /STATISTICS=MEAN STDDEV MIN MAX.
