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
  (:import-from :sdl2 :scancode=)
  (:import-from :sdl2 :scancode-value)
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
  "assets/fonts/Cica/Cica-Regular.ttf")
(defparameter +font-kfhm-path+
  "assets/fonts/KFhimaji/KFhimaji/KFhimaji.otf")
(defparameter +image-background-path+
  "assets/images/background.png")
(defparameter +image-kiritans-path+
  "assets/images/kiritans.png")

(defparameter +font-cica+        'to-avoid-warning)
(defparameter +font-kfhm+        'to-avoid-warning)
(defparameter +image-background+ 'to-avoid-warning)
(defparameter +image-kiritans+   'to-avoid-warning)

(defun drew-renderer (renderer &key h j k l)
  (let ((font-cica        +font-cica+)
        (font-kfhm        +font-kfhm+)
        (image-background +image-background+)
        (image-kiritans   +image-kiritans+))
    (render-clear renderer)
    (render-image renderer image-background 0 0 :w 640 :h 480)
    (render-image renderer image-kiritans
                  200 (if h 168 200)
                  :clip (make-rect 0  0 32 32))
    (render-image renderer image-kiritans
                  232 (if j 200 232)
                  :clip (make-rect 0 32 32 32))
    (render-image renderer image-kiritans
                  264 (if k 232 264)
                  :clip (make-rect 0 64 32 32))
    (render-image renderer image-kiritans
                  296 (if l 264 296)
                  :clip (make-rect 0 96 32 32))
    (render-print renderer font-cica "Cica???????????????Hello, world!"
                  :red 255 :green 100 :blue 200 :x 50 :y 100)
    (render-print renderer font-kfhm "KF????????????????????????Hello, world!"
                  :red 255 :green 200 :blue 100 :x 50 :y 150)
    (render-present renderer)))

(defun init-renderer (renderer)
  (drew-renderer renderer))

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
      (with-renderer
          (renderer window :index -1 :flags '(:accelerated :presentvsync))
        (with-init@sdl2-ttf
          (defparameter +font-cica+ (open-font +font-cica-path+ 30))
          (defparameter +font-kfhm+ (open-font +font-kfhm-path+ 30))
          (with-init@sdl2-image '(:png)
            (defparameter +image-background+ (load-image +image-background-path+))
            (defparameter +image-kiritans+   (load-image +image-kiritans-path+))
            (init-renderer renderer)
            (with-event-loop (:method :poll)
              (:keyup (:keysym keysym)
                      (cond
                        ((scancode= (scancode-value keysym) :scancode-escape)
                         (push-event :quit))
                        ('t (init-renderer renderer))))
              (:keydown (:keysym keysym)
                        (when (scancode= (scancode-value keysym) :scancode-h)
                          (drew-renderer renderer :h 't))
                        (when (scancode= (scancode-value keysym) :scancode-j)
                          (drew-renderer renderer :j 't))
                        (when (scancode= (scancode-value keysym) :scancode-k)
                          (drew-renderer renderer :k 't))
                        (when (scancode= (scancode-value keysym) :scancode-l)
                          (drew-renderer renderer :l 't))
                        (when
                            (scancode= (scancode-value keysym) :scancode-space)
                          (drew-renderer renderer :h 't :j 't :k 't :l 't)))
              (:quit () 't)))))))
  'done)
