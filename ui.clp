;; User Interface Rules

;; Ask user for keywords for one event in movie
(defrule ask-event
	;;(not (result))
	(phase (event firstQuestion))
	=>
	(printout t "Welcome to Movieholic - an application for any holic of movie!" crlf)
	(printout t "First, we need some information to find your favorite movie" crlf)
	(printout t "Please enter an event in the movie (keywords only): ")
	(bind ?n (readline))
	(if (= (str-length ?n) 0)
		then 
			(printout t "Sorry, we need some information to start processing ***" crlf crlf)
			(run) 
	)
	(if (> (str-length ?n) 0)
		then 
			(assert (question (event ?n)))
	)
)


;;TODO John to add interaction with user. 
;;TODO 2: add a chart
;; Ask-event
;; is-result-correct?
;;  (yes) try again?        (no) ask from list
;;                          (yes) exit       (no) ask for keywords
;;                                           (yes)ok  (no) sorry!