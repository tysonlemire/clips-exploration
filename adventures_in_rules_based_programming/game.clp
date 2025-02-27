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
            (description 
                "It looks squished. I wouldn't"
                "try landing on it again."))

    (thing  (id bodies)
            (location pit_north)
            (category scenery)
            (description 
                "Apparently this is what happens"
                "when you miss the mushroom."))

    (thing  (id rubble)
            (location pit_south)
            (category scenery))
            
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