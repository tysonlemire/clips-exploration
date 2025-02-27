(defrule bad_command
    (declare (salience -20))
    ?c <- (command)
    =>
    (println "I don't understand your command.")
    (retract ?c))

(defrule get_command
    (declare (salience -10))
    (not (command))
    =>
    (println)
    (print "> ")
    (bind ?rsp (explode$ (lowcase (readline))))
    (assert (command (action ?rsp))))

(defrule quit
    ?c <- (command (action quit))
    =>
    (retract ?c)
    (halt))

(defrule return_command
    (declare (salience -5))
    ?c <- (command (action))
    =>
    (retract ?c)
    (println "You can't return to the")
    (println "safety of your home that easily."))

;; LOOK

(defrule print_place
    ?c <- (command (action look))
    (thing  (id adventurer)
            (location ?location))
    (thing  (id ?location)
            (category place)
            (description $?text))
    =>
    (retract ?c)
    (foreach ?line ?text
        (println ?line)))

(defrule look_no_description
    ?c <- (command (action look at ?id))
    (thing  (id adventurer) (location ?location))
    (thing  (id ?id)
            (category scenery)
            (location ?location | adventurer)
            (description))
    =>
    (retract ?c)
    (println "You see nothing special."))

(defrule look_description
    ?c <- (command (action look at ?id))
    (thing  (id adventurer) (location ?location))
    (thing  (id ?id)
            (category scenery)
            (location ?location | adventurer)
            (description $?text))
    (test (> (length$ ?text) 0))
    =>
    (retract ?c)
    (foreach ?line ?text
        (println ?line)))

(defrule look_cant_see
    ?c <- (command (action look at ?id))
    (thing  (id adventurer) (location ?location))
    (not (thing  (id ?id)
            (location ?location | adventurer)))
    =>
    (retract ?c)
    (println "You can't see any such thing."))
    
;; MOVEMENT

(defrule go_valid_path
   ?c <- (command (action go ?direction))
   ?p <- (thing (id adventurer)
                (location ?location))
   (path (direction $? ?direction $?)
         (from $? ?location $?)
         (to ?new_location)
         (blocked FALSE))
   =>
   (retract ?c)
   (modify ?p (location ?new_location))
   (assert (command (action look))))

(defrule go_invalid_path
    ?c <- (command (action go ?direction))
    ?p <- (thing  (id adventurer) (location ?location))
    (not (path  (direction $? ?direction $?) 
                (from $? ?location $?)))
    =>
    (retract ?c)
    (println "You can't go there"))

(defrule go_valid_path_blocked
    ?c <- (command (action go ?direction))
    ?p <- (thing  (id adventurer) (location ?location))
    (path   (direction $? ?direction $?)
            (from $? ?location $?)
            (to ?new_location)
            (blocked TRUE)
            (blocked_message ?text))
    =>
    (retract ?c)
    (println ?text))

(defrule bad_direction
   (declare (salience 5))
    ?c <- (command (action go ?dir&~north&~south&~east
                                 &~west&~up&~down))
    =>
    (retract ?c)
    (println "I don't understand the direction '" ?dir "'."))

(defrule climb_action
    ?c <- (command (action climb up))
    =>
    (modify ?c (action go up)))

(defrule climb_mushroom
   (thing   (id adventurer)
            (location pit_north))
    ?c <- (command (action climb mushroom))
    =>
    (retract ?c)
    (println "The mushroom is not sturdy enough to climb."))

;; Rubble

(defrule search_rubble_path_found
   (thing (id adventurer) (location pit_south))
   ?l <- (thing (id pit_south)
                (description $?description))
   (not (path (from pit_south) (to cavern)))
   ?c <- (command (action search rubble))
   =>
   (println "From the top of the rubble, you can see")
   (println "that the ground has collapsed creating")
   (println "a path down to a cavern below.")
   (modify ?l (description $?description 
                           "A path through the rubble leads down"))
   (assert (path (direction down)
                 (from pit_south)
                 (to cavern))
           (path (direction up)
                 (from cavern)
                 (to pit_south)))
   (retract ?c))

(defrule escape
   (thing (id adventurer) (location cavern))
   ?c <- (command (action make wish))
   =>
   (retract ?c)
   (println "Your wish is granted. You've been")
   (println "magically transported to safety.")
   (halt))

(defrule search_rubble_empty
    (thing  (id adventurer)
            (location pit_south))
    ?w <- (thing  (id wand)
            (location adventurer))
    ?c <- (command (action search rubble))
    =>
    (retract ?c)
    (println "You find nothing of interest."))

;; Eating Mushroom
(defrule eat_mushroom_1 "Problem #2"
    ?c <- (command (action eat mushroom))
    (thing (id adventurer)
            (location pit_north))
    (not (counter (id eat mushroom)))
    =>
    (retract ?c)
    (assert (counter (id eat mushroom) (count 1)))
    (println "You probably shouldn't do that.")
    (println "It might be poisonous."))

(defrule eat_mushroom_2 "Problem #2"
    ?c <- (command (action eat mushroom))
    (thing (id adventurer)
            (location pit_north))
    ?cnt <- (counter (id eat mushroom) (count 1))
    =>
    (retract ?c)
    (modify ?cnt (count 2))
    (println "Seriously? You have no idea what could happen!"))

(defrule eat_mushroom_3 "Problem #2"
    ?c <- (command (action eat mushroom))
    (thing (id adventurer)
            (location pit_north))
    (counter (id eat mushroom) (count 2))
    =>
    (retract ?c)
    (println "OK, you pull off a small piece and eat it. Your")
    (println "head spins and then your body feels light. With")
    (println "a mighty spring you leap out of the pit.")
    (halt))


(defrule can't_eat "Problem #3"
   (declare (salience -5))
   ?c <- (command (action eat ?))
   =>
   (retract ?c)
   (println "Think about escape, not lunch."))