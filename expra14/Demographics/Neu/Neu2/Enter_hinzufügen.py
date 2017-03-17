import glob
for file in glob.glob("*.txt"):
    Demos = open(file, 'a')
    Demos.write("\n")
    Demos.close()
