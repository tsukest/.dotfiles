(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (go-mode yasnippet-snippets yasnippet company lsp-ui lsp-mode geiser paredit ##))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;;
(setq scroll-conservatively 1)
(setq scroll-margin 10)
(setq next-screen-context-lines 10)
(setq scroll-preserve-screen-position t)
(setq backup-directory-alist '((".*" . "~/.emacs_history")))
(setq auto-save-file-name-transforms   '((".*" "~/.emacs_history/" t)))
(global-hl-line-mode t)
(show-paren-mode t)

;; Keyboard
(unless window-system
  (keyboard-translate ?\C-h ?\C-?))

;; Server mode
(defun my-server-detach-buffer ()
  (interactive)
  (server-buffer-done (current-buffer) t)
  (message "Detached")
  )
(global-set-key "\C-xc" 'my-server-detach-buffer)

;; Snippets
;; yasnippet: https://github.com/joaotavora/yasnippet
(yas-global-mode 1)

;; Auto complete
;; company-mode: http://company-mode.github.io/
(add-hook 'after-init-hook 'global-company-mode)
(with-eval-after-load 'company
  (setq company-idle-delay 0)
  (setq company-selection-wrap-around t)
  (define-key company-active-map (kbd "M-n") nil)
  (define-key company-active-map (kbd "M-p") nil)
  (define-key company-active-map (kbd "C-n") 'company-select-next)
  (define-key company-active-map (kbd "C-p") 'company-select-previous))

;; Lisp
;; paredit: https://www.emacswiki.org/emacs/ParEdit
(with-eval-after-load 'lisp-mode
  (autoload 'enable-paredit-mode "paredit" "Turn on pseudo-structural editing of Lisp code." t)
  (add-hook 'emacs-lisp-mode-hook       #'enable-paredit-mode)
  (add-hook 'eval-expression-minibuffer-setup-hook #'enable-paredit-mode)
  (add-hook 'ielm-mode-hook             #'enable-paredit-mode)
  (add-hook 'lisp-mode-hook             #'enable-paredit-mode)
  (add-hook 'lisp-interaction-mode-hook #'enable-paredit-mode)
  (add-hook 'scheme-mode-hook           #'enable-paredit-mode))

;; Go
;; go-mode: https://github.com/dominikh/go-mode.el
(with-eval-after-load 'go-mode
  (setq tab-width 4)
  (setq company-backends '(company-capf))
  (add-hook 'go-mode-hook 'lsp-deferred))
