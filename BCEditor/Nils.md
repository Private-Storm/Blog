<h3>Fehlerliste stand 17.08.2017</h3>

* Designtime Property Color
Diese Eigenschaft wird zur Designtime vom Editor ignoriert und vermutlich nur noch durch die entsprechenden Color.Json Files gesetzt und vom Editor gelesen, wenn dem so ist, sollte man ggf. diese Eigenschaft komplett unsichtbar machen im OI.

* Font Size in den Color.jsons wird teilwese ignoriert
Soll heissen, der Editor verarbeitet diese einmalig beim ersten laden einer Color.json aber nicht beim switch auf eine andere während der Laufzeit.

Beispiel: Monokai.json Fontgröße auf 12, 12 ändern, Fontname auf bei mir Inconsolata geändert.
Beispielanwendung kompilieren, diese läd standartmässig die Default.json mit den Einstellungen 9, 8 als Größe sowie Courier New als Fontnamen. Wird korrekt verarbeitet vom Editor. Wenn man jetzt auf die geänderte Monokai.json umstellt bleibt die Fontgröße bei 9,8 sowie Courier New anstelle von 12,12 Inconsolata. Was hier noch ganz nett wäre wenn man die Font Style noch einstellen könnte, z.B. auf Bold = True

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

* Codefolding nicht mehr existent? Zumindest kann es im OI und auch meiner Meinung nach sonst nirgends aktiviert werden. Es wird auch im Editor keins angezeigt.

* LineNumbers
Diese werden nicht korrekt wiedergegeben. Meine CSS Datei enthält über 400 Zeilen, im Editor werden die Linenumbers bis 30 dargestellt nicht mehr. Der Text ist aber komplett vorhanden.

* Löschen und Einfügen von einem bestehenden Text im Editor
Dies führt zu:

Assertion fehlgeschlagen Zeile 6838 BcEditor.pas

* Editor leer Texteingabe
Editor auf Javascript highlighter stellen folgende Eingabe:

          $(function)() {

          }

Zwischen der geöffneten und geschlossenen geschweiften Klammer return drücken, ergibt:
ERangeError Meldung Line 1 is not visible Exception BCEditor.pas Zeile: 5357



> Folgender Vorschlag, implementiere mal nichts neues im Moment. Wenn Du Zeit hast versuche mal obiges nach und nach zu fixen. Ich kann Dir vorschlagen, mit Dir zusammen dann mal alles was bis jetzt enthalten ist (sämtliche Eigenschaften und die Colors sowie Highlighter.jsons komplett zu prüfen, ob wirklich unter allen Umständen alles auch verarbeitet wird so wie es soll. Wenn dem so ist erst dann würde ich weiteres implementieren.) Im Moment sieht es nach einem Kampf gegen Windmühlen aus. Sobald irgendwas geändert wird, knallt es an einer anderen Stelle, so ist zumindest gerade mein Eindruck, dass sollten wir erst mal in den Griff bekommen.

Ich bastel wenn ich kann mir mal eine Demo zusammen, mit der ich dann testen kann.
