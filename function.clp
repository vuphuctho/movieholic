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
	;;(loop-for-count 10
		?result <- (result (movieName $?names))
		(not (keyword (check ?t&: (= ?t 0))))
		?movie <- (movie (movieName ?name) (inResult ?i &: (= ?i 0)) (similarity ?sim&: (> ?sim 0)))
		(not (movie (inResult ?j &: (= ?j 0)) (similarity ?other_sim&: (> ?other_sim ?sim ))))
		=>
		;;(slot-insert$ movie movieName 10 ?name)
		(modify ?movie (inResult 1))
		(if (= (length$ $?names) 0 )
			then 
				(assert (result (movieName ?name)))
			else 
				(assert (result (movieName $?names ?name)))
		)
		(retract ?result)




	;;)
	
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
