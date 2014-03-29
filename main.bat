;; to begin the program, call (batch "main.bat")

;; remove previous loader constructs
(clear)

;; load files
;; remember to pass the whole link to the files
(load "movieholic/template.clp")
(load "movieholic/fact.clp")
(load "movieholic/function.clp")
(load "movieholic/ui.clp")
(printout t "testing main.bat" crlf)

;; start running program
(reset)
(run)