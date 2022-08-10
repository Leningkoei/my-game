(defpackage my-game/tests/main
  (:use :cl
        :my-game
        :rove))
(in-package :my-game/tests/main)

;; NOTE: To run this test file, execute `(asdf:test-system :my-game)' in your Lisp.

(deftest test-my-game ()
  (testing "1 + 1 = 2"
           (ok (= (+ 1 1) 2))))
