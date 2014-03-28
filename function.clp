;; Functions


;; STEP 1: QUERY PREPROCESSING

;; STEP 2: TEXT-MATCHING AND SIMILARITY MEASUREMENT	
;; simple text matching
(defrule text-matching
	(question (event ?x))
	?movie <- (movie (movieName ?z) (similarity ?w))
	?keyword <- (keyword (word ?y) (movieName ?z) (number ?no) (check ?t&: (= ?t 0)))	
	=>
	(modify ?keyword (check 1)) ;; checked already
	(if (str-index ?y ?x)
		then	
		(modify ?movie (similarity (+ ?w ?no)))
	)
)

;; STEP 3: RETRIEVE RESULTS
;; get top result
(defrule get-result
	(not (keyword (check ?t&: (= ?t 0))))
	(movie (movieName ?name) (similarity ?sim))
	(not (movie (similarity ?other_sim&: (> ?other_sim ?sim ))))
	=>
	(assert (result (movieName ?name)))
)

;; print result
(defrule print-result
	(result (movieName ?name))
	=>
	(printout t "The movie you are looking for is: " ?name "." crlf)
)	

;; STEP 4: Further process to narrow down result's list


