;; User Interface Rules

;; Ask user for keywords for one event in movie
(defrule UIwelcome
	;;(not (result))
	?phase <- (phase (event UI_Welcome))
	=>
	(printout t "Welcome to Movieholic - an application for any holic of movie!" crlf)
	(printout t "First, we need some information to find your favorite movie" crlf)
	(printout t "Please enter an event in the movie (keywords only): ")
	(bind ?n (readline))
	(if (= (str-length ?n) 0)
		then 
			(printout t "Sorry, we need some information to start processing ***" crlf crlf)
			(reset)
			(run) 
	)
	(if (> (str-length ?n) 0)
		then 
			(assert (question (event ?n)))
			(modify ?phase (event UI_TopResult))
	)
)

;; TODO handle empty list IF an empty result is asserted
(defrule UItopResult
	?phase <- (phase (event UI_TopResult))
	?result <- (result (movieName $?x&: (> (length $?x ) 0)))
	=>
	(facts)
	(printout t "Is the movie you are looking for " (nth$ 1 $?x) crlf)
	(printout t "1. Yes 2. No" crlf)
	(bind ?n (read))
	(if (= ?n 1) then
		(printout t "I'm glad we were able to help." crlf)
		(reset)
		(run)
	else
		(printout t "Hold on while we search for other results..." crlf)
		(modify ?phase (event UI_OtherResults))
		(modify ?result (movieName (rest$ $?x)))
	)
)

(defrule UIotherResults
	?phase <- (phase (event UI_OtherResults))
	?result <- (result (movieName $?x))
	=>
	(if (= 0 (length$ $?x)) then
		(printout t "Looks like we couldn't find more results with the current keywords." crlf)
		(modify ?phase (event UI_MoreKeywords))
	else
		(printout t "Is your movies one of these?" $?x crlf)
		(printout t "1. yes 2. no" crlf)
		(bind ?n (read))
		(if (= ?n 1) then
			(printout t "Great to know we could help!" crlf)
			(reset)
			(run)
		else
			(modify ?phase (event UI_MoreKeywords))
		)
	)
)

(defrule UImoreKeywords
	?phase <- (phase (event UI_MoreKeywords))
	?question <- (question (event ?originalQuery))
	=>
	(printout t "Could we please get more keywords from you?" crlf)
	(printout t "(Press enter without anything to exit.)" crlf)
	(bind ?newQuery (readline))
	(if (= (str-length ?newQuery) 0) then 
		(printout t "Apologies, we were not able to find your movie ***" crlf crlf)
		(reset)
		(run) 
	)
	(if (> (str-length ?newQuery) 0) then 
		(modify ?question (event (str-cat ?newQuery(str-cat " " ?originalQuery))))
		;; this cant work since all keywords are checked
	)
)


;; Written to move phase back to getTopResult once resetKeyword and resetMovie have been run
(defrule UIrecievedKeywords
	?phase <- (phase (event UI_MoreKeywords))
	(not (movie (similarity 0)))
	(not (keywords (check 0)))
	=>
	(modify ?phase (event UI_TopResult))
)


;;(batch "movieholic/main.bat")

;;TODO John to add interaction with user. 
;;TODO 2: add a chart
;; Ask-event
;; is-result-correct?
;;  (yes) try again?        (no) ask from list
;;                          (yes) exit       (no) ask for keywords
;;                                           (yes)ok  (no) sorry!
