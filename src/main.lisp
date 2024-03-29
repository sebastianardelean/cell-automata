(defpackage cell-auto
  (:use :cl :cl-svg))
(in-package :cell-auto)

;; blah blah blah.
(defvar ~ROWS~ 400)
(defvar ~RULE~ 102)
(defvar ~PIXEL-WIDTH~ 2)
(defvar ~PIXEL-HEIGHT~ 2)


(defun init (i rule-map rule) ;; to be called as (init 0 '() 102)
  (if (< i 8)
      (init (+ i 1) (append rule-map (list (mod rule 2))) (floor rule 2))
      rule-map))

(defun binary-to-decimal (binary-list)
  "Converts a binary list to its decimal equivalent."
  (if (null binary-list)
      0
      (+ (* (car binary-list) (expt 2 (1- (length binary-list))))
         (binary-to-decimal (cdr binary-list)))))

(defun get-last-element (list)
  "Get the last sublist from a list."
  (if (null list)
      nil
      (let ((last-element (car (last list))))
        (if (listp last-element)
            last-element
            (last list)))))

(defun get-recent-value (pos data)
  (if (or (< pos 0) (>= pos (length (get-last-element data))))
      0
      (nth pos (get-last-element data))))

(defun get-recent-block (pos data)
  (binary-to-decimal (mapcar (lambda (it) (get-recent-value (+ pos it) data)) '(-1 0 1))))

(defun get-blocks (i rule-map data values)
  (if (< i (+ (length (get-last-element data)) 1))
      (get-blocks (+ i 1) rule-map data (append values (list (nth (get-recent-block i data) rule-map))))
      values))

(defun generate (rows init-rule data) ;;last parameter should be '((1))
  (let ((rule-map (init 0 '() init-rule)));;(init 0 '() 102)
    (if (< (length data) rows)
        (generate rows init-rule (append data (list (get-blocks -1 rule-map data '()))))
        data)))
                  

(defun enumerate (list)
  (mapcar #'list (loop for index from 0 to (1- (length list))
                       collect index)
                 list))

(defun traverse (data scene cols)
  (loop for x in (enumerate data)
        do (loop for y in (enumerate (second x))
                 do (if (= (second y) 1)
                        (cl-svg:draw scene (:rect :x (+ (- cols (* (first x) 2)) (* (first y) 2))
                                                  :y (* 2 (first x))
                                                  :height ~PIXEL-HEIGHT~
                                                  :width ~PIXEL-WIDTH~))
                        nil))))





(defun draw-svg-to-file (data)
  (let ((rows (length data))
        (cols (length (get-last-element data))))
    (cl-svg:with-svg-to-file
        (scene 'cl-svg:svg-1.1-toplevel :height (* 2 rows) :width (* 2 cols))
        (#p"rule102.svg" :if-exists :supersede)
      (traverse data scene cols))))

(defun run ()
  (let ((data (generate ~ROWS~ ~RULE~ '((1)))))
    (draw-svg-to-file data)))
