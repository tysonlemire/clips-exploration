;; ADVENTURE

(defrule exposition
    (declare (salience 10))
    =>
    (println "Captured by goblins, you have")
    (println "been tossed in a pit in their lair.")
    (println))

;; FACTS

(deffacts player
    (thing  (id adventurer)
            (category actor)
            (location pit_north)))

(deffacts places
    (thing  (id pit_north)
            (category place)
            (description 
                "You're at the pit's north end."
                "A giant mushroom is here. The"
                "ground is littered with the"
                "bodies of dead adventurers."))

    (thing  (id pit_south)
            (category place)
            (description 
                "You're at the pit's south end."
                "A large pile of rubble has"
                "collapsed from the wall above."
            ))
            
    (thing  (id cavern)
            (category place)
            (description 
                "You are in a cavern lit by glowing algae with a"
                "well in the center. A path made of rubble lease up. ")))

(deffacts scenery
    (thing  (id mushroom)
            (location pit_north)
            (category scenery)
            (prefixes "" "the" "giant" "the giant")
            (description 
                "It looks squished. I wouldn't"
                "try landing on it again."))

    (thing  (id bodies)
            (location pit_north)
            (category scenery)
            (prefixes "" "the")
            (description 
                "Apparently this is what happens"
                "when you miss the mushroom."))

    (thing  (id rubble)
            (location pit_south)
            (category scenery)
            (prefixes "" "the" "pile of" "the pile of" "large pile of" "the large pile of"))
            
    (thing  (id well)
            (location cavern)
            (category scenery)
            (description
                "This is no ordinary well")))

(deffacts paths
    (path   (direction south)
            (from pit_north)
            (to pit_south))

    (path   (direction north)
            (from pit_south)
            (to pit_north))
            
    (path   (direction up)
            (from pit_north pit_south)
            (blocked TRUE)
            (blocked_message 
                "The walls are too slick.")))

(deffacts items
    (thing  (id wand) 
            (location rubble)))

(deffacts command_pattern_core
        (command_pattern (text quit)
                         (action quit)))

(deffacts command_pattern_go
        (command_pattern (text south) (action go south))
        (command_pattern (text go south) (action go south))
        (command_pattern (text north) (action go north))
        (command_pattern (text go north) (action go north))
        (command_pattern (text east) (action go east))
        (command_pattern (text go east) (action go east))
        (command_pattern (text west) (action go west))
        (command_pattern (text go west) (action go west))
        (command_pattern (text up) (action go up))
        (command_pattern (text go up) (action go up))
        (command_pattern (text climb up) (action go up))
        (command_pattern (text down) (action go down))
        (command_pattern (text go down) (action go down))
        (command_pattern (text climb down) (action go down))
)

(deffacts command_pattern_look
        (command_pattern (text look around) (action look))
        (command_pattern (text look) (action look))
        (command_pattern (text look at <thing>) (action look at))
        (command_pattern (text examine <thing>) (action look at))
)