;;; -*- Mode:Lisp; Syntax:ANSI-Common-Lisp; Coding:utf-8 -*-

(in-package #:cl-random)



;; TODO: Add shuffle! and elt (see :alexandria).

(defun distinct-random-integers (count limit &key (rng *random-state*))
  "Return a vector of COUNT distinct random integers, in increasing order,
drawn from the uniform discrete distribution on {0 , ..., limit-1}."
  (assert (<= count limit))
  (distinct-random-integers-dense count limit :rng rng))

(defun distinct-random-integers-dense (count limit &key (rng *random-state*))
  "Implementation of DISTINCT-RANDOM-INTEGERS when count/limit is (relatively)
high. Implements algorithm S from @cite{taocp3}, p 142."
  (let ((result (make-array count)))
    (loop with selected = 0
          for index below limit
          do (when (draw-bernoulli (/ (- count selected)
                                      (- limit index))
				   :rng rng)
               (setf (aref result selected) index)
               (incf selected)
               (when (= selected count)
                 (return))))
    result))
