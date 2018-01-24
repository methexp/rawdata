cd "L:\daten\expra14".
*cd "O:\labordaten\daten\expra14".
get file "expra14_20140618.sav".

aggregate /outfile=* /break=vpnr mood arousal s2valent /bewert_response1 = mean(bewert_response1).
casestovars /id vpnr mood arousal /index s2valent.


* Diagrammerstellung.
GGRAPH
  /GRAPHDATASET NAME="graphdataset" VARIABLES=mood MEANCI(bewert_response1.1, 95) 
    MEANCI(bewert_response1.2, 95) MISSING=LISTWISE REPORTMISSING=NO
    TRANSFORM=VARSTOCASES(SUMMARY="#SUMMARY" INDEX="#INDEX" LOW="#LOW" HIGH="#HIGH")
  /GRAPHSPEC SOURCE=INLINE.
BEGIN GPL
  SOURCE: s=userSource(id("graphdataset"))
  DATA: mood=col(source(s), name("mood"), unit.category())
  DATA: SUMMARY=col(source(s), name("#SUMMARY"))
  DATA: INDEX=col(source(s), name("#INDEX"), unit.category())
  DATA: LOW=col(source(s), name("#LOW"))
  DATA: HIGH=col(source(s), name("#HIGH"))
  GUIDE: axis(dim(1), label("mood"))
  GUIDE: axis(dim(2), label("Mittelwert"))
  GUIDE: legend(aesthetic(aesthetic.color.interior), label("mood"))
  GUIDE: text.footnote(label("Fehlerbalken: 95% CI"))
  SCALE: cat(dim(1), include("1", "2", "3"))
  SCALE: linear(dim(2), include(0))
  SCALE: cat(aesthetic(aesthetic.color.interior), include("0", "1"))
  ELEMENT: line(position(mood*SUMMARY), color.interior(INDEX), missing.wings())
  ELEMENT: interval(position(region.spread.range(mood*(LOW+HIGH))), shape.interior(shape.ibeam), 
    color.interior(INDEX))
END GPL.



cd "L:\daten\expra14".

get file "expra14_20140618.sav".

aggregate /outfile=* /break=vpnr mood arousal s1dauer s2valent /bewert_response1 = mean(bewert_response1).
casestovars /id vpnr mood arousal /index s1dauer s2valent.


* Diagrammerstellung.
GGRAPH
  /GRAPHDATASET NAME="graphdataset" VARIABLES=mood MEANCI(bewert_response1.0.1, 95) 
    MEANCI(bewert_response1.0.2, 95) MISSING=LISTWISE REPORTMISSING=NO
    TRANSFORM=VARSTOCASES(SUMMARY="#SUMMARY" INDEX="#INDEX" LOW="#LOW" HIGH="#HIGH")
  /GRAPHSPEC SOURCE=INLINE.
BEGIN GPL
  SOURCE: s=userSource(id("graphdataset"))
  DATA: mood=col(source(s), name("mood"), unit.category())
  DATA: SUMMARY=col(source(s), name("#SUMMARY"))
  DATA: INDEX=col(source(s), name("#INDEX"), unit.category())
  DATA: LOW=col(source(s), name("#LOW"))
  DATA: HIGH=col(source(s), name("#HIGH"))
  GUIDE: axis(dim(1), label("mood"))
  GUIDE: axis(dim(2), label("Mittelwert"))
  GUIDE: legend(aesthetic(aesthetic.color.interior), label(""))
  GUIDE: text.footnote(label("Fehlerbalken: 95% CI"))
  SCALE: cat(dim(1), include("1", "2", "3"))
  SCALE: linear(dim(2), include(0))
  SCALE: cat(aesthetic(aesthetic.color.interior), include("0", "1"))
  ELEMENT: line(position(mood*SUMMARY), color.interior(INDEX), missing.wings())
  ELEMENT: interval(position(region.spread.range(mood*(LOW+HIGH))), shape.interior(shape.ibeam), 
    color.interior(INDEX))
END GPL.



* Diagrammerstellung.
GGRAPH
  /GRAPHDATASET NAME="graphdataset" VARIABLES=mood MEANCI(bewert_response1.1.1, 95) 
    MEANCI(bewert_response1.1.2, 95) MISSING=LISTWISE REPORTMISSING=NO
    TRANSFORM=VARSTOCASES(SUMMARY="#SUMMARY" INDEX="#INDEX" LOW="#LOW" HIGH="#HIGH")
  /GRAPHSPEC SOURCE=INLINE.
BEGIN GPL
  SOURCE: s=userSource(id("graphdataset"))
  DATA: mood=col(source(s), name("mood"), unit.category())
  DATA: SUMMARY=col(source(s), name("#SUMMARY"))
  DATA: INDEX=col(source(s), name("#INDEX"), unit.category())
  DATA: LOW=col(source(s), name("#LOW"))
  DATA: HIGH=col(source(s), name("#HIGH"))
  GUIDE: axis(dim(1), label("mood"))
  GUIDE: axis(dim(2), label("Mittelwert"))
  GUIDE: legend(aesthetic(aesthetic.color.interior), label(""))
  GUIDE: text.footnote(label("Fehlerbalken: 95% CI"))
  SCALE: cat(dim(1), include("1", "2", "3"))
  SCALE: linear(dim(2), include(0))
  SCALE: cat(aesthetic(aesthetic.color.interior), include("0", "1"))
  ELEMENT: line(position(mood*SUMMARY), color.interior(INDEX), missing.wings())
  ELEMENT: interval(position(region.spread.range(mood*(LOW+HIGH))), shape.interior(shape.ibeam), 
    color.interior(INDEX))
END GPL.

* Diagrammerstellung.
GGRAPH
  /GRAPHDATASET NAME="graphdataset" VARIABLES=mood MEANCI(bewert_response1.1.1, 95) 
    MEANCI(bewert_response1.1.2, 95) MISSING=LISTWISE REPORTMISSING=NO
    TRANSFORM=VARSTOCASES(SUMMARY="#SUMMARY" INDEX="#INDEX" LOW="#LOW" HIGH="#HIGH")
  /GRAPHSPEC SOURCE=INLINE.
BEGIN GPL
  SOURCE: s=userSource(id("graphdataset"))
  DATA: mood=col(source(s), name("mood"), unit.category())
  DATA: SUMMARY=col(source(s), name("#SUMMARY"))
  DATA: INDEX=col(source(s), name("#INDEX"), unit.category())
  DATA: LOW=col(source(s), name("#LOW"))
  DATA: HIGH=col(source(s), name("#HIGH"))
  COORD: rect(dim(1,2), cluster(3,0))
  GUIDE: axis(dim(3), label("mood"))
  GUIDE: axis(dim(2), label("Mittelwert"))
  GUIDE: legend(aesthetic(aesthetic.color.interior), label(""))
  GUIDE: text.footnote(label("Fehlerbalken: 95% CI"))
  SCALE: cat(dim(3), include("1", "2", "3"))
  SCALE: linear(dim(2), include(0))
  SCALE: cat(aesthetic(aesthetic.color.interior), include("0", "1"))
  SCALE: cat(dim(1), include("0", "1"))
  ELEMENT: interval(position(INDEX*SUMMARY*mood), color.interior(INDEX), 
    shape.interior(shape.square))
  ELEMENT: interval(position(region.spread.range(INDEX*(LOW+HIGH)*mood)), 
    shape.interior(shape.ibeam))
END GPL.
