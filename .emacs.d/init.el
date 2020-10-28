;;; init.el -- My init.el  -*- lexical-binding: t; -*-
;;; Commentary:
;; This is using leaf package.
;; Based on https://emacs-jp.github.io/tips/emacs-in-2020.
;;; Code:

(eval-and-compile
  (when (or load-file-name byte-compile-current-file)
    (setq user-emacs-directory
          (expand-file-name
           (file-name-directory (or load-file-name byte-compile-current-file))))))

(eval-and-compile
  (customize-set-variable
   'package-archives '(("gnu"   . "https://elpa.gnu.org/packages/")
                       ("melpa" . "https://melpa.org/packages/")
                       ("org"   . "https://orgmode.org/elpa/")))
  (package-initialize)
  (unless (package-installed-p 'leaf)
    (package-refresh-contents)
    (package-install 'leaf))

  (leaf leaf-keywords
    :ensure t
    :init
    ;; optional packages if you want to use :hydra, :el-get, :blackout,,,
    (leaf hydra :ensure t)
    (leaf el-get :ensure t)
    (leaf blackout :ensure t)

    :config
    ;; initialize leaf-keywords.el
    (leaf-keywords-init)))

;; Packages for leaf

(leaf leaf
  :config
  (leaf leaf-convert :ensure t)
  (leaf leaf-tree
    :ensure t
    :custom ((imenu-list-size . 30)
             (imenu-list-position . 'left))))

;; Standard Package Settings

(leaf cus-edit
  :doc "tools for customizing Emacs and Lisp packages"
  :tag "builtin" "faces" "help"
  :custom `((custom-file . ,(locate-user-emacs-file "custom.el"))))

(leaf cus-start
  :doc "define customization properties of builtins"
  :tag "builtin" "internal"
  :preface
  (defun c/redraw-frame nil
    (interactive)
    (redraw-frame))
  :bind (("M-ESC ESC" . c/redraw-frame)
         ("C-c c" . org-capture))
  :custom '((user-full-name . "satake")
            (user-mail-address . "satake.ts@gmail.com")
            (user-login-name . "satake")
            (create-lockfiles . nil)
            (debug-on-error . t)
            (init-file-debug . t)
            (frame-resize-pixelwise . t)
            (enable-recursive-minibuffers . t)
            (history-length . 1000)
            (history-delete-duplicates . t)
            (scroll-preserve-screen-position . t)
            (scroll-conservatively . 100)
            (mouse-wheel-scroll-amount . '(1 ((control) . 5)))
            (ring-bell-function . 'ignore)
            (text-quoting-style . 'straight)
            (truncate-lines . t)
            ;; (use-dialog-box . nil)
            ;; (use-file-dialog . nil)
            ;; (menu-bar-mode . t)
            (tool-bar-mode . nil)
            (scroll-bar-mode . nil)
            (indent-tabs-mode . nil)
            (global-hl-line-mode . t)
            (next-screen-context-lines . 10))
  :config
  (defalias 'yes-or-no-p 'y-or-n-p)
  (set-face-attribute 'default nil
                    :family "Ricty"
                    :height 120)
  (set-fontset-font (frame-parameter nil 'font)
                    'japanese-jisx0208
                    (cons "Ricty" "iso10646-1"))
  (set-fontset-font (frame-parameter nil 'font)
                    'japanese-jisx0212
                    (cons "Ricty" "iso10646-1"))
  (set-fontset-font (frame-parameter nil 'font)
                    'katakana-jisx0201
                    (cons "Ricty" "iso10646-1")))

(eval-and-compile
  (leaf bytecomp
    :doc "compilation of Lisp code into byte code"
    :tag "builtin" "lisp"
    :custom (byte-compile-warnings . '(cl-functions))))

(leaf autorevert
  :doc "revert buffers when files on disk change"
  :tag "builtin"
  :custom ((auto-revert-interval . 0.3)
           (auto-revert-check-vc-info . t))
  :global-minor-mode global-auto-revert-mode)

(leaf cc-mode
  :doc "major mode for editing C and similar languages"
  :tag "builtin"
  :defvar (c-basic-offset)
  :bind (c-mode-base-map
         ("C-c c" . compile))
  :mode-hook
  (c-mode-hook . ((c-set-style "bsd")
                  (setq c-basic-offset 4)))
  (c++-mode-hook . ((c-set-style "bsd")
                    (setq c-basic-offset 4))))

(leaf delsel
  :doc "delete selection if you insert"
  :tag "builtin"
  :global-minor-mode delete-selection-mode)

(leaf paren
  :doc "highlight matching paren"
  :tag "builtin"
  :custom ((show-paren-delay . 0.1))
  :global-minor-mode show-paren-mode)

(leaf simple
  :doc "basic editing commands for Emacs"
  :tag "builtin" "internal"
  :custom ((kill-ring-max . 100)
           (kill-read-only-ok . t)
           (kill-whole-line . t)
           (eval-expression-print-length . nil)
           (eval-expression-print-level . nil)))

(leaf files
  :doc "file input and output commands for Emacs"
  :tag "builtin"
  :custom `((auto-save-timeout . 15)
            (auto-save-interval . 60)
            (auto-save-file-name-transforms . '((".*" ,(locate-user-emacs-file "backup/") t)))
            (backup-directory-alist . '((".*" . ,(locate-user-emacs-file "backup"))
                                        (,tramp-file-name-regexp . nil)))
            (version-control . t)
            (delete-old-versions . t)))

(leaf startup
  :doc "process Emacs shell arguments"
  :tag "builtin" "internal"
  :custom `((auto-save-list-file-prefix . ,(locate-user-emacs-file "backup/.saves-"))))

(leaf display-line-numbers
  :doc "interface for display-line-numbers"
  :tag "builtin"
  :added "2020-10-17"
  :global-minor-mode global-display-line-numbers-mode)

(leaf time
  :doc "display time, load and mail indicator in mode line of Emacs"
  :tag "builtin"
  :added "2020-10-23"
  :global-minor-mode display-time-mode
  :custom ((display-time-day-and-date . t)
           (display-time-24hr-format . t)
           (display-time-mail-file . 'none)
           (display-time-load-average-threshold . 0.3)))

(leaf org
  :doc "Export Framework for Org Mode"
  :tag "builtin"
  :added "2020-10-17"
  :custom ((org-agenda-files . '("~/Documents/GTD/inbox.org"
                                 "~/Documents/GTD/project.org"
                                 "~/Documents/GTD/someday.org"
                                 "~/Documents/GTD/reference.org"
                                 "~/Documents/GTD/trash.org"))
           (org-capture-templates . '(("t" "Todo [inbox]" entry
                                       (file+headline "~/Documents/GTD/inbox.org" "INBOX")
                                       "* TODO %i%?")
                                      ("n" "Note" entry
                                       (file+headline "~/Documents/GTD/note.org" "Notes")
                                       "* %i%?")))
           (org-refile-targets . '(("~/Documents/GTD/project.org" :level . 1)
                                   ("~/Documents/GTD/someday.org" :level . 1)
                                   ("~/Documents/GTD/reference.org" :level . 1)
                                   ("~/Documents/GTD/trash.org" :level . 1)))))

;; Other package settings

(leaf all-the-icons
  :doc "A library for inserting Developer icons"
  :req "emacs-24.3" "memoize-1.0.1"
  :tag "lisp" "convenient" "emacs>=24.3"
  :added "2020-10-28"
  :url "https://github.com/domtronn/all-the-icons.el"
  :emacs>= 24.3
  :ensure t
  :custom ((all-the-icons-scale-factor . 1.0)))

;;(leaf dracula-theme
;;  :doc "Dracula Theme"
;;  :req "emacs-24.3"
;;  :tag "emacs>=24.3"
;;  :added "2020-10-17"
;;  :url "https://github.com/dracula/emacs"
;;  :emacs>= 24.3
;;  :ensure t
;;  :config
;;  (load-theme 'dracula t))

(leaf doom-themes
  :doc "an opinionated pack of modern color-themes"
  :req "emacs-25.1" "cl-lib-0.5"
  :tag "nova" "faces" "icons" "neotree" "theme" "one" "atom" "blue" "light" "dark" "emacs>=25.1"
  :added "2020-10-28"
  :url "https://github.com/hlissner/emacs-doom-theme"
  :emacs>= 25.1
  :ensure t
  :config
  (load-theme 'doom-one t)
  (doom-themes-neotree-config))

(leaf doom-modeline
  :doc "A minimal and modern mode-line"
  :req "emacs-25.1" "all-the-icons-2.2.0" "shrink-path-0.2.0" "dash-2.11.0"
  :tag "mode-line" "faces" "emacs>=25.1"
  :added "2020-10-28"
  :url "https://github.com/seagle0128/doom-modeline"
  :emacs>= 25.1
  :ensure t
  :config
  (doom-modeline-mode 1))

(leaf mozc
  :doc "minor mode to input Japanese with Mozc"
  :tag "input method" "multilingual" "mule"
  :added "2020-09-30"
  :ensure t
  :custom ((default-input-method . "japanese-mozc")))

(leaf which-key
  :doc "Display available keybindings in popup"
  :req "emacs-24.4"
  :tag "emacs>=24.4"
  :added "2020-08-28"
  :url "https://github.com/justbur/emacs-which-key"
  :emacs>= 24.4
  :ensure t
  :custom ((which-key-show-early-on-C-h . t))
  :global-minor-mode t)

(leaf undo-tree
  :doc "Treat undo history as a tree"
  :tag "tree" "history" "redo" "undo" "files" "convenience"
  :added "2020-09-29"
  :url "http://www.dr-qubit.org/emacs.php"
  :ensure t
  :global-minor-mode global-undo-tree-mode)

(leaf ivy
  :doc "Incremental Vertical completYon"
  :req "emacs-24.5"
  :tag "matching" "emacs>=24.5"
  :added "2020-08-28"
  :url "https://github.com/abo-abo/swiper"
  :emacs>= 24.5
  :ensure t
  :blackout t
  :leaf-defer nil
  :bind (("C-c v" . ivy-push-view)
         ("C-c V" . ivy-pop-view)
         ("C-c C-r" . ivy-resume))
  :custom ((ivy-use-virtual-buffers . t)
           (enable-recursive-minibuffers . t)
           (minibuffer-depth-indicate-mode . 1)
           (ivy-initial-inputs-alist . nil)
           (ivy-re-builders-alist . '((t . ivy--regex-fuzzy)
                                      (swiper . ivy--regex-plus)))
           (ivy-use-selectable-prompt . t))
  :global-minor-mode t
  :config
  (leaf swiper
    :doc "Isearch with an overview. Oh, man!"
    :req "emacs-24.5" "ivy-0.13.0"
    :tag "matching" "emacs>=24.5"
    :added "2020-08-28"
    :url "https://github.com/abo-abo/swiper"
    :emacs>= 24.5
    :ensure t
    :bind (("C-s" . swiper-isearch))
    :config
    (leaf counsel
      :doc "Various completion functions using Ivy"
      :req "emacs-24.5" "swiper-0.13.0"
      :tag "tools" "matching" "convenience" "emacs>=24.5"
      :added "2020-08-28"
      :url "https://github.com/abo-abo/swiper"
      :emacs>= 24.5
      :ensure t
      :blackout t
      :bind (("M-y" . counsel-yank-pop)
             ("C-c f" . counsel-fzf)
             ("C-c g" . counsel-rg)
             ("C-c F" . counsel-git)
             ("C-c G" . counsel-git-grep)
             ("C-c i" . counsel-imenu)
             ("C-c r" . counsel-recentf)
             ("C-c b" . counsel-bookmark)
             ("C-c d" . counsel-descbinds))
      :custom `((ivy-count-format . "(%d/%d) ")
                (counsel-yank-pop-separator . "\n----------\n")
                (counsel-find-file-ignore-regexp . ,(rx-to-string '(or "./" "../") 'no-group)))
      :global-minor-mode t)))

(leaf ivy-rich
  :doc "More friendly display transformer for ivy."
  :req "emacs-24.5" "ivy-0.8.0"
  :tag "ivy" "emacs>=24.5"
  :added "2020-08-28"
  :url "https://github.com/Yevgnen/ivy-rich"
  :emacs>= 24.5
  :ensure t
  :after ivy
  :custom ((ivy-rich-path-style . 'abbrev))
  :global-minor-mode t)

(leaf prescient
  :doc "Better sorting and filtering"
  :req "emacs-25.1"
  :tag "matching" "convenience" "abbrev" "emacs>=24.3"
  :added "2020-08-28"
  :url "https://github.com/raxod502/prescient.el"
  :emacs>= 25.1
  :ensure t
  :commands (prescient-persist-mode)
  :custom `((prescient-aggressive-file-save . t)
            (prescient-save-file . ,(locate-user-emacs-file "prescient")))
  :global-minor-mode prescient-persist-mode)

(leaf ivy-prescient
  :doc "prescient.el + Ivy"
  :req "emacs-25.1" "prescient-4.0" "ivy-0.11.0"
  :tag "matching" "convenience" "abbrev" "emacs>=24.3"
  :added "2020-08-28"
  :url "https://github.com/raxod502/prescient.el"
  :emacs>= 25.1
  :ensure t
  :after prescient ivy
  :custom ((ivy-prescient-retain-classic-highlighting . t))
  :global-minor-mode t)

(leaf flycheck
  :doc "On-the-fly syntax checking"
  :req "dash-2.12.1" "pkg-info-0.4" "let-alist-1.0.4" "seq-1.11" "emacs-24.3"
  :tag "matching" "convenience" "abbrev" "emacs>=24.3"
  :added "2020-08-28"
  :url "http://www.flycheck.org"
  :emacs>= 24.3
  :ensure t
  :bind (("M-n" . flycheck-next-error)
         ("M-p" . flycheck-previous-error))
  :global-minor-mode global-flycheck-mode)

(leaf company
  :doc "Modular text completion framework"
  :req "emacs-24.3"
  :tag "matching" "convenience" "abbrev" "emacs>=24.3"
  :added "2020-08-28"
  :url "http://company-mode.github.io/"
  :emacs>= 24.3
  :ensure t
  :blackout t
  :leaf-defer nil
  :bind ((company-active-map
          ("M-n" . nil)
          ("M-p" . nil)
          ("C-n" . company-select-next)
          ("C-p" . company-select-previous)
          ("<tab>" . company-complete-selection)
          ("C-s" . company-filter-candidates))
         (company-search-map
          ("C-n" . company-select-next)
          ("C-p" . company-select-previous)))
  :custom ((company-idle-delay . 0)
           (company-selection-wrap-around . t)
           (company-minimum-prefix-length . 1)
           (company-transformers . '(company-sort-by-occurrence)))
  :global-minor-mode global-company-mode)

(leaf company-c-headers
  :doc "Company mode backend for C/C++ header files"
  :req "emacs-24.1" "company-0.8"
  :tag "company" "development" "emacs>=24.1"
  :added "2020-08-28"
  :emacs>= 24.1
  :ensure t
  :after company
  :defvar company-backends
  :config
  (add-to-list 'company-backends 'company-c-headers))

(leaf yasnippet
  :doc "Yet another snippet extension for Emacs"
  :req "cl-lib-0.5"
  :tag "emulation" "convenience"
  :added "2020-08-28"
  :url "http://github.com/joaotavora/yasnippet"
  :ensure t
  :global-minor-mode yas-global-mode)

(leaf yasnippet-snippets
  :doc "Collection of yasnippet snippets"
  :req "yasnippet-0.8.0" "s-1.12.0"
  :tag "snippets"
  :added "2020-08-28"
  :ensure t
  :after yasnippet)

(leaf projectile
  :doc "Manage and navigate projects in Emacs easily"
  :req "emacs-25.1" "pkg-info-0.4"
  :tag "convenience" "project" "emacs>=25.1"
  :added "2020-09-30"
  :url "https://github.com/bbatsov/projectile"
  :emacs>= 25.1
  :ensure t
  :bind ((projectile-mode-map
          ("s-p" . projectile-command-map)
          ("C-c p" . projectile-command-map)
          ("C-c p g" . my-customize-projectile-counsel-git-grep)))
  :custom ((projectile-mode . +1)
           (projectile-completion-system . 'ivy)))

(leaf magit
  :doc "A Git porcelain inside Emacs."
  :req "emacs-25.1" "async-20200113" "dash-20200524" "git-commit-20200516" "transient-20200601" "with-editor-20200522"
  :tag "vc" "tools" "git" "emacs>=25.1"
  :added "2020-09-02"
  :emacs>= 25.1
  :ensure t
  :bind (("C-x g" . magit-status)))

(leaf paredit
  :doc "minor mode for editing parentheses"
  :tag "lisp"
  :added "2020-08-28"
  :ensure t)

(leaf geiser
  :doc "GNU Emacs and Scheme talk to each other"
  :added "2020-08-28"
  :url "http://www.nongnu.org/geiser/"
  :ensure t)

(leaf lisp-mode
  :doc "Lisp mode, and its idiosyncratic commands"
  :tag "builtin" "languages" "lisp"
  :added "2020-08-28"
  :commands enable-paredit-mode
  :hook ((emacs-lisp-mode-hook . enable-paredit-mode)
         (eval-expression-minibuffer-setup-hook . enable-paredit-mode)
         (ielm-mode-hook . enable-paredit-mode)
         (lisp-mode-hook . enable-paredit-mode)
         (lisp-interaction-mode-hook . enable-paredit-mode)
         (scheme-mode-hook . enable-paredit-mode)))

(leaf lsp-mode
  :doc "LSP mode"
  :req "emacs-26.1" "dash-2.14.1" "dash-functional-2.14.1" "f-0.20.0" "ht-2.0" "spinner-1.7.3" "markdown-mode-2.3" "lv-0"
  :tag "languages" "emacs>=26.1"
  :added "2020-08-28"
  :url "https://github.com/emacs-lsp/lsp-mode"
  :emacs>= 26.1
  :ensure t
  :hook ((lsp-mode-hook . lsp-enable-which-key-integration)
         (go-mode-hook . lsp-deferred))
  :custom (lsp-keymap-prefix . "C-c l"))

(leaf lsp-ui
  :doc "UI modules for lsp-mode"
  :req "emacs-26.1" "dash-2.14" "dash-functional-1.2.0" "lsp-mode-6.0" "markdown-mode-2.3"
  :tag "tools" "languages" "emacs>=26.1"
  :added "2020-08-28"
  :url "https://github.com/emacs-lsp/lsp-ui"
  :emacs>= 26.1
  :ensure t
  :after lsp-mode
  :custom ((lsp-ui-doc-position . 'at-point)))

(leaf lsp-ivy
  :doc "LSP ivy integration"
  :req "emacs-25.1" "dash-2.14.1" "lsp-mode-6.2.1" "ivy-0.13.0"
  :tag "debug" "languages" "emacs>=25.1"
  :added "2020-08-28"
  :url "https://github.com/emacs-lsp/lsp-ivy"
  :emacs>= 25.1
  :ensure t
  :after lsp-mode)

(leaf go-mode
  :doc "Major mode for the Go programming language"
  :tag "go" "languages"
  :added "2020-08-28"
  :url "https://github.com/dominikh/go-mode.el"
  :ensure t
  :hook ((before-save-hook . gofmt-before-save))
  :setq ((company-backends '(company-capf))
         (gofmt-command . "goimports")))

(leaf yaml-mode
  :doc "Major mode for editing YAML files"
  :req "emacs-24.1"
  :tag "yaml" "data" "emacs>=24.1"
  :added "2020-09-10"
  :emacs>= 24.1
  :ensure t)

(leaf web-mode
  :doc "major mode for editing web templates"
  :req "emacs-23.1"
  :tag "languages" "emacs>=23.1"
  :added "2020-10-01"
  :url "http://web-mode.org"
  :emacs>= 23.1
  :ensure t
  :config
  (add-to-list 'auto-mode-alist '("\\.vue\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.js\\'" . web-mode)))

(leaf js2-mode
  :doc "Improved JavaScript editing mode"
  :req "emacs-24.1" "cl-lib-0.5"
  :tag "javascript" "languages" "emacs>=24.1"
  :added "2020-10-06"
  :url "https://github.com/mooz/js2-mode/"
  :emacs>= 24.1
  :ensure t)

(leaf docker
  :doc "Emacs interface to Docker"
  :req "dash-2.14.1" "docker-tramp-0.1" "emacs-24.5" "json-mode-1.7.0" "s-1.12.0" "tablist-0.70" "transient-0.2.0"
  :tag "convenience" "filename" "emacs>=24.5"
  :added "2020-10-09"
  :url "https://github.com/Silex/docker.el"
  :emacs>= 24.5
  :ensure t)

(leaf protobuf-mode
  :doc "major mode for editing protocol buffers."
  :tag "languages" "protobuf" "google"
  :added "2020-10-13"
  :ensure t)

(leaf google-translate
  :doc "Emacs interface to Google Translate."
  :added "2020-10-04"
  :ensure t
  :bind (("C-c t" . google-translate-at-point)
         ("C-c T" . google-translate-query-translate))
  :custom ((google-translate-default-source-language . "auto")
           (google-translate-default-target-language . "ja")
           (google-translate-output-destination . 'nil)
           (google-translate-show-phonetic . t))
  :config
  (leaf google-translate-default-ui
    :doc "default UI for Google Translate"
    :tag "out-of-MELPA" "convenience"
    :added "2020-10-04"
    :url "https://github.com/atykhonov/google-translate"
    :require t))

(leaf popup
  :doc "Visual Popup User Interface"
  :req "cl-lib-0.5"
  :tag "lisp"
  :added "2020-10-04"
  :ensure t)

(leaf my-customize
  :tag "out-of-MELPA"
  :added "2020-10-17"
  :el-get tsukest/my-customize.el
  :require t
  :bind (("M-!" . my-customize-select-shell)))

(provide 'init)

;;; init.el ends here
