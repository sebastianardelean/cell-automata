(defsystem "cell-auto"
  :version "0.0.1"
  :author ""
  :license ""
  :depends-on (:cl-svg)
  :components ((:module "src"
                :components
                ((:file "main"))))
  :description ""
  :in-order-to ((test-op (test-op "cell-auto/tests"))))

(defsystem "cell-auto/tests"
  :author ""
  :license ""
  :depends-on ("cell-auto"
               "rove")
  :components ((:module "tests"
                :components
                ((:file "main"))))
  :description "Test system for cell-auto"
  :perform (test-op (op c) (symbol-call :rove :run c)))
