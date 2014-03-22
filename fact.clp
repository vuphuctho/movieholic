;; Facts
(deffacts initial-facts
	;; facts for movies
	(movie (movieName "Titanic"))
	(movie (movieName "Django"))

	;; facts for keywords
	(keyword (word "ship") (movieName "Titanic") (number 10))
	(keyword (word "sink") (movieName "Titanic") (number 8))
	(keyword (word "Titanic") (movieName "Titanic") (number 17))
	(keyword (word "Rose") (movieName "Titanic") (number 14))
	(keyword (word "Jack") (movieName "Titanic") (number 15))
	(keyword (word "love") (movieName "Titanic") (number 6))
	;; (keyword (word "") (movieName "") (number ))

	
)

