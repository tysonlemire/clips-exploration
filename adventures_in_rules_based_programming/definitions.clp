(deftemplate thing
   (slot id)
   (slot category
      (allowed-values place item actor scenery))
   (slot location 
      (default nowhere))
   (multislot description))

(deftemplate command
   (multislot action))

(deftemplate path
  (multislot direction)
  (multislot from)
  (slot symmetric (default FALSE))
  (slot to (default nowhere))
  (slot blocked (default FALSE))
  (slot blocked_message (default "The way is blocked.")))

(deftemplate counter
    (multislot id)
    (slot count (default 1)))
