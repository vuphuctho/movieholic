;; Functions

;; simple text matching
(defrule text-matching
	(question (event ?x))
	?movie <- (movie (movieName ?z) (similarity ?w))
	?keyword <- (keyword (word ?y) (movieName ?z) (number ?no) (check ?t&: (= ?t 0)))	
	=>
	;;(modify (?movie (similarity ?w + ?no)))
	(modify ?keyword (check 1))
	(if (str-index ?y ?x)
		then	
		(modify ?movie (similarity (+ ?w ?no)))
	)
)

;; SEMI-DONE: To return results as a list
;; get top result
(defrule get-result
	(not (keyword (check ?t&: (= ?t 0))))
	(movie (movieName ?name) (similarity ?sim))
	(not (movie (similarity ?other_sim&: (> ?other_sim ?sim ))))
	=>
	(assert (result (movieName ?name "otherResults" )))
)


;; TODO: Remove this and put a corresponding title in UI
;; print result
(defrule print-result
	(result (movieName ?firstMovie $?))
	=>
	(printout t "The movie you are looking for is: " ?firstMovie "." crlf)
)	