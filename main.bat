;; to begin the program, call (batch "main.bat")

;; remove previous loader constructs
(clear)

;; load files
;; remember to pass the whole link to the files
(load "repo/movieholic/template.clp")
(load "repo/movieholic/fact.clp")
(load "repo/movieholic/function.clp")
(load "repo/movieholic/ui.clp")
(printout t "testing main.bat" crlf)

;; start running program
(reset)
(run)