;; Templates

;; movie templates
(deftemplate movie
	(slot movieName (type STRING))
	(slot inResult (type NUMBER) (default 0))
	(slot similarity (type NUMBER) (default 0)))

;; keyword template
(deftemplate keyword
	(slot word (type STRING))
	(slot movieName (type STRING))
	(slot number (type INTEGER))
	(slot check (type INTEGER) (default 0))
)

;; question template
(deftemplate question
	(slot event (type STRING)))

;; TODO Change this to a list!!!
;; result template
(deftemplate result
	(multislot movieName (type STRING)))
	
;; user-interface template
(deftemplate phase
	(slot event (type SYMBOL)))