; **********************************************************************************************************
; **************************************************************************************  slime setup
; **********************************************************************************************************
(setq inferior-lisp-program "/usr/local/bin/sbcl")
(add-to-list 'load-path "~/.emacs.d/slime/")
(require 'slime)
(slime-setup '(slime-fancy))    ; @@@@@@@@@@@@@ (slime-setup)   slime-repl-ansi-color



; **********************************************************************************************************
; **************************************************************************************  Emacs basic
; **********************************************************************************************************
; -------------------------------------------- provide color themes 
(add-to-list 'custom-theme-load-path "~/.emacs.d/jh-themes/emacs-color-theme-solarized/")
(load-theme 'solarized t)

; ------------------------------------------- hide the tool bar 
(tool-bar-mode -1)

; ------------------------------------------- set the font & theme 
(set-face-attribute 'default nil :font "The Sans Mono Condensed")  ; @@@@@@@@@@@@@ "Monaco"
(set-face-attribute 'default nil :height 140)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector
   ["black" "#d55e00" "#009e73" "#f8ec59" "#0072b2" "#cc79a7" "#56b4e9" "white"])
 '(custom-enabled-themes (quote (tsdh-dark))))

; ------------------------------------------  rainbow-delemiter 
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(highlight ((t (:background "MediumOrchid1"))))
 '(rainbow-delimiters-depth-1-face ((t (:inherit rainbow-delimiters-base-face :foreground "gray94"))))
 '(rainbow-delimiters-depth-2-face ((t (:inherit rainbow-delimiters-base-face :foreground "gold1"))))
 '(rainbow-delimiters-depth-3-face ((t (:inherit rainbow-delimiters-base-face :foreground "orchid2"))))
 '(rainbow-delimiters-depth-4-face ((t (:inherit rainbow-delimiters-base-face :foreground "SteelBlue1"))))
 '(rainbow-delimiters-depth-5-face ((t (:inherit rainbow-delimiters-base-face :foreground "chartreuse2"))))
 '(rainbow-delimiters-depth-6-face ((t (:inherit rainbow-delimiters-base-face :foreground "medium slate blue"))))
 '(rainbow-delimiters-depth-7-face ((t (:inherit rainbow-delimiters-base-face :foreground "turquoise1"))))
 '(rainbow-delimiters-depth-8-face ((t (:inherit rainbow-delimiters-base-face :foreground "sienna"))))
 '(rainbow-delimiters-depth-9-face ((t (:inherit rainbow-delimiters-base-face :foreground "slate gray"))))
 '(rainbow-delimiters-unmatched-face ((t (:inherit rainbow-delimiters-base-face :foreground "firebrick1")))))



; **********************************************************************************************************
; **************************************************************************************   Common Lisp
; **********************************************************************************************************
;;; --------------------------------------- lambda  
(prettify-symbols-mode)
(global-prettify-symbols-mode 1)

;;; --------------------------------------- parenthesis 

;; ***** highlight-parentheses  **** (doesn't work!)
(add-to-list 'load-path "~/.emacs.d/jh-configs/")
(require 'highlight-parentheses)  ;@@@@@@@@@ Enable the mode using M-x highlight-parentheses-mode or by adding it to a hook.

;; ***** rainbow-delimiters
(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)

;; ***** paredit
;(autoload 'enable-paredit-mode "paredit" "Turn on pseudo-structural editing of Lisp code." t)
;(add-hook 'emacs-lisp-mode-hook       #'enable-paredit-mode)
;(add-hook 'eval-expression-minibuffer-setup-hook #'enable-paredit-mode)
;(add-hook 'ielm-mode-hook             #'enable-paredit-mode)
;(add-hook 'lisp-mode-hook             #'enable-paredit-mode)
;(add-hook 'lisp-interaction-mode-hook #'enable-paredit-mode)
;(add-hook 'scheme-mode-hook           #'enable-paredit-mode)


;;; --------------------------------------- .lisp syntax colors
;; ***** slime-repl-ansi-color

;; ***** highlight-quoted
;;(add-hook 'emacs-lisp-mode-hook 'highlight-quoted-mode)



; **********************************************************************************************************
; **************************************************************************************    OCaml
;                                                                https://dev.realworldocaml.org/install.html
; **********************************************************************************************************
;; -- common-lisp compatibility if not added earlier in your .emacs
(require 'cl)

;; -- Tuareg mode -----------------------------------------


; **********************************************************************************************************
; *****************************************************************************  
; **********************************************************************************************************
