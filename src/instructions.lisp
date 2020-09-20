(defpackage cpu.instructions
  (:use :cl :cpu.cpu :cpu.memory)
  (:export #:move.b
           #:lea
           #:nop
           #:trap
           #:add
           #:sub
           #:mul
           #:div))
(in-package :cpu.instructions)

(defgeneric move (vm location val)
  (:documentation "Moves a bit sized value into either memory or a cpu register"))

(defgeneric move.n (vm location val)
  (:documentation "Moves a nybble sized value into either memory or a cpu register"))

(defgeneric move.b (vm location val)
  (:documentation "Moves a bytes sized value into either memory or a cpu register"))

(defgeneric move.w (vm location val)
  (:documentation "Moves a word sized value into either memory or a cpu register"))

(defgeneric move.l (vm location val)
  (:documentation "Moves a long-word sized value into either memory or a cpu register"))

(defmethod move.b (vm (location symbol) val)
  (setf (val (register location (cpu vm))) val))

(defmethod move.b (vm (location number) val)
  (multiple-value-bind (x y)
      (floor location)
    (write-memory (memory vm) y x val)))

(defun nop (vm))

(defun dc.b (vm label data)
  0)

(defun lea (vm src dest)
  (setf (val (register dest (cpu vm))) src))

(defun trap (vm trap-code)
  (when (= #xf trap-code)
    (let ((trap-task (val (register :d0 (cpu vm)))))
      (cond
        ((= 9  trap-task)
         (cl-user::quit))

        ((= 13 trap-task)
         (let ((addr (val (register :a1 (cpu vm)))))
           (format t "~A~%" (read-string (memory vm) 0))))

        ((= 14 trap-task)
         (format t "~A" (val (register :a1 (cpu vm)))))))))

(defun add (vm destination source1 source2)
  (setf (val    (register destination (cpu vm)))
        (+ (val (register source1     (cpu vm)))
           (val (register source2     (cpu vm))))))

(defun sub (vm destination source1 source2)
  (setf (val    (register destination (cpu vm)))
        (- (val (register source1     (cpu vm)))
           (val (register source2     (cpu vm))))))

(defun mul (vm destination source1 source2)
  (setf (val    (register destination (cpu vm)))
        (* (val (register source1     (cpu vm)))
           (val (register source2     (cpu vm))))))

(defun div (vm destination source1 source2)
  (setf (val    (register destination (cpu vm)))
        (/ (val (register source1     (cpu vm)))
           (val (register source2     (cpu vm))))))
