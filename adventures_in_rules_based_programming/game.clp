;; Story

(defrule exposition
    (declare (salience 10))
    =>
    (println "Captured by goblins, you have")
    (println "been tossed in a pit in their lair.")
    (println))

(defrule pit_north
    (thing  (id adventurer)
            (location pit_north))
    =>
    (println "You're at the pit's north end.")
    (println "A giant mushroom is here. The")
    (println "ground is littered with the")
    (println "bodies of dead adventurers."))

(defrule pit_south
    (thing  (id adventurer)
            (location pit_south))
    =>
    (println "You're at the pit's south end.")
    (println "A large pile of rubble has")
    (println "collapsed from the wall above."))

(defrule no_escape
    (thing  (id adventurer)
            (location pit_north | pit_south))
    ?c <- (command (action climb | go up))
    =>
    (retract ?c)
    (println "The walls are too slick."))

(defrule south_from_pit_north
    ?p <- (thing (id adventurer)
                 (location pit_north))
    ?c <- (command (action go south))
    =>
    (retract ?c)
    (modify ?p (location pit_south)))

(defrule north_from_pit_south
    ?p <- (thing (id adventurer)
                 (location pit_south))
    ?c <- (command (action go north))
    =>
    (retract ?c)
    (modify ?p (location pit_north)))

(defrule bad_go_from_pit_north
    (thing  (id adventurer)
            (location pit_north))
    ?c <- (command (action go ~south&~up))
    =>
    (retract ?c)
    (println "You can't go there."))

(defrule bad_go_from_pit_south
    (thing  (id adventurer)
            (location pit_south))
    ?c <- (command (action go ~north&~up))
    =>
    (retract ?c)
    (println "You can't go there."))

(defrule climb_mushroom
   (thing   (id adventurer)
            (location pit_north))
    ?c <- (command (action climb mushroom))
    =>
    (retract ?c)
    (println "The mushroom is not sturdy enough to climb."))

(defrule search_rubble_wand
    (thing  (id adventurer)
            (location pit_south))
    ?w <- (thing  (id wand)
            (location rubble))
    ?c <- (command (action search rubble))
    =>
    (retract ?c)
    (modify ?w (location adventurer))
    (println "You find a wand."))

(defrule search_rubble_empty
    (thing  (id adventurer)
            (location pit_south))
    ?w <- (thing  (id wand)
            (location adventurer))
    ?c <- (command (action search rubble))
    =>
    (retract ?c)
    (println "You find nothing of interest."))

;; Wand stuff

(defrule place_wand
    =>
    (assert (thing (id wand) (location rubble))))

(defrule use_wand
    (thing  (id adventurer))
    (thing  (id wand) (location adventurer))
    ?c <- (command (action say abracadabra))
    =>
    (retract ?c)
    (println "You are teleported out of the pit!"))

(defrule look_mushroom
    ?c <- (command (action look at mushroom))
    (thing  (id adventurer)
            (location pit_north))
    =>
    (retract ?c)
    (println "It looks squished. I wouldn't")
    (println "try landing on it again."))

(defrule look_bodies
    ?c <- (command (action look at bodies))
    (thing  (id adventurer)
            (location pit_north))
    =>
    (retract ?c)
    (println "Apparently this is what happens")
    (println "when you miss the mushroom."))

(defrule look_at_default
    (declare (salience -5))
    ?c <- (command (action look at ?))
    =>
    (retract ?c)
    (println "You don't see anything special"))

;; Parse the users input
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