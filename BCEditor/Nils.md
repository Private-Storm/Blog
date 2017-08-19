<h3>Fehlerliste stand 17.08.2017</h3>

* Designtime Property Color
Diese Eigenschaft wird zur Designtime vom Editor ignoriert und vermutlich nur noch durch die entsprechenden Color.Json Files gesetzt und vom Editor gelesen, wenn dem so ist, sollte man ggf. diese Eigenschaft komplett unsichtbar machen im OI.

* Font Size in den Color.jsons wird teilwese ignoriert
Soll heissen, der Editor verarbeitet diese einmalig beim ersten laden einer Color.json aber nicht beim switch auf eine andere während der Laufzeit.

Beispiel: Monokai.json Fontgröße auf 12, 12 ändern, Fontname auf bei mir Inconsolata geändert.
Beispielanwendung kompilieren, diese läd standartmässig die Default.json mit den Einstellungen 9, 8 als Größe sowie Courier New als Fontnamen. Wird korrekt verarbeitet vom Editor. Wenn man jetzt auf die geänderte Monokai.json umstellt bleibt die Fontgröße bei 9,8 sowie Courier New anstelle von 12,12 Inconsolata. Was hier noch ganz nett wäre wenn man die Font Style noch einstellen könnte, z.B. auf Bold = True

Dazu gibt es noch zwei weitere Probleme:
Wenn man die Fontgröße in der Jason auf über 12 stellt wird im Editor die LeftMargin falsch gezeichnet es entstehen komische dunkle Blöcke.

Das nächste Problem ist, wie soll man, wenn man die Fontgröße in der Json definiert hat zur Laufzeit die Editor Fontgröße setzen? Denn:

    Editor.Font.Size := Value
    
Hat keinen Einfluss darauf bzw. wird dies ignoriert oder vom Editor nicht verarbeitet.
Es hat den Anschein, dass die Einstellungen nur über die Json funktioniert aber die Einstellungen die man z.B. im Object Inspector macht ignoriert oder überschrieben werrden.
Sollte eigentlich nicht sein oder?

Hier mal ein Screenshot der zeigt, was passiert wenn man die Schriftgröße (hier mal 12px) einstellt, man beachte die schwarzen Streifen am linken Rand des Editors die sich bis unten hin durchziehen, je größer die Schriftgröße je größer die schwarzen Blöcke.

![FehlerRand](https://github.com/Private-Storm/Blog/blob/master/BCEditor/LeftMargin.png)

* CompletionProposal
Diese scheint komplett im Eimer zu sein im Moment. Wenn man STRG+Space betätitigt ergibt das:
EAsertionFailed BCEditor.pas Zeile 6838  Assert(not (ecProcessingCommand in FState))
Diese auf Enabled = False zu stellen, hilft auch nicht weiter die Exception wird auf jeden Fall geworfen.

Ich habe aber zugegeben auch nicht zu ganz verstanden, wie das ganze funktioniert, da ich dachte man kann irgendwo auch ein Code Template eingeben, was aber in der jetzigen Version zumindest für mich nicht auffindbar war, wo dies geschehen soll.

* Editor Lines Eigenschaft Objekt Inspector
Diese Eigenschaft scheint komplett verschwunden zu sein, jedenfalls kann ich die nicht mehr finden.
Ändert aber auch nichts daran folgenden Fehler zu finden:

            Editor.Lines.LoadFromFile('normalize.css');

Dies ergibt dann folgendes:

Exception ERangeError Line 446 is not visible TCustomBCEditor.LinesToRows.....
Zeile 5357

Der Fehler tritt auf, wenn man den Highlighter z.B. auf Delphi stehen hat, man aber eine CSS Datei lädt. Das sollte nicht passieren. Eventuell müsste man hier prüfen zwischen Dateiendung und ausgewähltem Parser, wenn der Parser hier das Problem ist. Eventuell kann man den Text dann ungeparsed lassen, bis der richtige Parser ausgewählt wurde vom Benutzer.

Bei Sublime Text ist das folgendermassen, wenn ich eine neue Datei im Editor erstelle ist die erstmal komplett ohne Highlighting, wenn ich die Datei speichere z.B. als Neu.CSS dann wird die Datei sofort danach im Editor mit dem CSS Highlighter geparsed. Oder ich kann auch den Highlighter manuell setzen, wobei es hier egal ist welchen ich wähle, sollte er nicht passen wird eben kein highlighting angewand oder nur partiell für die Bereiche wo es zufällig passen würde. Ist mir aber selber ein Rätsel wie das gelöst wurde.

Das ganze geht noch weiter wenn zuvor im Objekt Inspector WordWrap auf True gesetzt wurde passiert folgendes:

Access violation 0x000000000

* CodeFolding, klick mal bitte mehrfach auf die Plus / Minus Symbole also Code ein und ausklappen.
Irgendwann ist der Code nicht mehr vorhanden also unsichtbar, der wird aber dann auch nicht mehr sichtbar, egal ob man aus oder einklappt.

* Line Numbers
Diese werden nicht korrekt wiedergegeben. Meine CSS Datei enthält über 400 Zeilen, im Editor werden die Linenumbers bis 30 dargestellt nicht mehr. Der Text ist aber komplett vorhanden.

* Löschen und Einfügen von einem bestehenden Text im Editor
Dies führt zu:

Assertion fehlgeschlagen Zeile 6838 BcEditor.pas

* Editor leer es erfolgt eine Texteingabe wie im nachfolgendem Beispiel:
Editor auf Javascript Highlighter stellen folgende Eingabe:

          $(function)() {

          }

Zwischen der geöffneten und geschlossenen geschweiften Klammer return drücken, ergibt:
ERangeError Meldung Line 1 is not visible Exception BCEditor.pas Zeile: 5357

Hab das gerade nochmal getestet, der Editor hat weiterhin den Bug, bei der Eingabe, wenn man an bestimmten Stellen return drückt knallt es.

* Dann gibt es noch einen Bug was das Scrolling des Editors betrifft:

                editor.Lines.Add('');
                editor.Lines.Add('(function($) {');
                editor.Lines.Add('');
                editor.Lines.Add('       // skeleton breakpoints. ');
                editor.Lines.Add('');
                editor.Lines.Add('       skel.breakpoints({');
                editor.Lines.Add('           xLarge: ''' + '(max-width: 1680px)'  + ''',');
                editor.Lines.Add('           Large: '''  + '(max-width: 1280px)'  + ''',');
                editor.Lines.Add('           Medium: ''' + '(max-width: 980px)'   + ''',');
                editor.Lines.Add('           Small: '''  + '(max-width: 736px)'   + ''',');
                editor.Lines.Add('           xSmall: ''' + '(max-width: 480px)'   + '''');
                editor.Lines.Add('        });');
                editor.Lines.Add('');
                editor.Lines.Add('        $(function() {');
                editor.Lines.Add('');
                editor.Lines.Add('');
                editor.Lines.Add('               var $Windows = $(window),');
                editor.Lines.Add('                   $body = $(''body''),');
                editor.Lines.Add('                   $sidebar = $(''#sidebar'')');
                editor.Lines.Add('');
                editor.Lines.Add('');
                editor.Lines.Add('       // Hack: Enable IE flexbox workaround.');
                editor.Lines.Add('');
                editor.Lines.Add('       if (skel.vars.IEVersion < 12)');

Mit obigen Zeilen habe ich den Editor gefüllt, wenn man jetzt kompiliert, springt der Editor zur letzten Zeile sprich // Hack: Enabled .... usw. wird angezeigt, der obere Teile ist aus dem sichtbaren Bereich verschwunden, die vertikale Scrollbar steht aber ganz oben.

Teilweise erscheinen im Editor auch chinesichse Zeichen, ist mir zwei mal passiert jetzt, ich versuche das mal zu provozieren um zu ermitteln was das genau auftritt. (Ansi / Unicode Problem?)

Screenshot


![Scrollbar_Bug](https://github.com/Private-Storm/Blog/blob/master/BCEditor/Scrollbar_Bug.PNG)


Screenshot Line Numbers

Was da genau passiert weiß ich nicht nur zu lesen, sind diese echt schwer.
Anhand des Screenshots kannst Du aber erkennen, Codefolding ist nicht.
Woher kommt eigentlich diese Orange Linie da, im LeftMargin oder anders wie heisst die Definition in der Colors.JSon?


![Line_Number_Bug](https://github.com/Private-Storm/Blog/blob/master/BCEditor/Editor_LinesNr_Bug.PNG)

Jetzt hab ich abschliessend noch eine Frage, ich hänge noch einen Sceenshot an was die Flexibilität anderer Editoren betrifft, was speziel den Highlighter betrifft.
Ich habe ehrlich gesagt, dass noch nicht ganz begriffen wie das Funktioniert oder anders, wie man den Highlighter und speziel dazu die Farben erweitern kann oder geht das überhaupt?

Sagen wir mal so wie im zweiten Screenshot z.B. Skel.Breakpoints da hat Skel eine andere Farbe wie folgendes:

          Skel.vars.IEVersion

sprich Skel kann zwei verschiedene Farbwerte annehmen... So etwas gibt es auch bei den Editoren die ich so benutze deshalb auch die Frage, weil so wie ich das sehe geht es so mit deinem Editor nicht?!

![Ziel](https://github.com/Private-Storm/Blog/blob/master/BCEditor/Ziel.png)

> Folgender Vorschlag, implementiere mal nichts neues im Moment. Wenn Du Zeit hast versuche mal obiges nach und nach zu fixen. Ich kann Dir vorschlagen, mit Dir zusammen dann mal alles was bis jetzt enthalten ist (sämtliche Eigenschaften und die Colors sowie Highlighter.jsons komplett zu prüfen, ob wirklich unter allen Umständen alles auch verarbeitet wird so wie es soll. Wenn dem so ist erst dann würde ich weiteres implementieren.) Im Moment sieht es nach einem Kampf gegen Windmühlen aus. Sobald irgendwas geändert wird, knallt es an einer anderen Stelle, so ist zumindest gerade mein Eindruck, dass sollten wir erst mal in den Griff bekommen.

Ich bastel wenn ich kann mir mal eine Demo zusammen, mit der ich dann testen kann.

Ich denke das sollte jetzt erst mal reichen, was die Fehler angeht, ist wohl mehr als genug fürs erste.
