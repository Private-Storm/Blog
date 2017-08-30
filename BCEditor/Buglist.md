### Fehlerliste stand 30.08.2017 BCEditor

Was ich auf die schnelle bisher gefunden habe:

* **Editor Fentster**

Hier gibt es einen kleinen Bug beim zeichnen, wenn man das Application Fenster maximiert, bleibt ein kleiner grauer Block im Editorfenster zurück. Dieser verschwindet wenn man mit dem Cursor durch die Zeilen wandert.
      


![PaintBug](https://github.com/Private-Storm/Blog/blob/master/BCEditor/PaintBug)


* **Font Change**

Ändere ich in der Color.json den Font von z.B. von Courier New auf Inconsolata, wird der letzte Buchstabe pro Wort abgeschnitten, kann man deutlich z.B. in der Uses Liste sehen.

![FontChange](https://github.com/Private-Storm/Blog/blob/master/FontChange.PNG)

* **Löschen einer Zeile**

Markiert man eine Zeile komplett und will diese danach löschen, kommt es zu einer Exception.

![Löschen](https://github.com/Private-Storm/Blog/blob/master/Loeschen.PNG)


* **Highlighting von Begin / End Blöcke**

Das ist etwas seltsam, man geht z.B. zum Ende einer Unit scrollt dann langsam nach oben, die Begin und Endblöcke werden hervorgehoben allerdings nicht nur die Zeile in der man steht sondern auch die Zeilen vorher siehe Screenshot.

![Tags](https://github.com/Private-Storm/Blog/blob/master/Tags.PNG)