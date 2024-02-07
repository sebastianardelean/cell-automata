(defpackage cell-auto/tests/main
  (:use :cl
        :cell-auto
        :rove))
(in-package :cell-auto/tests/main)

;; NOTE: To run this test file, execute `(asdf:test-system :cell-auto)' in your Lisp.

(deftest test-target-1
  (testing "should (= 1 1) to be true"
    (ok (= 1 1))))
