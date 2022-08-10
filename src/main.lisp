(defpackage my-game
  (:use :cl)

  (:import-from :sdl2 :with-init)
  (:import-from :sdl2 :with-window)
  (:import-from :sdl2 :with-renderer)
  (:import-from :sdl2 :with-event-loop)

  ;; (:import-from :sdl2 :get-window-surface)
  ;; (:import-from :sdl2 :fill-rect)
  ;; (:import-from :sdl2 :map-rgb)
  ;; (:import-from :sdl2 :surface-format)
  ;; (:import-from :sdl2 :scancode=)
  ;; (:import-from :sdl2 :scancode-value)
  (:import-from :sdl2 :push-event)
  (:import-from :sdl2 :scancode)
  (:import-from :sdl2 :set-render-draw-color)
  (:import-from :sdl2 :render-clear)
  (:import-from :sdl2 :render-present)
  (:import-from :sdl2 :render-copy)
  (:import-from :sdl2 :create-texture-from-surface)
  (:import-from :sdl2 :make-rect)
  (:import-from :sdl2 :surface-width)
  (:import-from :sdl2 :surface-height)
  (:import-from :sdl2 :rect-width)
  (:import-from :sdl2 :rect-height)

  (:import-from :sdl2-ttf :open-font)
  (:import-from :sdl2-ttf :render-utf8-solid)

  (:import-from :sdl2-image :load-image)

  (:export :main))
(in-package :my-game)

;; blah blah blah.

(defparameter +font-cica-path+
  "src/assets/fonts/Cica/Cica-Regular.ttf")
(defparameter +font-kfhm-path+
  "src/assets/fonts/KFhimaji/KFhimaji/KFhimaji.otf")
(defparameter +image-background-path+
  "src/assets/images/nc261519.png")
(defparameter +image-kiritan-path+
  "src/assets/images/8026365.png")

(defun render-print (renderer font text
                    &key (red 0) (green 0) (blue 0) (alpha 255)
                      (x 0) (y 0))
  (let ((s (render-utf8-solid font text red green blue alpha)))
    (render-copy renderer (create-texture-from-surface renderer s)
                 :dest-rect (make-rect x y
                                       (surface-width s) (surface-height s)))))

(defun render-image (renderer image x y
                     &key w h clip)
  (apply #'render-copy renderer
         (create-texture-from-surface renderer image)
         `(,@(if clip `(:source-rect ,clip) '())
           ,@(if clip
                 `(:dest-rect ,(make-rect x y
                                          (rect-width clip) (rect-height clip)))
                 `(:dest-rect ,(make-rect x y
                                          (or w (surface-width  image))
                                          (or h (surface-height image))))))))

(defmacro with-init@sdl2-ttf (&body body)
  `(progn (sdl2-ttf:init)
          ,@body
          (sdl2-ttf:quit)))

(defmacro with-init@sdl2-image (type &body body)
  `(progn (sdl2-image:init ,type)
          ,@body
          (sdl2-image:quit)))

(defun main ()
  (with-init (:video)
    (with-window (window :title "My GAME" :w 640 :h 480)
      ;; (let ((screen (get-window-surface window)))
      ;;   (fill-rect screen '() (map-rgb (surface-format screen) 100 250 200))
      ;;   (update-window window)
      ;;   (delay 5000))))
      (with-renderer (renderer window :index -1
                                      :flags '(:accelerated :presentvsync))
        (with-init@sdl2-ttf
          (with-init@sdl2-image '(:png)
            (let ((r 0) (g 0) (b 0)
                  (font-cica        (open-font  +font-cica-path+ 30))
                  (font-kfhm        (open-font  +font-kfhm-path+ 30))
                  (image-background (load-image +image-background-path+))
                  (image-kiritan    (load-image +image-kiritan-path+)))
              (with-event-loop (:method :poll)
                (:keyup (:keysym keysym)
                        ;; (if (scancode= (scancode-value keysym) :scancode-escape)
                        (if (eql (scancode keysym) :scancode-escape)
                            (push-event :quit)
                            (setf r 0 g 0 b 0)))
                (:keydown (:keysym keysym)
                          (case (scancode keysym)
                            (:scancode-r (setf r 255 g 0   b 0))
                            (:scancode-g (setf r 0   g 255 b 0))
                            (:scancode-b (setf r 0   g 0   b 255))))
                (:idle ()
                       (set-render-draw-color renderer r g b 255)
                       (render-clear renderer)
                       (render-image renderer image-background
                                     0 0 :w 640 :h 480)
                       (render-image renderer image-kiritan
                                     200 200 :clip (make-rect 0  0 32 32))
                       (render-image renderer image-kiritan
                                     232 232 :clip (make-rect 0 32 32 32))
                       (render-image renderer image-kiritan
                                     264 264 :clip (make-rect 0 64 32 32))
                       (render-image renderer image-kiritan
                                     296 296 :clip (make-rect 0 96 32 32))
                       (render-print renderer font-cica
                                     "CicaフォントでHello, world!"
                                     :red 100 :green 100 :blue 200
                                     :x 50 :y 100)
                       (render-print renderer font-kfhm
                                     "KFひま字フォントでHello, world!"
                                     :red 100 :green 200 :blue 100
                                     :x 50 :y 150)
                       (render-present renderer))
                (:quit () 't))))))))
  'done)
