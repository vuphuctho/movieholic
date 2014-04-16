;; Functions

;; STEP 1: KEYWORDS PROCESSING
(defrule remove-stopword
	(not (question))
	?keyword <- (keyword (word ?x))
	(stopword (word ?y&: (= (str-compare (lowcase ?x) (lowcase ?y)) 0)))
	=>
	(retract ?keyword)
)


;; STEP 2: TEXT-MATCHING AND SIMILARITY MEASUREMENT	

;; Rule: text matching
;; Premise:
;;		1) Query exists
;;		2) Unchecked keyword (check = 0) exists
;; Action: 
;;		1) Match keyword as checked (check = 1)
;; 		2) If keyword appears in query, modify similarity value of movie
;; Note: modifying rule: term correlation
(defrule text-matching
	(phase (event UI_TopResult))
	(question (event ?x))
	?movie <- (movie (movieName ?z) (similarity ?w))
	?keyword <- (keyword (word ?y) (movieName ?z) (number ?no) (check ?t&: (= ?t 0)))	
	=>
	;; Match keyword as checked 
	(modify ?keyword (check 1))

	;; If find keyword in query
	;; modify similarity value of movie having this keyword
	(if (str-index (lowcase ?y) (lowcase ?x))
		then	
		(printout t "Find keyword " ?y " in movie " ?x crlf)
		(modify ?movie (similarity (+ ?w ?no)))
	)
)

;; STEP 3: RETRIEVE RESULTS
;; get top 10 results with similarity > 0
;; Premise:
;;		1) Result's size < 10
;;		2) All keywords are checked (check = 1)
;;		3) Movie with highest similarity and is not in result (inResult = 0) exists
;; Action:
;;		If movie's similarity > 0
;;			Add the movie to result, update movie (inResult=1), update result's size
;;		Else
;;			Only update result's size
(defrule get-result
		?result <- (result (movieName $?names) (loop ?l&: (< ?l 10)))
		(not (keyword (check 0)))
		?movie <- (movie (movieName ?name) (inResult 0) (similarity ?sim))
		(not (movie (inResult 0) (similarity ?other_sim&: (> ?other_sim ?sim ))))
		=>
		(if (> ?sim 0)
			then
			(modify ?movie (inResult 1))
			(printout t "add movie " ?name " with " ?sim crlf)
			(if (= (length$ $?names) 0)
				then 	
				(assert (result (movieName ?name) (loop (+ ?l 1))))				
				else 
				(assert (result (movieName $?name ?name) (loop (+ ?l 1))))
			)
			else 
			(modify ?result (loop (+ ?l 1))) 
		)
)


;; Reset data

;; Reset keywords
;; Premise:
;;		1) Phase: UI_MoreKeywords
;;		2) Checked keyword (check = 1) exists
;; Action:
;;		Reset keyword (check = 0)
(defrule reset-keyword
	;; keep high salience
	(declare (salience 20))
	(phase (event UI_MoreKeywords))
	?keyword <- (keyword (check 1))
	=>
	(modify ?keyword (check 0))
)

;; Reset movies in result
;; Premise:
;;		1) Phase: UI_MoreKeywords
;;		2) Movie in result (inResult = 1) exists
;; Action:
;;		1) Reset movie (inResult = 0)
;; 		2) Set this movie to low priority (similarity = -100)
(defrule reset-movie
	;; keep high salience
	(declare (salience 20))
	(phase (event UI_MoreKeywords))
	?movie <- (movie (inResult 1) (similarity ?y))
	=>
	;; make this movie in low priority 
	;; since it is not what user want to find
	(modify ?movie (inResult 0) (similarity -100)) 	
)

;; Reset result
;; Premise:
;;		1) Phase: UI_MoreKeywords
;;		2) Result's size = 10 (loop = 10)
;; Action:
;;		Reset result's list of movies and its size
(defrule reset-result
	;; keep high salience
	(declare (salience 20))
	(phase (event UI_MoreKeywords))
	?result <- (result (loop 10))
	=>
	;; reset the whole result list
	(assert (result))
	(retract ?result)
)
