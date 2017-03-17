cd "L:\daten\expra14".

get file "expra14_20140618.sav".

aggregate /outfile=* /break=vpnr mood arousal s1dauer s2valent /bewert_response1 = mean(bewert_response1).
casestovars /id vpnr mood arousal /index s1dauer s2valent.

glm bewert_response1.0.1 bewert_response1.0.2 bewert_response1.1.1 bewert_response1.1.2 by mood /wsfactor s1dauer 2 s2valent 2.

*only long presentation duration, by mood.
sort cases by mood .
split file by mood .
glm bewert_response1.0.1 bewert_response1.0.2 bewert_response1.1.1 bewert_response1.1.2 by mood /wsfactor s1dauer 2 s2valent 2.
glm bewert_response1.1.1 bewert_response1.1.2 /wsfactor s2valent 2 /emmeans=tables(s2valent).
split file off.

*separately by presentation duration.
glm bewert_response1.0.1 bewert_response1.0.2 by mood /wsfactor s2valent 2.
glm bewert_response1.1.1 bewert_response1.1.2 by mood /wsfactor s2valent 2 /emmeans=tables(mood*s2valent) /emmeans=tables(s2valent*mood).




*excluding sad mood condition.

get file "expra14_20140618.sav".

sel if mood >1.
exe.

aggregate /outfile=* /break=vpnr mood arousal s1dauer s2valent /bewert_response1 = mean(bewert_response1).
casestovars /id vpnr mood arousal /index s1dauer s2valent.

glm bewert_response1.0.1 bewert_response1.0.2 bewert_response1.1.1 bewert_response1.1.2 by mood /wsfactor s1dauer 2 s2valent 2.
* HE US-Valenz, F(1, 64) = 6.003, p=.017
* Interaktion mit Orienting task: F(1, 64)<1
* Interaktion mit CS-Dauer: F(1, 64) = 1.8, p=.19
* 3fach-Interaktion: F(1, 64) = 1.24, p=.27
*.

*only long presentation duration, by mood.
sort cases by mood .
split file by mood .
glm bewert_response1.0.1 bewert_response1.0.2 bewert_response1.1.1 bewert_response1.1.2 by mood /wsfactor s1dauer 2 s2valent 2.
glm bewert_response1.1.1 bewert_response1.1.2 /wsfactor s2valent 2 /emmeans=tables(s2valent).
glm bewert_response1.0.1 bewert_response1.0.2 /wsfactor s2valent 2 /emmeans=tables(s2valent).
split file off.

** Analyzed separately:
* HE Valenz nur in Aufmerksam, F(1, 32) = 6.41, p=.016, nicht in Neutral, F(1, 32)=1.23, p=.28
* Tendenz zur Interaktion mit CS-Dauer in AUfmerksam, F(1,32) = 2.71, p=.11, aber nicht in Neutral, F<1.

** nur supraliminal: EC für Aufmerksam, F(1, 32)=7.26, p=.011, aber nicht für Neutral, F<1.
** nur subliminal: beide F(1,32)<1


*excluding sad mood condition, including arousal factor.

get file "expra14_20140618.sav".

sel if mood >1.
exe.

aggregate /outfile=* /break=vpnr mood arousal s1dauer s2valent /bewert_response1 = mean(bewert_response1).
casestovars /id vpnr mood arousal /index s1dauer s2valent.

glm bewert_response1.0.1 bewert_response1.0.2 bewert_response1.1.1 bewert_response1.1.2 by mood arousal /wsfactor s1dauer 2 s2valent 2.
* HE US-Valenz, F(1, 64) = 6.21, p=.015
* Interaktion orienting x arousal, F(1, 62) = 4.72, p=.03 (uninteressant)
* Interaktion CS-Dauer x arousal, F(1, 62) = 5.88, p=.02
* Trend zur 3fach-Interaktion USvalenz x Orienting x Arousal, F(1, 62)=3.45, p=.068

*getrennt nach mood.
sort cases by mood .
split file by mood .
glm bewert_response1.0.1 bewert_response1.0.2 bewert_response1.1.1 bewert_response1.1.2 by mood arousal /wsfactor s1dauer 2 s2valent 2.
split file off.

* aufmerksam: HE USvalenz, p=.014, interaktion mit arousal, p=.03
* neutral: trend zu Interaktion CS-Dauer x arousal, p=.06
*.

** getrennt nach arousal.
sort cases by arousal.
split file by arousal.
glm bewert_response1.0.1 bewert_response1.0.2 bewert_response1.1.1 bewert_response1.1.2 by mood arousal /wsfactor s1dauer 2 s2valent 2.
split file off.

* bei arousal=1: trend zu IA CS-Dauer x US-Valenz, p=.08.
* bei arousal=2: trend zu HE CS-Dauer, p=.08
* bei arousal=2 HE US-Valenz, p=.02
* bei arousal=2 trend zu IA US-Valenz x Orienting, p=.02
* bei arousal=2: trend zu HE orienting, p=.06.



sort cases by mood arousal.
split file by mood arousal.
glm bewert_response1.0.1 bewert_response1.0.2 bewert_response1.1.1 bewert_response1.1.2 /wsfactor s1dauer 2 s2valent 2 /emmeans=tables(s2valent).
* aufmerksam, arousal=1: Interaktion CSdauer x USvalenz, p=.046
* aufmerksam, arousal=2: HE USvalenz, p=.005
* neutral: keine sig. Effekte
*.
glm bewert_response1.0.1 bewert_response1.0.2 /wsfactor s2valent 2 /emmeans=tables(s2valent).
*subliminal: 
*Aufmerksam: Fs = 1.5 und 1.9, ps = .23 und .18.
*Neutral: beide F<1.
*.

glm bewert_response1.1.1 bewert_response1.1.2 /wsfactor s2valent 2 /emmeans=tables(s2valent).

*supraliminal: 
*HE US-Valenz nur in Aufmerksam, arousal=2, p=.048.
*Trend zu HE US-Valenz in Aufmerksam und Neutral bei arousal=1 (ps = .11 und .19).
*Neutral, arousal=2: F<1.
*.

split file off.




***.


get file "expra14_20140618.sav".

sel if mood >1.
exe.
compute visible = -1.
if(s1dauer=1) visible=2.
if(s1dauer=0 & ident=0) visible=0.
if(s1dauer=0 & ident>0) visible=1.
exe.
formats visible (f1.0).
crosstabs s1dauer by ident by visible.

aggregate /outfile=* /break=vpnr mood arousal visible s2valent /bewert_response1 = mean(bewert_response1).
casestovars /id vpnr mood arousal /index visible s2valent.

*separate analyses, to avoid listwise exlusion of Ss with one missing value.
glm bewert_response1.0.1 bewert_response1.0.2  by mood arousal /wsfactor s2valent 2.
*keine Effekte bei subliminal/nicht-ident: USvalenz F<1.
* auch nicht, wenn man 1x-identifikation per zufall zulässt, F<1.
glm bewert_response1.1.1 bewert_response1.1.2  by mood arousal /wsfactor s2valent 2.
*keine Effekte bei subliminal/1x ident, USvlaenz F=2.15, p=.17.
glm bewert_response1.2.1 bewert_response1.2.2  by mood arousal /wsfactor s2valent 2.
*klarer Effekt bei supraliminal, USvlaenz F=6.77, p=.012.

*keine weiteren Effekte.

