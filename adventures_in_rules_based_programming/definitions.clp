(deftemplate thing
    (slot id)
    (slot category)
    (slot location))

(deftemplate command
    (multislot action)
    (slot count))

(deftemplate command_counter
    (multislot action)
    (slot count))