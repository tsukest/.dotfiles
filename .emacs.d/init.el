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
  :bind (("M-ESC ESC" . c/redraw-frame))
  :custom '((user-full-name . "satake")
            (user-mail-address . "satake.ts@gmail.com")
            (user-login-name . "satake")
            (gc-cons-threshold . 134217728) ;;(* 128 1024 1024)
            (read-process-output-max . 3145728) ;;(* 3 1024 1024)
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
            (menu-bar-mode . nil)
            (tool-bar-mode . nil)
            (scroll-bar-mode . nil)
            (indent-tabs-mode . nil)
            (next-screen-context-lines . 10)
            (tab-width . 4))
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
                    (cons "Ricty" "iso10646-1"))
  (setenv "GIT_PAGER" ""))

(eval-and-compile
  (leaf bytecomp
    :doc "compilation of Lisp code into byte code"
    :tag "builtin" "lisp"
    :custom (byte-compile-warnings . '(cl-functions))))

(leaf face-remap
  :doc "Functions for managing `face-remapping-alist'"
  :tag "builtin"
  :added "2020-11-13"
  :bind ("<f5>" . hydra-zoom/body)
  :hydra (hydra-zoom ()
                     "zoom"
                     ("i" text-scale-increase "in")
                     ("o" text-scale-decrease "out")))

(leaf window
  :doc "GNU Emacs window commands aside from those written in C"
  :tag "builtin" "internal"
  :added "2020-11-13"
  :bind ("<f6>" . hydra-window-size/body)
  :hydra (hydra-window-size ()
                            "window"
                            ("^" enlarge-window "enlarge vertically")
                            ("{" shrink-window-horizontally "shrink horizontally")
                            ("}" enlarge-window-horizontally "enlarge horizontally")))

(leaf tab-bar
  :doc "frame-local tabs with named persistent window configurations"
  :tag "builtin"
  :added "2020-12-02"
  :global-minor-mode t
  :custom ((tab-bar-new-button-show . nil)
           (tab-bar-close-button-show . nil)
           (tab-bar-tab-name-function . #'tab-bar-tab-name-current-with-count)))

(leaf hl-line
  :doc "highlight the current line"
  :tag "builtin"
  :added "2020-11-24"
  :global-minor-mode global-hl-line-mode)

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
  :global-minor-mode global-display-line-numbers-mode
  :config
  (defcustom display-line-numbers-exempt-modes '(vterm-mode eshell-mode shell-mode term-mode ansi-term-mode dired-mode lsp-ui-imenu-mode)
    "Major modes on which to disable the linum mode, exempts them from global requirement"
    :group 'display-line-numbers
    :type 'list
    :version "green")
  (defun display-line-numbers--turn-on ()
    "turn on line numbers but excempting certain majore modes defined in `display-line-numbers-exempt-modes'"
    (if (and
         (not (member major-mode display-line-numbers-exempt-modes))
         (not (minibufferp)))
        (display-line-numbers-mode))))

(leaf time
  :doc "display time, load and mail indicator in mode line of Emacs"
  :tag "builtin"
  :added "2020-10-23"
  :global-minor-mode display-time-mode
  :custom ((display-time-day-and-date . t)
           (display-time-24hr-format . t)
           (display-time-mail-file . 'none)
           (display-time-load-average-threshold . 1.0)
           (frame-title-format . '("" display-time-string " ")))
  :config
  (delq 'display-time-string global-mode-string))

(leaf dired
  :doc "directory-browsing commands"
  :tag "builtin" "files"
  :added "2020-10-30"
  :url "https://github.com/Fuco1/dired-hacks/"
  :bind (dired-mode-map
         ("i" . dired-subtree-insert)
         ("r" . dired-subtree-remove)
         ("TAB" . dired-subtree-toggle)
         ("C-M-u" . dired-subtree-up)
         ("C-M-d" . dired-subtree-down)
         ("C-M-n" . dired-subtree-next-sibling)
         ("C-M-p" . dired-subtree-previous-sibling)))

(leaf dired-subtree
  :doc "Insert subdirectories in a tree-like fashion"
  :req "dash-2.5.0" "dired-hacks-utils-0.0.1"
  :tag "files"
  :added "2020-10-30"
  :ensure t)

(leaf ediff
  :doc "a comprehensive visual interface to diff & patch"
  :tag "builtin"
  :added "2020-10-31"
  :custom ((ediff-window-setup-function . 'ediff-setup-windows-plain)))

(leaf shell
  :doc "specialized comint.el for running the shell"
  :tag "builtin"
  :added "2020-11-09"
  :bind (shell-mode-map
         ("C-c C-l" . counsel-shell-history))
  :hook ((shell-mode-hook . (lambda () (company-mode -1))))
  :config
  (add-to-list 'display-buffer-alist '("^\\*shell\\*$" . (display-buffer-same-window))))

(leaf eshell
  :doc "the Emacs command shell"
  :tag "builtin"
  :added "2020-11-09"
  :hook ((eshell-mode-hook . (lambda ()
                               (define-key eshell-mode-map (kbd "C-c C-l") #'counsel-esh-history))))
  :custom ((eshell-history-size . 10000)
           (eshell-hist-ignoredups . t))
  :config
  (setq eshell-modules-list (delq 'eshell-ls (delq 'eshell-unix eshell-modules-list))))

(leaf browse-url
  :doc "pass a URL to a WWW browser"
  :tag "builtin"
  :added "2020-10-24"
  :custom ((browse-url-browser-function . eww-browse-url)))

(leaf org
  :doc "Export Framework for Org Mode"
  :tag "builtin"
  :added "2020-10-17"
  :bind (("C-c c" . org-capture))
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

(leaf vc
  :doc "drive a version-control system from within Emacs"
  :tag "builtin"
  :added "2021-01-27"
  :custom ((vc-handled-backends . '(Git))))

(leaf gnus
  :doc "Identifying spam"
  :tag "builtin"
  :added "2020-12-01"
  :custom ((gnus-home-directory . "~/gnus")))

(leaf misc
  :doc "some nonstandard editing and utility commands for Emacs"
  :tag "builtin" "convenience"
  :added "2020-11-20"
  :bind (;("M-f" . forward-to-word)
         ;("M-b" . backward-to-word)
         ))

;; Other package settings

(leaf all-the-icons
  :doc "A library for inserting Developer icons"
  :req "emacs-24.3" "memoize-1.0.1"
  :tag "lisp" "convenient" "emacs>=24.3"
  :added "2020-10-28"
  :url "https://github.com/domtronn/all-the-icons.el"
  :emacs>= 24.3
  :ensure t
  :custom ((all-the-icons-scale-factor . 0.9)))

(leaf doom-themes
  :doc "an opinionated pack of modern color-themes"
  :req "emacs-25.1" "cl-lib-0.5"
  :tag "nova" "faces" "icons" "neotree" "theme" "one" "atom" "blue" "light" "dark" "emacs>=25.1"
  :added "2020-10-28"
  :url "https://github.com/hlissner/emacs-doom-theme"
  :emacs>= 25.1
  :ensure t
  :custom-face
  (tab-bar . '((t (:background "#282a36"))))
  (tab-bar-tab . '((t (:background "#1E2029"))))
  (tab-bar-tab-inactive . '((t (:foreground "#6272a4" :background "#282a36"))))
  :config
  (load-theme 'doom-dracula t)
  (doom-themes-org-config))

(leaf doom-modeline
  :doc "A minimal and modern mode-line"
  :req "emacs-25.1" "all-the-icons-2.2.0" "shrink-path-0.2.0" "dash-2.11.0"
  :tag "mode-line" "faces" "emacs>=25.1"
  :added "2020-10-28"
  :url "https://github.com/seagle0128/doom-modeline"
  :emacs>= 25.1
  :ensure t
  :custom ((doom-modeline-project-detection . 'projectile)
           (doom-modeline-buffer-file-name-style . 'truncate-with-project)
           (doom-modeline-indent-info . t)
           (doom-modeline-vcs-max-length . 18))
  :global-minor-mode t)

(leaf mozc
  :doc "minor mode to input Japanese with Mozc"
  :tag "input method" "multilingual" "mule"
  :added "2020-09-30"
  :ensure t
  :custom ((default-input-method . "japanese-mozc-im")
           (mozc-candidate-style . 'echo-area))
  :config
  (leaf mozc-im
    :ensure t
    :require t))

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
    :bind (("C-S-s" . swiper-isearch))
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
             ("C-c f" . my-find-interactive)
             ("C-c g" . my-grep-interactive)
             ("C-c F" . counsel-fzf)
             ("C-c G" . counsel-rg)
             ("C-c i" . counsel-imenu)
             ("C-c r" . counsel-recentf)
             ("C-c b" . counsel-bookmark)
             ("C-c d" . counsel-descbinds))
      :custom `((ivy-count-format . "(%d/%d) ")
                (counsel-yank-pop-preselect-last . t)
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
  :custom ((ivy-rich-path-style . 'abbrev)
           (ivy-rich-project-root-cache-mode . t))
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
          ("C-c p g" . my-projectile-counsel-git-grep)
          ("C-c p G" . my-projectile-vc)))
  :custom ((projectile-mode . +1)
           (projectile-completion-system . 'ivy)
           (projectile-switch-project-action . 'projectile-dired)))

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
  :bind (lsp-mode-map
         ("C-c l" . hydra-lsp/body))
  :hydra (hydra-lsp (:exit t :hint nil)
                    "
 Buffer^^               Server^^                   Symbol
-------------------------------------------------------------------------------------
 [_f_] format           [_M-r_] restart            [_d_] declaration  [_i_] implementation  [_o_] documentation
 [_m_] imenu            [_S_]   shutdown           [_D_] definition   [_t_] type            [_r_] rename
 [_x_] execute action   [_M-s_] describe session   [_R_] references   [_s_] signature"
                    ("d" lsp-find-declaration)
                    ("D" lsp-ui-peek-find-definitions)
                    ("R" lsp-ui-peek-find-references)
                    ("i" lsp-ui-peek-find-implementation)
                    ("t" lsp-find-type-definition)
                    ("s" lsp-signature-help)
                    ("o" lsp-describe-thing-at-point)
                    ("r" lsp-rename)

                    ("f" lsp-format-buffer)
                    ("m" lsp-ui-imenu)
                    ("x" lsp-execute-code-action)

                    ("M-s" lsp-describe-session)
                    ("M-r" lsp-restart-workspace)
                    ("S" lsp-shutdown-workspace))
  :hook ((lsp-mode-hook . lsp-enable-which-key-integration)
         (lsp-managed-hook . (lambda () (setq-local company-backends '(company-capf))))
         (go-mode-hook . lsp-deferred))
  :custom ((lsp-file-watch-threshold . 10000)))

(leaf lsp-ui
  :doc "UI modules for lsp-mode"
  :req "emacs-26.1" "dash-2.14" "dash-functional-1.2.0" "lsp-mode-6.0" "markdown-mode-2.3"
  :tag "tools" "languages" "emacs>=26.1"
  :added "2020-08-28"
  :url "https://github.com/emacs-lsp/lsp-ui"
  :emacs>= 26.1
  :ensure t
  :after lsp-mode
  :custom ((lsp-ui-doc-position . 'top)
           (lsp-ui-doc-delay . 0.5)))

(leaf lsp-ivy
  :doc "LSP ivy integration"
  :req "emacs-25.1" "dash-2.14.1" "lsp-mode-6.2.1" "ivy-0.13.0"
  :tag "debug" "languages" "emacs>=25.1"
  :added "2020-08-28"
  :url "https://github.com/emacs-lsp/lsp-ivy"
  :emacs>= 25.1
  :ensure t
  :after lsp-mode)

(leaf ccls
  :doc "ccls client for lsp-mode"
  :req "emacs-25.1" "lsp-mode-6.3.1" "dash-2.14.1"
  :tag "c++" "lsp" "languages" "emacs>=25.1"
  :added "2021-02-11"
  :url "https://github.com/MaskRay/emacs-ccls"
  :emacs>= 25.1
  :ensure t
  :custom ((ccls-executable . "~/.guix-profile/bin/ccls"))
  :hook ((c-mode-hook . (lambda () (require 'ccls) (lsp)))
         (c++-mode-hook . (lambda () (require 'ccls) (lsp)))))

(leaf lsp-python-ms
  :doc "The lsp-mode client for Microsoft python-language-server"
  :req "emacs-25.1" "lsp-mode-6.1"
  :tag "tools" "languages" "emacs>=25.1"
  :added "2020-12-22"
  :url "https://github.com/emacs-lsp/lsp-python-ms"
  :emacs>= 25.1
  :ensure t
  :init (setq lsp-python-ms-auto-install-server t)
  :hook ((python-mode-hook . (lambda ()
                               (require 'lsp-python-ms)
                               (lsp)))))

(leaf dap-mode
  :after lsp-mode
  :ensure t
  :hook (dap-stopped . (lambda (arg) (call-interactively #'dap-hydra)))
  :config
  (require 'dap-ui)
  (require 'dap-hydra)
  (require 'dap-go))

(leaf markdown-mode
  :doc "Major mode for Markdown-formatted text"
  :req "emacs-25.1"
  :tag "itex" "github flavored markdown" "markdown" "emacs>=25.1"
  :added "2020-11-17"
  :url "https://jblevins.org/projects/markdown-mode/"
  :emacs>= 25.1
  :ensure t
  :bind (markdown-mode-map
         ("C-c m" . hydra-markdown-mode/body))
  :hydra (hydra-markdown-mode (:exit t :hint nil) "
Formatting        C-c C-s    _s_: bold          _e_: italic     _b_: blockquote   _p_: pre-formatted    _c_: code
Headings          C-c C-t    _h_: automatic     _1_: h1         _2_: h2           _3_: h3               _4_: h4
Lists             C-c C-x    _m_: insert item   
Demote/Promote    C-c C-x    _l_: promote       _r_: demote     _u_: move up      _d_: move down
Links, footnotes  C-c C-a    _L_: link          _U_: uri        _F_: footnote     _W_: wiki-link      _R_: reference"
                                 ("s" markdown-insert-bold)
                                 ("e" markdown-insert-italic)
                                 ("b" markdown-insert-blockquote :color blue)
                                 ("p" markdown-insert-pre :color blue)
                                 ("c" markdown-insert-code)
                                 ("h" markdown-insert-header-dwim) 
                                 ("1" markdown-insert-header-atx-1)
                                 ("2" markdown-insert-header-atx-2)
                                 ("3" markdown-insert-header-atx-3)
                                 ("4" markdown-insert-header-atx-4)
                                 ("m" markdown-insert-list-item)
                                 ("l" markdown-promote)
                                 ("r" markdown-demote)
                                 ("d" markdown-move-down)
                                 ("u" markdown-move-up)  
                                 ("L" markdown-insert-link :color blue)
                                 ("U" markdown-insert-uri :color blue)
                                 ("F" markdown-insert-footnote :color blue)
                                 ("W" markdown-insert-wiki-link :color blue)
                                 ("R" markdown-insert-reference-link-dwim :color blue)))

(leaf go-mode
  :doc "Major mode for the Go programming language"
  :tag "go" "languages"
  :added "2020-08-28"
  :url "https://github.com/dominikh/go-mode.el"
  :ensure t
  :hook ((before-save-hook . gofmt-before-save))
  :setq ((gofmt-command . "goimports")))

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
  :bind (("C-c t" . google-translate-at-point))
  :custom ((google-translate-default-source-language . "auto")
           (google-translate-default-target-language . "ja")
           (google-translate-output-destination . 'echo-area)
           (google-translate-show-phonetic . nil))
  :config
  (leaf google-translate-default-ui
    :doc "default UI for Google Translate"
    :tag "out-of-MELPA" "convenience"
    :added "2020-10-04"
    :url "https://github.com/atykhonov/google-translate"
    :require t)
  (defun google-translate--search-tkk () (list 430675 2721866130)))

(leaf popup
  :doc "Visual Popup User Interface"
  :req "cl-lib-0.5"
  :tag "lisp"
  :added "2020-10-04"
  :ensure t)

(leaf twittering-mode
  :doc "Major mode for Twitter"
  :tag "web" "twitter"
  :added "2020-10-24"
  :url "http://twmode.sf.net/"
  :ensure t
  :custom ((twittering-icon-mode . t)))

(leaf my-customize
  :tag "out-of-MELPA"
  :added "2020-10-17"
  :el-get tsukest/my-customize.el
  :require t
  :bind (("M-!" . my-select-shell)
         ("C-x M-o" . my-other-window-1)))

(provide 'init)

;;; init.el ends here
