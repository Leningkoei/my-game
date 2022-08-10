(in-package :asdf)

(defsystem "my-game"
  :version "0.1.0"
  :author "leningkoei"
  :license ""
  :depends-on ("sdl2"
               "sdl2-ttf"
               "sdl2-image")
  :components ((:module "src"
                :components
                ((:file "main"))))
  :description ""
  :in-order-to ((test-op (test-op "my-game/tests"))))

(defsystem "my-game/tests"
  :author "leningkoei"
  :license ""
  :depends-on ("my-game"
               "sdl2"
               "sdl2-ttf"
               "sdl2-image"
               "rove")
  :components ((:module "tests"
                :components
                ((:file "main"))))
  :description "Test system for my-game"
  :perform (test-op (op c) (symbol-call :rove :run c)))
