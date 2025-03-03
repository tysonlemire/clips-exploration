(deftemplate thing
   (slot id)
   (slot category
      (allowed-values place item actor scenery))
   (slot location 
      (default nowhere))
   (multislot description)
   (multislot prefixes (default "")))

(deftemplate command 
   (multislot text)
   (multislot action))

(deftemplate command_pattern
   (multislot text)
   (multislot action))

(deftemplate path
  (multislot direction)
  (multislot from)
  (slot to (default nowhere))
  (slot blocked (default FALSE))
  (slot blocked_message (default "The way is blocked.")))

(deftemplate counter
    (multislot id)
    (slot count (default 1)))
