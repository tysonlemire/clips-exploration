(deftemplate thing
    (slot id)
    (slot category)
    (slot location))

(deftemplate command
    (multislot action))

(deftemplate counter
    (multislot id)
    (slot count))