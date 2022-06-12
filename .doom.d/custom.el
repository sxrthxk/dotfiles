(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(lsp-tailwindcss projectile org-fancy-priorities org-attach-screenshot org-download org-superstar org-roam emmet-mode elscreen-multi-term cider lsp-mode multi-vterm unicode-escape multi-term unicode-fonts vterm))
 '(safe-local-variable-values
   '((cider-print-options
      (("print-length" nil)))
     (cider-print-fn . puget)
     (cider-ns-refresh-before-fn . "user/stop")
     (cider-ns-refresh-after-fn . "user/start")
     (eval setenv "VADE_STAGE" "local")
     (eval setenv "AWS_LOCAL_SQS" "true")
     (eval setenv "AWS_REGION" "eu-west-2"))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(put 'projectile-grep 'disabled nil)
