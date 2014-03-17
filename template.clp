;; Templates

;; movie templates
(deftemplate movie
	(slot movieName (type STRING))
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

;; result template
(deftemplate result
	(slot movieName (type STRING)))