import glob
for file in glob.glob("*.txt"):
    Demos = open(file, 'r')
    DemosNeu = open('./Neu2/'+file, 'w')
    for line in Demos:
        line = line.replace("\t\n", "")
        DemosNeu.write(line)
    Demos.close()
