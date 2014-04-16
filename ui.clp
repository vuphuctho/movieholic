;; User Interface Rules

;; Ask user for keywords for one event in movie
;; Premise:
;;    1) Phase UI_Welcome
;; Action
;;    1) Display simple guideline to start running program
;;    2) Ask for query and retrieve input
;;    3) If input is null value
;;          - Quit the program
;;       Else
;;          - Change phase to UI_TopResult
(defrule UIwelcome
  ?phase <- (phase (event UI_Welcome))
  =>
  (printout t "************************************************************************" crlf)
  (printout t "** Welcome to Movieholic - an application for any holic of movie! **" crlf)
  (printout t "** First, we need some information to find your favorite movie." crlf)
  (printout t "** Please enter an event in the movie (keywords only): " crlf)
  (printout t "** At anytime press enter without anything to exit." crlf)
  (printout t "************************************************************************" crlf)
  (bind ?n (readline))
  (if (= (str-length ?n) 0)
    then 
      (printout t "Thank you for using Movieholic!" crlf)
      (halt) 
  )
  (if (> (str-length ?n) 0)
    then 
      (assert (question (event ?n)))
      (modify ?phase (event UI_TopResult))
  )
)

;; Display first result and receive user's feedback
;; Premise:
;;    1) Phase: UI_TopResult
;;    2) Result's size = 10 (loop = 10)
;; Action:
;;    If result has movie's name 
;;        - Display the name and ask user to confirm the result
;;          If user says yes:
;;              - Reply and reset the program
;;          Else
;;              - Reply and change phase to UI_OtherResults
;;    Else
;;        - Reply and change phase to UI_MoreKeywords
(defrule UItopResult
  ?phase <- (phase (event UI_TopResult))
  ?result <- (result (movieName $?x ?y) (loop 10))
  =>
  (if (> (length$ $?x) 0) 
    then 
    (printout t "Is the movie you are looking for " (nth$ (length$ $?x) $?x) crlf)
    (printout t "1. Yes 2. No" crlf)
    (bind ?n (read))
    (if (= ?n 1) then
      (printout t "I'm glad we were able to help." crlf)
      (reset)
      (run)
    )
    (if (= ?n 2) 
      then
      (printout t "Hold on while we search for other results..." crlf)
      (modify ?phase (event UI_OtherResults))
      (modify ?result (movieName (rest$ $?x)))
      else
      (halt)
    )
    else
    (printout t "Looks like we couldn't find any result with the current keywords." crlf)
    (modify ?phase (event UI_MoreKeywords))
  )
)

;; Display other movies' name and retrieve feedback
;; Premise:
;;      1) Phase: UI_OtherResults
;;      2) Result has movie's name
;;  Action
;;      If movie's name is null
;;          - Reply and change phase to UI_MoreKeywords
;;      Else
;;          - Display movie's name and ask user to confirm the result
;;          If user says yes
;;              - Reply and reset program
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
    )
    (if (= ?n 1) then
      (modify ?phase (event UI_MoreKeywords))
    else
      (halt)
    )
  )
)

;; Ask user for more keywords
;; Premise:
;;      1) Phase: UI_MoreKeywords
;;      2) No movie in result (inResult != 0)
;;      3) No keyword checked (check != 1)
;; Action:
;;      1) Ask user for more keywords or enter to exit
;;      2) If user enter keywords:
;;          - Add keywords to question 
;;          - Change phase to UI_TopResult
(defrule UImoreKeywords
  ?phase <- (phase (event UI_MoreKeywords))
  ?question <- (question (event ?originalQuery))
  (not (movie (inResult 1)))
  (not (keyword (check 1)))
  =>
  (printout t "Could we please get more keywords from you?" crlf)
  (printout t "(Press enter without anything to exit.)" crlf)
  (bind ?newQuery (readline))
  (if (= (str-length ?newQuery) 0) then 
    (printout t "Apologies, we were not able to find your movie ***" crlf crlf)
    (halt)
  )
  (if (> (str-length ?newQuery) 0) then 
    (modify ?question (event (str-cat ?newQuery(str-cat " " ?originalQuery))))
    (modify ?phase (event UI_TopResult))
    ;; this cant work since all keywords are checked
  ) 
)

;;(batch "movieholic/main.bat")

;;TODO John to add interaction with user. 
;;TODO 2: add a chart
;; Ask-event
;; is-result-correct?
;;  (yes) try again?        (no) ask from list
;;                          (yes) exit       (no) ask for keywords
;;                                           (yes)ok  (no) sorry!