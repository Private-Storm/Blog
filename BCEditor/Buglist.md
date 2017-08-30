### Fehlerliste stand 30.08.2017 BCEditor

Was ich auf die schnelle bisher gefunden habe:

* **Editor Fenster**

Hier gibt es einen kleinen Bug beim zeichnen, wenn man das Application Fenster maximiert, bleibt ein kleiner grauer Block im Editorfenster zurück. Dieser verschwindet wenn man mit dem Cursor durch die Zeilen wandert.
      


![PaintBug](https://github.com/Private-Storm/Blog/blob/master/BCEditor/PaintBug.PNG)

Ich habe mir das nochmal angesehen, der Fehler tritt ebenfalls auf wenn VisualStyles aktiv sind, hauptsächlich, wenn der Editor die Horizontale Scrollbar zeichnen muss, siehe Screenshot 2, nicht falsch verstehen, den Fehler gibt es auch ohne VisualStyles nur sieht man es vermutlich nicht weil der Hintergrund der Scrollbar an der Position vermutlich ebenfalls grau ist!

![VisualStyles](https://github.com/Private-Storm/Blog/blob/master/BCEditor/VisualStyles.PNG)

Hier nochmal in groß mit aktivem Style, im Editor wo sich horizontale und vertikale Scrollbar treffen, kannst Du das graue Quadrat erkennen, ist der Style nicht aktiv, verschiebt sich das graue Quadrat teilweise auf den Editor selber wie im ersten Screenshot sichtbar, wenn man sein Fenster maximiert, es wandert quasi:

![ScrollbarBug](https://github.com/Private-Storm/Blog/blob/master/BCEditor/Unbenannt.PNG)


* **Font Change**

Ändere ich in der Color.json den Font von z.B. von Courier New auf Inconsolata, wird der letzte Buchstabe pro Wort abgeschnitten, kann man deutlich z.B. in der Uses Liste sehen.

Was der Editor gar nicht mag, ist folgendes:
dynamisches Wechseln der Color.json zur Laufzeit. Es funktioniert, wenn der Editor nicht den Fokus hat ohne Probleme. Setzt man aber wie in meinem Fall den Focus in den Editor und steht z.B. in Zeile 16 und man wechselt jetzt z.B. von Monokai auf Default, knallt es mit der Meldung:

Line 15 not visible.


![FontChange](https://github.com/Private-Storm/Blog/blob/master/BCEditor/FontChange.PNG)

* **Löschen einer Zeile**

Markiert man eine Zeile komplett und will diese danach löschen, kommt es zu einer Exception.

![Löschen](https://github.com/Private-Storm/Blog/blob/master/BCEditor/Loeschen.PNG)


* **Highlighting von Begin / End Blöcke**

Das ist etwas seltsam, man geht z.B. zum Ende einer Unit scrollt dann langsam nach oben, die Begin und Endblöcke werden hervorgehoben allerdings nicht nur die Zeile in der man steht sondern auch die Zeilen vorher siehe Screenshot.

![Tags](https://github.com/Private-Storm/Blog/blob/master/BCEditor/Tags.PNG)

* **Editieren**

Wenn man ein Datei editiert, in meinem Fall eine .Pas Datei, und man dabei das CompletionProposal nutzt, dann treten folgende Dinge auf:

Man schreibt p Ctrl+Space wählt procedure aus, anzeigt wird jetzt:

 pprocedure
 
Gut soweit kein Problem, hatte ich nur so nicht erwartet (ich dachte durch das erste P und dankt CTRL+Space springt das CompletionProposal quasi nach P wo Procedure zu finden wäre.) 

Wenn man aber nun abschließend das END schreiben will erscheint der Cursor an der falschen Position, sprich er liegt zwischen N und D und nicht am Ende des Wortes End.
Nach dem abschließendem Return, wird es wieder korrekt angezeigt.

* **Color.json**

Ich hab das jetzt auf die schnelle nicht finden können, aber wo setzt man denn für das CompletionProposal, die Schriftfarbe? Größe und Art ist ja vorhanden.