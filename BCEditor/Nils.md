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
