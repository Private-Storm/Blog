### Fehlerliste stand 19.08.2017 BCEditor

* **Schriftgröße zur Laufzeit, wird ignoriert.**

      procedure SetFontSizeOnClick(Sender : TObject);
      begin
        Editor.Font.Size := 12;
      end;
      
Obiges hat für den Editor keine Bedeutung, es wird nur der Value gesetzt, den man in der Json definiert hat, sollte so nicht sein oder? Es sei denn, das Konzept ist so, dass man wenn man die Schriftgröße zur Laufzeit ändern will, man den Value in die JSon schreiben muss? Wenn das so ist, dann würden aber die ganzen Properties im Object Inspector keinen Sinn mehr ergeben. Vor allem was ist, wenn man so eine Änderung nur temporär haben will für eine bestimmte geöffnete Datei, man aber mit den Standorteinstellungen sonst glücklich ist?

* **Darstellungsfehler im linken Rand, wenn Schriftgröße > 10px**

Zur Schriftgröße gibt es bei mir hier einen Bug, solange man Werte nimmt die nicht über 10 Pixel gehen ist alles ok, geht man über 10px hinaus entstehen schwarze Blöcke im Border der auch die Zeilennummern anzeigt, siehe Screenshot dazu, diese werden immer größer, je größer die Schriftgröße.


![FehlerRand](https://github.com/Private-Storm/Blog/blob/master/BCEditor/LeftMargin.PNG)


* **Schriftgröße und dynamischer Wechsel der Color.JSons** 

Wenn z.B. in der Default.JSon die Schriftgröße für den Editor auf 9px festlegt wurde und in der Monokai.JSon die Schriftgröße auf 12px und man zur Laufzeit dynamisch, zwischen den beiden JSons wechselt, wird nur die Schriftgröße genommen von der JSon die der Editor zu erst geladen hat.

Beispiel man startet die Demo und lädt zuerst die Default.JSon, nun wechselt man auf Monokai, wo eine andere Schriftgröße und Schriftart definiert ist, bleibt die Größe und auch die Schriftart die man in Default.JSon festgelegt hat.

Ich weiß jetzt nicht ob dies nur die Schriftart und Schriftgröße betrifft, das kann sich auch noch auf weitere Dinge beziehen.

* **CodeFolding**

Funktioniert nicht richtig, man kann seinen Code maximal 1x ein und wieder ausklappen, danach hat ein weiterer Klick keine Bedeutung mehr, der Code wird danach nicht mehr ein oder ausgeklappt. Ich hatte auch schon das Phänomen, dass der Code eingeklappt war und sich nicht wieder ausklappen lies.

Was noch wesentlich dramatischer ist, wenn man eine Datei in den Editor lädt, passiert folgendes: Der Editor zeigt eine gewisse Anzahl von Zeilen an, beim scrollen würde man erwarten, dass der Rest der Datei angezeigt wird, dies ist nicht der Fall, die weiteren Zeilen werden nicht angezeigt (das heisst, so ist es nicht ganz richtig, nur über Umwege) wenn man die restlichen Zeilen angezeigt bekommen möchte, muss man einmalig den Code per Codeholding zusammen und wieder aufklappen, erst dann tauchen die Zeilen (auch beim Scrollen) auf vorher nicht! Dabei verschwindet aber die allererste Zeile im Editor. Mir ist es nur einmalig per Zufall gelungen die Zeile wieder zum Vorschein zu bringen.


* **CompletionProposal**

Bei mir gibt es weiter den Bug, bei **"STRG+Space"** resultiert in:

    EAsertionFailed BCEditor.pas Zeile 6838  Assert(not (ecProcessingCommand in FState))
    
die Exception wird auch geworfen, wenn man das CompletionProposal auf **Enabled = false** setzt.

Mir ist aber die Funktionsweise auch gerade nicht so ganz klar, wo legt man denn die Code Templates an? Ich hab dazu die Einstellung nicht gefunden, ausser Columns (bin mir aber sicher, dass die mal da war?)

* **Datei laden**

Wenn man eine Datei lädt, beispielsweise **Test.pas** hat als Highlighter aber z.B. CSS.JSon gewählt knallt es.

Das bedeutet in der jetzigen Version ist es so, dass man zwingend darauf achten muss, dass der richtige Highlighter entsprechend der geladenen Datei eingestellt ist.

    Exception ERangeError Line 446 is not visible TCustomBCEditor.LinesToRows.....
    Zeile: 5357
    
tritt auch bei Copy & Paste im Editor auf.  
    
Das geht aber noch weiter ein **WordWrap = True** eingestellt, bevor die Datei geladen wird ergibt:

    Access violation 0x000000000
    
Da scheint es mir so, als wenn irgendwas vorher nicht Initialisiert wurde.

* **Löschen von Zeilen im Editor während der Laufzeit**

Dies ergibt in eine **Zugriffsverletzung** in der BCEditor.Highlighter.pas.
Erster Halt in Zeile 3000


    if (Assigned(AFind.FRange) and not AFind.FRange.Prepared) then
    
    
Teilweise aber auch:


     Assertion fehlgeschlagen Zeile 6838 BcEditor.pas
     
     
 * Texteingabe zur Laufzeit
 
 Wenn der Editor leer ist und man jetzt z.B. folgendes eingeben will:
 
 
           $(function)() {}
          
       
ist alles gut, aber sobald man zwischen die zwei geschweiften Klammern den Cursor positioniert und return drückt um eine solche Ansicht zu haben:
 
 
           $(function)() {

          }
          
          
 Gibt es folgende Exception:
 
 
    ERangeError Meldung Line 1 is not visible Exception BCEditor.pas Zeile: 5357

</br>

> Ich würde mir die ganze Text laden editieren und löschen Geschichte nochmal genau ansehen, hier scheint es einen Haufen an Fehlern zu geben.

</br>

Meine Hauptvermutung ist, dass es am Highlighter liegt, bzw. dem parsen des Textes. Denn wenn es knall dann hauptsächlich im Highlighter. Ich glaube das ist ein grundlegender Fehler im Design? Hier müsste man ggf. dafür sorgen das der Highlighter wenn es beim parsen zu einem Fehler kommt der dies intern ohne Exception verarbeitet (quasi schluckt...) Denn es macht zumindest für mich keinen Sinn, dass der Parser Exceptions schmeisst, weil man den falschen Highlighter benutzt oder der Code nicht dem Highlighter entspricht? Nur so ein Gedanke, aber Sublime ist das auch egal, wenn der Code nicht einem Highlighter entspricht wird der Text ungeparsed ohne Highlighting dargestellt.


* **Zeilennummern**

Teilweise (nicht immer, leider konnte ich dies bisher nicht reproduzieren) werden die Zeilennummern falsch gezeichnet (und zwar so das diese nicht mehr lesbar sind.)
Dazu kommt, bei mir werden die Zeilennummern nur partiell angezeigt also z.B. 

 *1.2.3....10..20..24*

Wenn ich mit dem Cursor in Zeile 1 klicke und nun mit Cursor down alle Zeilen durchwandere, werden danach alle Zeilennummern von 1-24 angezeigt.


![Line_Number_Bug](https://github.com/Private-Storm/Blog/blob/master/BCEditor/Editor_LinesNr_Bug.PNG)



* **Vertical Scrollbar**

Befüllt man den Editor mit Text zur Designtime kommt es nach dem Start zu folgendem Phänomen, die Scrollbar steht ganz oben, der Text im Editor steht auf der letzten Zeile, der obere Bereich des Textes ist nicht sichtbar. Eigentlich müsste die Scrollbar unten stehen, da das ende des Textes erreicht ist.

Teilweise erscheinen im Editor auch chinesichse Zeichen, ist mir zwei mal passiert jetzt, ich versuche das mal zu provozieren um zu ermitteln was das genau auftritt. (Ansi / Unicode Problem?)

Screenshot


![Scrollbar_Bug](https://github.com/Private-Storm/Blog/blob/master/BCEditor/Scrollbar_Bug.PNG)


> Folgender Vorschlag, implementiere mal nichts neues im Moment. Wenn Du Zeit hast versuche mal obiges nach und nach zu fixen. Ich kann Dir vorschlagen, mit Dir zusammen dann mal alles was bis jetzt enthalten ist (sämtliche Eigenschaften und die Colors sowie Highlighter.jsons komplett zu prüfen, ob wirklich unter allen Umständen alles auch verarbeitet wird so wie es soll. Wenn dem so ist, erst dann würde ich weiteres implementieren.) Im Moment sieht es nach einem Kampf gegen Windmühlen aus. Sobald irgendwas geändert wird, knallt es an einer anderen Stelle, so ist zumindest gerade mein Eindruck, dass sollten wir erst mal in den Griff bekommen.


Ich bastel wenn ich kann mir mal eine Demo zusammen, mit der ich dann testen kann.

Ich denke das sollte jetzt erst mal reichen, was die Fehler angeht, ist wohl mehr als genug fürs erste.