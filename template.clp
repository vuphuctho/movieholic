;; Templates

;; movie templates
(deftemplate movie
	(slot movieName (type STRING)))

;; keyword template
(deftemplate keyword
	(slot word (type STRING))
	(slot movieName (type STRING))
	(slot number (type INTEGER)))

;; question template
(deftemplate question
	(slot event (type STRING)))

;; result template
(deftemplate result
	(slot movieName (type STRING))
	(slot similarity (type NUMBER)))