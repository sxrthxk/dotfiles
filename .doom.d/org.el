;;; org.el -*- lexical-binding: t; -*-

                                        ; (use-package org-visual-indent)

(setq org-hide-emphasis-markers t)

(use-package org
  :hook (org-mode .
                  (lambda ()
                    (org-visual-indent-mode)
                    (org-indent-mode)))
  (org-mode .
            (lambda ()
              (set-face-attribute 'org-document-title nil
                                  :font "ET Bembo"
                                  :height 3.0
                                  :slant 'italic
                                  :weight 'normal)
              (set-face-attribute 'org-level-1 nil
                                  :height 1.2)))
  :config (setq org-image-actual-width 500)
  (setq org-startup-with-inline-images t)
  (setq org-startup-with-latex-preview t))

;; If you use`org' and don't want your org files in the default location below,
;; change `org - directory'. It must be set before org loads!
(setq org-directory "~/gdrive/org/")
(setq org-roam-directory "~/Dropbox/RoamDocs/")

(use-package! org-download)
