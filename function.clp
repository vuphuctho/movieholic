;; Functions

;; Rule: text matching
;; Premise: if there exists query, find an unchecked keyword (check = 0)
;; and its corresponding movie
;; Action: 1) Match keyword as checked (check = 1)
;; 		   2) If keyword appears in query, modify similarity value of movie
;; Note: modifying rule: term correlation

(defrule text-matching
	(question (event ?x))
	?movie <- (movie (movieName ?z) (similarity ?w))
	?keyword <- (keyword (word ?y) (movieName ?z) (number ?no) (check ?t&: (= ?t 0)))	
	=>
	;; Match keyword as checked 
	(modify ?keyword (check 1))

	;; If find keyword in query
	;; modify similarity value of movie having this keyword
	(if (str-index ?y ?x)
		then	
		(modify ?movie (similarity (+ ?w ?no)))
	)
)

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