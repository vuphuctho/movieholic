;; Functions

;; STEP 1: QUERY PREPROCESSING

;; STEP 2: TEXT-MATCHING AND SIMILARITY MEASUREMENT	
;; Rule: text matching
;; Premise: if there exists query, find an unchecked keyword (check = 0)
;; and its corresponding movie
;; Action: 1) Match keyword as checked (check = 1)
;; 		   2) If keyword appears in query, modify similarity value of movie
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
	(if (str-index ?y ?x)
		then	
		(modify ?movie (similarity (+ ?w ?no)))
	)
)

;; STEP 3: RETRIEVE RESULTS
;; JOHN : To return results as a list
;; get top result
(defrule get-result
		;;(phase (event UI_TopResult))
		?result <- (result (movieName $?names) (loop ?l&: (< ?l 10)))
		(not (keyword (check 0)))
		?movie <- (movie (movieName ?name) (inResult 0) (similarity ?sim))
		(not (movie (inResult 0) (similarity ?other_sim&: (> ?other_sim ?sim ))))
		=>
		(if (> ?sim 0)
			then
			(printout t "The movie " ?name " is added to the result list" crlf)
			(modify ?movie (inResult 1))
			(if (= (length$ $?names) 0)
				then 
				;;(printout t "Length of result list: " (length$ $?names) crlf)		
				(assert (result (movieName ?name) (loop (+ ?l 1))))				
				else 
				;;(printout t "Length of result list: " (length$ $?names) crlf)
				(assert (result (movieName $?name ?name) (loop (+ ?l 1))))
			)
			(retract ?result)
			else 
			;; still update loop value
			(printout t "No movie is added " crlf)
			(modify ?result (loop (+ ?l 1))) 
		)
)


;; Reset data
(defrule reset-keyword
	;; keep high salience
	(declare (salience 20))
	(phase (event UI_MoreKeywords))
	?keyword <- (keyword (check 1))
	=>
	(modify ?keyword (check 0))
)

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

;; TODO: Remove this and put a corresponding title in UI
;; print result
;;(defrule print-result
;;	(result (movieName ?name $?other-names))
;;	=>
;;	(printout t "The movie you are looking for is: ")
;;	(printout t ?name crlf)
;;	
;;)	

;; STEP 4: Further process to narrow down result's list


;;(defrule print-result
;;	(result (movieName ?firstMovie $?))
;;	=>
;;	(printout t "The movie you are looking for is: " ?firstMovie "." crlf)
;;)	
