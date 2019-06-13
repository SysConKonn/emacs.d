;;; init-ui.el --- Initialize ui configurations.	-*- lexical-binding: t -*-

(setq frame-title-format '("Emacs - %b")
      icon-title-format frame-title-format)

;; show native line numbers
(if (fboundp 'display-line-numbers-mode)
    (use-package display-line-numbers
      :ensure nil
      :hook (prog-mode . display-line-numbers-mode))
  (use-package linum-off
    :demand
    :defines linum-format
    :hook (after-init . global-linum-mode)
    :config
    (setq linum-format "%4d ")

    ;; Highlight current line number
    (use-package hlinum
      :defines linum-highlight-in-all-buffersp
      :hook (global-linum-mode . hlinum-activate)
      :custom-face (linum-highlight-face
                    ((t `(
                          :inherit default
                          :background nil
                          :foreground nil
                          ))))
      :init
      (setq linum-highlight-in-all-buffersp t))))

;; set scroll config
(when (display-graphic-p)
  (setq mouse-wheel-scroll-amount '(1 ((shift) . 1))
        mouse-wheel-progressive-speed nil))
(setq scroll-step 1
      scroll-margin 0
      scroll-conservatively 100000)

;; set window config
(tool-bar-mode 0)
;;(menu-bar-mode 0)
(scroll-bar-mode 0)
(show-paren-mode t)
;; (global-linum-mode 1)
;;(global-hl-line-mode)
(setq maxx nil)
(if maxx
    (add-to-list 'default-frame-alist '(fullscreen . maximized)))

;; change alpha
(global-set-key (kbd "C-`") 'loop-alpha)
(setq alpha-list '((85 55) (100 100)))
(defun loop-alpha ()
  (interactive)
  (let ((h (car alpha-list)))
    ((lambda (a ab)
       (set-frame-parameter (selected-frame) 'alpha (list a ab))
       (add-to-list 'default-frame-alist (cons 'alpha (list a ab)))
       ) (car h) (car (cdr h)))
    (setq alpha-list (cdr (append alpha-list (list h))))
    )
  )

;; set theme
(setq-default cursor-type 'blink)
;; (setq-default line-spacing 0.15)
(put 'downcase-region 'disabled nil)
(use-package doom-themes
  :ensure t
  :config
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t)
  (doom-themes-visual-bell-config)
  (doom-themes-treemacs-config)
  (doom-themes-org-config)
  (setq night-theme 'doom-one)
  (setq day-theme 'doom-one-light)
  (defun synchronize-theme ()
    (setq hour
          (string-to-number
           (substring (current-time-string) 11 13)))
    (if (member hour (number-sequence 9 18))
        (progn
          (setq now day-theme)
          (message "Day Now"))
      (progn
        (setq now night-theme)
        (message "Night Now")))
    (load-theme now t))
  (run-with-timer 0 3600 'synchronize-theme))

(provide 'init-ui)

;;;init-ui.el ends here
