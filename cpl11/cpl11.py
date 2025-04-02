#
# Built and tested with PsychoPy v2023.2.2 on Windows 10 -----------------------
#
#
#
# Imports ----------------------------------------------------------------------

import psychtoolbox as ptb
from psychopy import core, visual, event, gui#, sound
import csv
import sys
import os, statistics, io, math


# Global options ----

DEBUG = False
EXP = "cpl11"
STIMULUS_SIZE = [72, 72]
# CIRCLE_RADIUS = 41          # r^2 * pi = 72^2; roughly the same area
TARGET_LOCATION = (0, 0) # also for centrals stimuli (ffedback)
stimulus_onset  = .100       # = time in-between array and target
# stimulus_offset = .380 # now from trial list
n_blocks = 14 # todo: check

x_coords = [-1, -.6, -.2, .2, .6, 1]
y_coords = [-1, -1, -1, -1, -1, -1]

x_coords = [i * 480 for i in x_coords]
y_coords = [i * 270 for i in y_coords]

# HSV colors
COLORSPACE = "hsv"
color_offset = 0
colours = [
    [color_offset +   0, .8, .5] # red
  , [color_offset +  60, .8, .5]
  , [color_offset + 120, .8, .5]
  , [color_offset + 180, .8, .5]
  , [color_offset + 240, .8, .5]
  , [color_offset + 300, .8, .5]
]

# COLORSPACE = "rgb"

# > turbo(n = 6) |> gsub(pattern = "FF$", replacement = "") |> encodeString(quote="\"") |>cat(sep = "\n, ")
#colours = [
#    "#30123B"
#    , "#3E9BFE"
#    , "#46F884"
#    , "#E1DD37"
#    , "#F05B12"
#    , "#7A0403"
#]



default_sid = 1

if DEBUG:
    onesec = 1
    n_acquisition = 144
    fullscr = False
else:
    onesec = 1
    n_acquisition = 144 * n_blocks
    fullscr = True


# define some helpful functions (hats off to Tobias Heycke) ----

def instruct(text, further = "Drücke die Leertaste, um fortzufahren.", pos = (0, 0), keyList = 'space', maxWait = math.inf, timeStamped = False):
    
    stimulus = visual.TextStim(win, text = text + "\n\n\n" + further, pos = pos)
    stimulus.draw()
    win.flip()
    core.wait(.1)
    event.clearEvents()
    
    key_press = event.waitKeys(keyList = keyList, maxWait = maxWait, timeStamped = timeStamped)
    if(key_press is None):
        key_press = "NA"
    return key_press


# create a DlgFromDict

info = {
  'Alter': "",
  'Geschlecht':['Bitte geben Sie Ihr Geschlecht an.', 'weiblich', 'männlich', 'divers'],
  'Muttersprache': ['Bitte geben Sie Ihre Muttersprache an.' , 'Deutsch', 'andere'],
  'Farbfehlsichtigkeit': ['Bitte geben Sie an, ob Sie eine Farbfehlsichtigkeit haben.', 'nein', 'ja']}
    
infoDlg = gui.DlgFromDict(
  dictionary=info,
  title = EXP,
  order = ["Alter", "Geschlecht", "Muttersprache", "Farbfehlsichtigkeit"]
)


if infoDlg.OK:  # this will be True (user hit OK) or False (cancelled)
    print(info)
else:
    print('User Cancelled')
    core.quit()


win = visual.Window([1920, 1080], monitor = "testMonitor", units = 'pix', fullscr = fullscr, color = [-1, -1, -1])
win.mouseVisible = False #does not work
trialclock = core.Clock()
mouse = event.Mouse(visible = False) # hide mouse # does not work
# workaround for mouse
mouse.setPos((-1920/2, 1080/2))
mouse.setVisible(0)


# fetch participant id from bash/batch
if len(sys.argv) > 1:
    sid = int(sys.argv[1])
    print("Using sid from parameter.")
else:
    sid = default_sid
    print("Using default sid = "+ str(sid) + ".")



# Import special instruction text
dirname = os.path.dirname(__file__)
# instructions_file = os.path.join(dirname, "stimuli", "instructions" + ".txt")
# with io.open(instructions_file, mode = "r", encoding = "utf-8") as f: # note that we use the io package to be able to specify encoding
#     instruction_text = f.read()
instruction_text = ""
    
# sequence_file = os.path.join(dirname, "stimuli", "sequence-" + str(sid) + ".txt")
# with open(sequence_file) as f:
#     instruction_sequence = f.readlines()
instruction_sequence = ["1", "2", "3", "4", "5", "6"]

# Import stimulus list
stimulus_file = os.path.join(dirname, "stimuli", "acquisition-" + str(sid) + ".csv")
stimulus_file = open(stimulus_file, newline = '')
hands_file = os.path.join(dirname, "stimuli", "hands-for-exp-white.png")
hands_digits_file = os.path.join(dirname, "stimuli", "hands-for-exp-digits.png")
attention_file = os.path.join(dirname, "stimuli", "attention.png")


reader = csv.DictReader(stimulus_file, delimiter = ",")

# Prepare data file
data_file = os.path.join(dirname, "data", str(sid) + ".csv")
data_file = open(data_file, newline = "", mode = "a")

data_writer = csv.DictWriter(data_file, fieldnames = ["sid", "bid", "tid", "target", "target_location", "array_location", "option_1", "option_2", "option_3", "option_4", "option_5", "option_6", "response", "response_time", "target_duration", "response_deadline", "error"])
data_writer.writeheader()



# Prepare demographics file
demographics_file = os.path.join(dirname, "data", "demographics", str(sid)+ ".csv")
demographics_file = open(demographics_file, mode = "a", newline = "")

demographics_writer = csv.DictWriter(demographics_file, fieldnames = ["sid", "age", "gender", "native_language", "impaired_vision"])
demographics_writer.writeheader()
demographics_writer.writerow({
    'sid': sid, "age": info['Alter']
    , 'gender':info['Geschlecht']
    , 'native_language':info["Muttersprache"]
    , 'impaired_vision': info["Farbfehlsichtigkeit"]
})

# Prepare file that holds keys that were pressed during sequence instructions
instruction_data_file = os.path.join(dirname, "data", "instructions" + ".csv")
instruction_data_file = open(instruction_data_file, mode = "a")


# prepare stimuli
trials_per_block = 144

tid = []
target = []
target_location = []
target_duration = []
array_location = []
response_deadline = []
pos_x = [] # no proper function in this experiment

prepared_stimuli = []
prepared_options = []

first_response_location =[]
first_response_time = []

j = 0
for row in reader:
    # material = row["material"]
    # instructions = row["instructions"]
    # effects = row["effects"]
    j += 1
    
    tid.append(int(row['tid']))
    target.append(int(row['target']))
    target_location.append(int(row['target_location']))
    target_duration.append(float(row['target_duration']))
    
    array_location.append(int(row['array_location']))
    response_deadline.append(float(row['response_deadline']))
    
    # stimulus creation
    x_coord = x_coords[int(row['target_location'])] # float(row['pos_x']) # [0, 5]
    pos_x.append(x_coord)
    
    if x_coord==0:
        stimulus = visual.TextStim(win, "?", color = [0, 0, 0])
    else:
        # stimulus = visual.Circle(win, radius = CIRCLE_RADIUS, units = 'pix', lineWidth = 0, edges = 40) # roughly the same area as rectangles
        stimulus = visual.Rect(win, size = STIMULUS_SIZE, pos = (x_coord, 270), lineWidth = 2, lineColor = "#888888")
        stimulus.setColor(colours[int(row['target'])], COLORSPACE)
        # stimulus = visual.GratingStim(win, tex="sin", mask="gauss", units = 'pix', texRes=256, pos = (0, 0),
        #    size = STIMULUS_SIZE, sf= [4/96,0], ori = 0 + float(row['target']) * 30)
    stimulus.draw()
    
    response_options = []
    
    # ori = 1 + float(row['option_' + str(i + 1)])/2
    # ori = 1 + float(row['target'])/2
    
    for i in range(0, 6):
        tmp_stim = int(row['option_' + str(i + 1)])
        response_options.append(tmp_stim)
    
    prepared_options.append(response_options)
    prepared_stimuli.append(stimulus)

instruction_stimuli = [] # targets during instruction phase
instruction_locations = [1, 0, 5, 4, 2, 3]
for i in range(0, 6):
    # stimulus = visual.Circle(win, radius = CIRCLE_RADIUS, units = 'pix', lineWidth = 0, edges = 40) # roughly the same area as rectangles
    stimulus = visual.Rect(win, size = STIMULUS_SIZE, pos = (x_coords[instruction_locations[i]], 270), lineWidth = 2, lineColor = "#888888")
    stimulus.setColor(colours[i], COLORSPACE)
    instruction_stimuli.append(stimulus)

highlight_stimuli = [] # white 'frames' around array stimuli during instructions
for i in range(0, 6):
    stimulus = visual.Rect(win, size = [i + 2 for i in STIMULUS_SIZE], pos = (x_coords[i], y_coords[i]), fillColor=[1, 1, 1], lineColor = [0, 0, 0], lineWidth = 0)
    highlight_stimuli.append(stimulus)


# stimulus_array = []

# ori = 1 + i/2, sf = [4, 0]

# for i in range(0, 6):
#     # tmpstim = visual.Rect(win, size = (72,72), pos = (x_coords[i], 0), fillColor = [-1, -1, -1], lineColor = [-.9, -.9, -.9])
#     tmpstim = visual.GratingStim(win, tex="sin", mask="gauss", texRes=256, pos = (x_coords[i], 0),
#            size = STIMULUS_SIZE, sf = [4/96, 0], ori = 0 + i * 30)
#     stimulus_array.append(tmpstim)
    
full_array = []

for i in range(0, 6):
    tmp_i = []
    for j in range(0, 6):
        # tmp_ij = visual.GratingStim(
        #     win, tex="sin", mask="gauss", texRes=256, pos = (x_coords[i], y_coords[i]),
        #     size = STIMULUS_SIZE, sf = [4/96, 0], ori = 0 + j * 30
        # )
        tmp_ij = visual.Rect(win, size = STIMULUS_SIZE, pos = (x_coords[i], y_coords[i]), lineWidth = 2, lineColor = "#888888")
        # tmp_ij = visual.Circle(win, radius = 48, pos = (x_coords[i], y_coords[i]), units = 'pix', lineWidth = 0, edges = 120)
        tmp_ij.setColor(colours[j], COLORSPACE)
        tmp_i.append(tmp_ij)
    tmp_i.append(visual.Rect(win, size = STIMULUS_SIZE, pos = (x_coords[i], y_coords[i]), lineWidth = 2, lineColor = "#888888", color = [0, 0, 1], colorSpace = "hsv"))
    full_array.append(tmp_i)

# extra array with possible target locations
target_locations = []
for j in range(0, 6):
    tmp_ij = visual.Rect(win, size = STIMULUS_SIZE, pos = (x_coords[j], 270), lineWidth = 2, lineColor = "#888888", fillColor = "#000000")
    target_locations.append(tmp_ij)


# def draw_array(stimulus_array):
#     for i in range(len(stimulus_array)):
#         stim = stimulus_array[i]
#         stim.draw()

def draw_full_array(full_array, which):
    for i in range(len(full_array)):
        stim = full_array[i][which[i]]
        stim.draw()

in_words = []
for i in range(trials_per_block + 1):
    in_words.append(str(i) + "-mal")
in_words[slice(1, 13)] = ["einmal", "zweimal", "dreimal", "viermal", "fünfmal", "sechsmal", "siebenmal", "achtmal", "neunmal", "zehnmal", "elfmal", "zwölfmal"]





too_fast = visual.TextStim(win, text = "Bitte reagiere erst dann,\nwenn das weiße Quadrat angezeigt wird.", pos = TARGET_LOCATION)
too_slow = visual.TextStim(win, text = "Zu langsam!\nBitte versuche, schneller zu reagieren.", pos = TARGET_LOCATION)
error_feedback = visual.TextStim(win, text = "Falsche Taste!", pos = TARGET_LOCATION)
fixation_cross = visual.TextStim(win, text = "+", pos = TARGET_LOCATION, color = [0, 0, 0])
black = visual.Rect(win, size = [1920, 1080], fillColor = [-1, -1, -1], lineWidth = 0)

responses = {"y": 1, "x": 2, "c": 3, "comma":4, "period":5, "minus":6}
confidence_responses = {"lctrl": "high", "rctrl": "low"}
block_length = 144

errors = []
countdown = []
confidence = []

for i in range(5):
    stim = visual.TextStim(win, text = str(5-i))
    countdown.append(stim)
    
    
setup_drawing = visual.ImageStim(win = win, image = hands_file, pos = (0, -300))
# setup_drawing_digits = visual.ImageStim(win = win, image = hands_digits_file, pos = (0, -300))

attention = visual.ImageStim(win = win, image = attention_file, pos = (0, 200))


black.draw()
win.flip()

array_colors_instructions = [
    [0, 2, 1, 4, 3, 5]
  , [2, 1, 3, 0, 5, 4]
  , [1, 5, 2, 3, 4, 0]
  , [5, 4, 0, 3, 1, 2]
  , [3, 0, 1, 5, 4, 2]
  , [4, 3, 0, 2, 1, 5]
]

instruction_texts = [
    "Wenn das Quadrat ganz links die Farbe des oberen Quadrats hat, dann drücke die ganz linke Taste."
    , "Wenn das Quadrat an der zweiten Position von links die Farbe des oberen Quadrats hat, dann drücke die zweite Taste von links."
    , "Wenn das Quadrat an der dritten Position von links die Farbe des oberen Quadrats hat, dann drücke die dritte Taste von links."
    , "Wenn das Quadrat an der dritten Position von rechts die Farbe des oberen Quadrats hat, dann drücke die dritte Taste von rechts."
    , "Wenn das Quadrat an der zweiten Position von rechts die Farbe  des oberen Quadrats hat, dann drücke die zweite Taste von rechts."
    , "Wenn das Quadrat ganz rechts die Farbe des oberen Quadrats hat, dann drücke die ganz rechte Taste."
]

instruction_keys = ["y", "x", "c", "comma", "period", "minus"]

# Experiment proper ----
block_number = 1
n_too_slow = 0
n_too_fast = 0
n_error = 0

instruct(str(sid), further = "")

instruct("Herzlich willkommen und vielen Dank, dass du an unserer Studie teilnimmst! Wir untersuchen den Zusammenhang zwischen räumlicher Aufmerksamkeit und Reaktionsfähigkeit.\n\nDie Studie wird vollständig am Computer durchgeführt: Lies dir deshalb die folgenden Instruktionen sorgfältig durch und versuche in der anschließenden Experimentalphase, diese so gut es geht zu befolgen.\n\nBevor du in die Experimentalphase startest werden wir dir aber auch noch einmal die Gelegenheit geben, etwaige Fragen mit dem Versuchsleiter bzw. der Versuchsleiterin zu klären.")
mouse.setPos((-1920/2, 1080/2))
while True: # while loop for eventually repeating instructions
    
    # ----
    # Zuordnung Finger zu Tasten
    setup_drawing.draw()
    instruct("Lege zunächst Ringfinger, Mittelfinger und Zeigefinger deiner linken Hand auf die drei linken Tasten, die auf der Tastatur markiert sind. Lege dann Zeigefinger, Mittelfinger und Ringfinger der rechten Hand auf die drei rechten der markierten Tasten der Tastatur.", pos = (0, 0))
    
    # ----
    # Anordnung des Arrays
    draw_full_array(full_array, which = array_colors_instructions[0])
    for j in range(0, 6):
        target_locations[j].draw()
    instruct("In jedem Durchgang zeigen wir dir zunächst sechs farbige Quadrate im unteren Drittel des Bildschirms. Welche Farbe an welcher Position angezeigt wird, verändert sich dabei in jedem Durchgang.", pos = (0, 0))
    
    # ----
    # Zentrales Target
    draw_full_array(full_array, which = array_colors_instructions[0])
    for j in range(0, 6):
        target_locations[j].draw()
    stim = instruction_stimuli[0]
    stim.draw()
    instruct("Kurz darauf erscheint im oberen Drittel des Bildschirms für einen kurzen Moment ein farbiges Quadrat an einer von sechs festgelegten Positionen.", pos = (0, 0))
    
    # ----
    draw_full_array(full_array, which = array_colors_instructions[0])
    for j in range(0, 6):
        target_locations[j].draw()
    stim = instruction_stimuli[0]
    stim.draw()
    instruct("Deine Aufgabe besteht darin, möglichst schnell die Farbe des oberen Quadrats zu erkennen, dann das untere Quadrat mit der gleichen Farbe zu finden, und die zugehörige Taste zu drücken.", pos = (0, 0))
    
    for i in range(0, 6):
        for j in range(0, 6):
            target_locations[j].draw()
        stim = instruction_stimuli[i]
        stim.draw()
        stim = highlight_stimuli[i]
        stim.draw()
        draw_full_array(full_array, which = array_colors_instructions[i])
        win.flip()
        core.wait(.15)
        stim = highlight_stimuli[i]
        stim.draw()
        draw_full_array(full_array, which = array_colors_instructions[i])
        instruct(instruction_texts[i], pos = (0, 0), keyList = instruction_keys[i], further = "Drücke jetzt diese Taste, um fortzufahren.")
        # tmp_sound = sound_array[0]
        # tmp_sound.play()


    row["instructions"] = "sequence concealed"
    
    instruct(text = "Versuche in der folgenden Experimentalphase, immer möglichst schnell das passende Quadrat zu finden und mit der entsprechenden Taste zu reagieren. Das kann ziemlich anstrengend sein, aber die Untersuchung ist in vierzehn kürzere Blöcke unterteilt, zwischen denen du eine Pause machen kannst.", pos = (0, 0))
    if(row["instructions"]=="sequence revealed"):
        # setup_drawing_digits.draw()
        instruct(text = instruction_text, pos = (0, 100))
        for j in range(len(instruction_sequence)):
            draw_full_array(full_array, which = range(0, 6))
            stim = instruction_stimuli[int(instruction_sequence[j])-1]
            stim.draw()
            out = instruct("Bitte präge dir die Reihenfolge der Quadrate ein.", pos = (0, -300), maxWait = 1, further = "", keyList = ["y", "x", "c", "comma", "period", "minus"])
            instruction_data_file.write(str(out[0]) + "\n")
        if(row["material"]=="probabilistic"):
            instruct("Das Quadrat wird jedoch nicht immer der Reihenfolge folgen:\n\nIn jedem Durchgang wird neu entschieden, ob das Quadrat an der Position angezeigt wird, die der Reihenfolge folgt, oder an einer der anderen Positionen. In 3 von 5 Fällen (also in 60% der Durchgänge) wird das Quadrat der Reihenfolge folgen.")
        else:
            if row["material_order"] == "regular first":
                instruct("Das Quadrat wird jedoch nicht immer der Reihenfolge folgen:\n\nNur in ungeraden Blöcken (also den Blöcken 1, 3, 5, 7, 9, 11 und 13) wird das Quadrat der Reihenfolge folgen. In geraden Blöcken (also den Blöcken 2, 4, 6, 8, 10, 12 und 14) wird das Quadrat an einer zufällig ausgewählten Position erscheinen.")
            else:
                instruct("Das Quadrat wird jedoch nicht immer der Reihenfolge folgen:\n\nNur in geraden Blöcken (also den Blöcken 2, 4, 6, 8, 10, 12 und 14) wird das Quadrat der Reihenfolge folgen. In ungeraden Blöcken (also den Blöcken 1, 3, 5, 7, 9, 11 und 13) wird das Quadrat an einer zufällig ausgewählten Position erscheinen.")
            
    instruct("Zusammenfassung\n\n1.) Lege Ring-, Mittel- und Zeigefinger deiner Hände auf die markierten Tasten der Tastatur und lasse sie dort ruhen.\n2.) Während der Untersuchung erscheint im oberen Drittel des Bildschirm ein farbiges Quadrat an einer von sechs Positionen.\n3.) Finde das untere Quadrat der gleichen Farbe. Drücke möglichst schnell die entsprechende Taste auf der Tastatur. Bitte versuche dabei aber auch, nicht allzu viele Fehler zu machen."
    + ("\n4.) Nutze dein Wissen über die Reihenfolge, um die Aufgabe möglichst gut zu bearbeiten." if (row["instructions"]=="sequence revealed") else ""))
    out = instruct("Alles verstanden?", further = "Falls du die Aufgabenstellung noch einmal lesen möchtest, drücke die Leertaste. Wenn du Fragen hast oder dir unsicher bist, ob du die Aufgabe richtig verstanden hast, kannst du dich jetzt auch an die Versuchsleiterin oder den Versuchsleiter wenden. Falls du mit dem Experiment loslegen willst, drücke die 'w'-Taste.", keyList = ['space', 'w'])
    if out==['w']:
        break

instruction_data_file.close()


mouse.setPos((-1920/2, 1080/2))

# Countdown
get_ready= visual.TextStim(win = win, text = "Bitte lege deine Finger auf die markierten Tasten.\nGleich geht es los...", pos = (0, -200))

for i in range(len(countdown)):
    stim = countdown[i]
    get_ready.draw()
    stim.draw()
    win.flip()
    core.wait(1*onesec)

# tmp_sound = sound_array[0]

if DEBUG:
    trials = range(len(prepared_stimuli))
else:
    trials = range(len(prepared_stimuli))


for t in trials:
    mouse.setPos((-1920/2, 1080/2))
    confidence = ""
    stimulus_offset = stimulus_onset + target_duration[t]

    # Prepare stimuli for this trial...
    stimulus = prepared_stimuli[t]
    stimulus.draw() # already draw once because first time might take extra time
    black.draw()    # but cover everything!
    
    # Start the trial...  
    for i in range(0, 6):
        tl = target_locations[i]
        tl.draw()
    draw_full_array(full_array, which = prepared_options[t])
    win.flip()
    event.clearEvents()
    trialclock.reset()
    
    is_wagering = (pos_x[t] == 0)
    target_presented = False
    
    while True:
        present_stimulus = False
        draw_full_array(full_array, which = prepared_options[t])
        for i in range(0, 6):
            tl = target_locations[i]
            tl.draw()
        
        t1 = trialclock.getTime()
        if (t1>=stimulus_onset) and (t1 < stimulus_offset):
            # then, add a stimulus
            present_stimulus = True
            target_presented = True
            stimulus.draw()
            # tmp_sound.stop()
        
        win.flip()
        key = event.getKeys(keyList = ["y", "x", "c", "comma", "period", "minus"], timeStamped = trialclock)
        
        if len(key) > 0:
            resp = responses[key[0][0]]
            error = int(resp != array_location[t])
            errors.append(error)
            n_error += error
            
            # if not present_stimulus:
            #x    tmp_sound.stop()
            # tmp_sound = sound_array[resp - 1]
            # tmp_sound.play()
            
            if not target_presented:
                draw_full_array(full_array, which = prepared_options[t])
                too_fast.draw()
                win.flip()
                core.wait(2*onesec)
                n_too_fast += 1
                
                if is_wagering:
                    tmp_stim = instruction_stimuli[resp-1]
                    draw_full_array(full_array, which = prepared_options[t])
                    tmp_stim.draw()
                    win.flip()
                    core.wait(.5)
                    sicher = instruct("Sicher oder unsicher?\n\nLinks: Sicher                                Rechts: Unsicher", keyList = ["lctrl", "rctrl"], further = "", timeStamped = True)
                    confidence = confidence_responses[sicher[0][0]]
                
                break
                
            else: # = if target_presented
                if is_wagering:
                    tmp_stim = instruction_stimuli[resp-1]
                    draw_full_array(full_array, which = prepared_options[t])
                    tmp_stim.draw()
                    win.flip()
                    core.wait(.5)
                    sicher = instruct("Sicher oder unsicher?\n\nLinks: Sicher                                Rechts: Unsicher", keyList = ["lctrl", "rctrl"], further = "", timeStamped = True)
                    confidence = confidence_responses[sicher[0][0]]
                    
                if trialclock.getTime()>(response_deadline[t]+stimulus_onset): # response deadline exceeded
                    draw_full_array(full_array, which = prepared_options[t])
                    attention.draw()
                    too_slow.draw()
                    win.flip()
                    core.wait(1.2*onesec)
                    event.clearEvents()
                    n_too_slow += 1
                    win.flip()
                elif error and not is_wagering: # error feedback
                    draw_full_array(full_array, which = prepared_options[t])
                    error_feedback.draw()
                    win.flip()
                    core.wait(0.18*onesec)
                    win.flip()
                else:
                    draw_full_array(full_array, which = prepared_options[t])
                    win.flip()
                    # core.wait(0.06*onesec)
                break
            
    # What is done after each trial phase...
            
    if(len(key) == 0):
        data_writer.writerow({
        "sid": sid
        , "bid": block_number
        , "tid": tid[t]
        # , "material": material
        # , "instructions": instructions
        # , "effects": effects
        , "target": target[t]
        , "target_location": target_location[t]
        , "array_location": array_location[t]
        , "option_1": prepared_options[t][0]
        , "option_2": prepared_options[t][1]
        , "option_3": prepared_options[t][2]
        , "option_4": prepared_options[t][3]
        , "option_5": prepared_options[t][4]
        , "option_6": prepared_options[t][5]
        , "target_duration": target_duration[t]
        , "response_deadline": response_deadline[t]
        })
        
    
    # log all key presses
    for k in range(len(key)):
        
        resp = responses[key[k][0]]
        error = int(resp != array_location[t])
        data_writer.writerow({
        "sid": sid
        , "bid": block_number
        , "tid": tid[t]
        # , "material": material
        # , "instructions": instructions
        # , "effects": effects
        , "target": target[t]
        , "target_location": target_location[t]
        , "array_location": array_location[t]
        , "option_1": prepared_options[t][0]
        , "option_2": prepared_options[t][1]
        , "option_3": prepared_options[t][2]
        , "option_4": prepared_options[t][3]
        , "option_5": prepared_options[t][4]
        , "option_6": prepared_options[t][5]
        , "response": responses[key[k][0]]
        , "response_time": round(key[k][1] - stimulus_onset, 4)
        , "target_duration": target_duration[t]
        , "response_deadline": response_deadline[t]
        , "error": error
        # , "confidence": confidence
        })
    black.draw()
    win.flip()
    core.wait(0.3*onesec) # Eberhardt et al., 2017: After the participant's response, the screen went black for 300msec
    
    
    # Adds block structure (for breaks, feedback, etc.)
    if (t+1) % block_length == 0:
        if (t+1) < len(prepared_stimuli):
            # feedback
            msg_text = "Das war der " + str(block_number) + ". Block."
            
            if n_too_slow > 8:
                msg_text += "\n\nDu hast in diesem Block " + str(in_words[n_too_slow]) + " zu langsam reagiert."
                msg_text += " Bitte versuche, im kommenden Block schneller zu reagieren."
                
            if n_error > 50:
                msg_text += "\n\n Du hast in diesem Block " + str(in_words[n_error]) + " mit der falschen Taste reagiert."
                msg_text += "Bitte versuche, weniger Fehler zu machen."
                        
            block_number += 1
            n_too_fast = 0
            n_too_slow = 0
            n_error = 0
            
            # adaptive response deadline
            # if statistics.mean(errors) <.2: mean() needs at least one observation
            #     shift_response_deadline += -.05
            
            if (t+1) >= n_acquisition:
                block_length = 10000 # prolong last block
                instruct("Super, du hast den größten Teil des Experiments geschafft!\n\nIn den vorangegangenen Blöcken sind die Quadrate nicht zufällig an einer der Bildschirmpositionen angezeigt worden, sondern die Quadrate folgten einer Reihenfolge. Vielleicht ist dir das ja sogar schon aufgefallen!\n\nIm nun folgenden Block möchten wir herausfinden, ob du einen Teil oder sogar die gesamte Reihenfolge entdecken konntest.")
                instruct("Hierzu werden wir dir einige Male zwei Quadrate nacheinander zeigen; wie bisher ist es für diese beiden Quadrate deine Aufgabe, jeweils die zugehörige Taste auf der Tastatur zu drücken.\n\nIm Anschluss zeigen wir dir ein Fragezeichen; bitte drücke nach Erscheinen des Fragezeichens die Taste der Tastatur,von der du glaubst, dass sie die richtige ist, um die Reihenfolge fortzusetzen. Dann erscheint auch das Quadrat, das zu der von dir ausgewählten Taste passt.")
                instruct("Gib danach bitte auch kurz mithilfe der weiß markierten Tasten an, ob du dir eher sicher oder eher unsicher bist, ob du das richtige Quadrat gewählt hast.\n\nDrücke die linke weiß markierte Taste, wenn du dir eher sicher bist, und drücke die rechte weiß markierte Taste, wenn du dir eher unsicher bist.")
                instruct("Im folgenden Teil des Experiments gibt es keinen Zeitdruck mehr. Bitte versuche, immer die richtige Taste zu drücken und so möglichst keine Fehler zu machen.")
                instruct(instruction_text, further = "Drücke die Leertaste, um mit dem letzten Block zu beginnen.")
            #errors = []
            else:
                instruct(text = msg_text, further = "Drücke die Leertaste, um mit dem nächsten Block zu beginnen.")
            
            # Countdown
            for i in range(len(countdown)):
                stim = countdown[i]
                stim.draw()
                get_ready.draw()
                win.flip()
                core.wait(1*onesec)
        
        event.clearEvents()


# Thank you and goodbye
instruct(text = "Geschafft, das war der letzte Block!\n\nBitte melde dich jetzt wieder bei der Versuchsleitung. Es folgt noch eine kurze Nachbefragung.", further = "", keyList = "q")



# Closing ----
data_file.close()
win.close()
core.quit()
