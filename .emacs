(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

;; Keyboard
(keyboard-translate ?\C-h ?\C-?)
(keyboard-translate ?\C-? ?\C-h)

;; Server mode
(defun my-server-detach-buffer ()
  (interactive)
  (server-buffer-done (current-buffer) t)
  (message "Detached")
  )
(global-set-key "\C-xc" 'my-server-detach-buffer)

;; Auto complete
;; company-mode: http://company-mode.github.io/
(add-hook 'after-init-hook 'global-company-mode)
(with-eval-after-load 'company
  (setq company-idle-delay 0)
  (setq company-selection-wrap-around t))

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
  (setq company-backends '(company-capf))
  (setq gofmt-command "goimports")
  (add-hook 'before-save-hook 'gofmt-before-save)
  (add-hook 'go-mode-hook 'lsp-deferred))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(auto-save-file-name-transforms (quote ((".*" "~/.emacs_history/" t))))
 '(backup-directory-alist (quote ((".*" . "~/.emacs_history"))))
 '(global-hl-line-mode t)
 '(ivy-count-format "(%d/%d) ")
 '(ivy-mode t)
 '(ivy-use-virtual-buffers t)
 '(next-screen-context-lines 10)
 '(package-selected-packages
   (quote
    (go-mode lsp-ivy lsp-ui lsp-mode geiser paredit yasnippet-snippets yasnippet company counsel ##)))
 '(scroll-conservatively 1)
 '(scroll-margin 10)
 '(scroll-preserve-screen-position t)
 '(show-paren-mode t)
 '(yas-global-mode t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
