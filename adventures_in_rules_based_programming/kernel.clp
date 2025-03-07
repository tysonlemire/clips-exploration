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
    (assert (command (text ?rsp))))

(defrule translate
   ?c <- (command (text $?text) (action))
   (test (not (member$ <thing> ?text)))
   (command_pattern (text $?text) (action $?action))
   =>
   (modify ?c (action ?action)))

(defrule translate_one_thing_match
   ?c <- (command (text $?before $?prefix ?id) (action))
   (command_pattern (text $?before <thing>) (action $?action))
   (thing (id adventurer)
          (location ?location))
   (thing (id ?id)
          (prefixes $? =(implode$ ?prefix) $?)
          (location ?location | adventurer)) 
   (not (command_pattern (text $?before $?prefix ?id)))
   =>
   (modify ?c (action ?action ?id)))

(defrule translate_one_thing_no_match
   (declare (salience -5))
   ?c <- (command (text $?before $?prefix ?id) (action))
   (command_pattern (text $?before <thing>))
   =>
   (retract ?c)
   (println "You can't see any such thing."))

(defrule unrecognized_word
    ?c <- (command (text $? ?word $?))
    (not (command_pattern
            (text $? ?word&~<thing> $?)))
    (not (thing (id ?word)
                (category scenery | item)))
    (not (and (thing (prefixes $? ?str $?)) 
                (test (member$ ?word (explode$ ?str)))))
    =>
    (retract ?c)
    (println "I don't know the word `" ?word "`."))

(defrule quit
    ?c <- (command (action quit))
    =>
    (retract ?c)
    (halt))

;; LOOK

(defrule print_place
    ?c <- (command (action look))
    (thing  (id adventurer)
            (location ?location))
    (thing  (id ?location)
            (category place)
            (definite ?definite)
            (description $?text))
    =>
    (retract ?c)
    (println "You're at " ?definite ".")
    (foreach ?line ?text
        (println ?line))
    (do-for-all-facts ((?t thing))
        (and    (eq ?t:location ?location)
                (eq ?t:category item))
        (println "You can see " ?t:indefinite ".")))

(defrule list-things
    (list-things ?location)
    (thing  (location location)
            (category item)
            (indefinite ?text))
    =>
    (println "You see " ?text "."))

(defrule done-list-things  
    (declare (salience -5))
    ?lt <- (list-things $?)
    =>
    (retract ?lt))

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
   ?p <- (thing (id adventurer)
                (location ?location))
    (or ?c <- (command (action go ?direction))
        ?c <- (command (action ?direction)))
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

;; Search

(defrule search_nothing_found
    (declare (salience -5))
    ?c <- (command (action search ?id))
    =>
    (retract ?c)
    (println "You find nothing of interest."))
   

(defrule search_rubble
    ?c <- (command (action search rubble))
    (thing (id adventurer)
            (location ?location))
    ?g <- (thing (id goblin)
            (location rubble))
    =>
    (retract ?c)
    (modify ?g (location ?location))
    (println "You find a dead goblin.")
    (println "he probably fell from above."))

(defrule search_goblin
    ?c <- (command (action search goblin))
    (thing (id adventurer)
            (location ?location))
    ?b <- (thing (id beans)
            (location goblin))
    =>
    (retract ?c)
    (modify ?b (location ?location))
    (println "Some beans are in his pocket."))

;; manipulate things

(defrule take_valid_thing
    ?c <- (command (action take ?id))
    ?t <- (thing    (id ?id)
                    (attributes $? can_be_taken $?)
                    (location ?location)
                    (definite ?text))
    (thing (id adventurer) (location ?location))
    =>
    (retract ?c)
    (modify ?t (location adventurer))
    (println "You take " ?text "."))

(defrule take_invalid_thing
    ?c <- (command (action take ?id))
    ?t <- (thing    (id ?id)
                    (attributes $?attributes)
                    (location ?location)
                    (definite ?text))
    (test (not (member$ 
                    can_be_taken ?attributes)))
    (thing (id adventurer) (location ?location))
    =>
    (retract ?c)
    (println "You can't take " ?text "."))

(defrule take_carried_thing
    ?c <- (command (action take ?id))
    (thing  (id ?id)
            (location adventurer)
            (definite ?text))
    =>
    (retract ?c)
    (println "You already have " ?text "."))

(defrule drop_valid_thing
    ?c <- (command (action drop ?id))
    ?t <- (thing (id ?id)
                 (location adventurer)
                 (definite ?text))
    (thing (id adventurer) (location ?location))
    =>
    (retract ?c)
    (modify ?t (location ?location))
    (println "You drop " ?text "."))

(defrule drop_valid_thing
    ?c <- (command (action drop ?id))
    ?t <- (thing    (id ?id)
                    (location ~adventurer)
                    (definite ?text))
    =>
    (retract ?c)
    (println "You don't have" ?text "."))

(defrule inventory_empty
    ?c <- (command (action inventory))
    (not (thing (category item) (location adventurer)))
    =>
    (retract ?c)
    (println "You are not carrying anything."))

(defrule inventory_not_empty
    ?c <- (command (action inventory))
    (exists (thing (category item) (location adventurer)))
    =>
    (retract ?c)
    (println "You are carrying:")
    (do-for-all-facts ((?t thing))
        (and    (eq ?t:category item)
                (eq ?t:location adventurer))
        (println " " ?t:indefinite)))


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