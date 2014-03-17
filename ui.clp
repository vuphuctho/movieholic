;; User Interface Rules

;; Ask user for keywords for one event in movie
(defrule ask-event
	(not (result))
	=>
	(printout t "Welcome to Movieholic - an application for any holic of movie!" crlf)
	(printout t "First, we need some information to find your favorite movie" crlf)
	(printout t "Please enter an event in the movie (keywords only): ")
	(bind ?n (read))
	(if (= (str-compare ?n "y") 0)
		then (printout t "****************************************" crlf crlf)
			(reset)
			(run) 
	)
	(if (= (str-compare ?n "n") 0)
		then (halt)
	)
)