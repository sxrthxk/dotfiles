;;; fonts.el -*- lexical-binding: t; -*-

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
 (setq doom-font (font-spec :family "MesloLGS NF" :size 18)
       doom-unicode-font (font-spec :family "MesloLGS NF"))
; (add-hook 'term-exec-hook
;           (function
;            (lambda ()
;              (set-buffer-process-coding-system 'utf-8-unix 'utf-8-unix))))

