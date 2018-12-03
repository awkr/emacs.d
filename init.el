(require 'package)
(setq package-enable-at-startup nil)
(setq package-archives '(("org"   . "http://orgmode.org/elpa/")
                         ("gnu"   . "http://elpa.gnu.org/packages/")
                         ("melpa" . "https://melpa.org/packages/")))
(package-initialize)

(exec-path-from-shell-initialize)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
	(go-direx go-eldoc rust-mode protobuf-mode docker docker-compose-mode yahoo-weather 2048-game go-guru company-go smartparens rainbow-delimiters yaml-mode markdown-mode hl-todo magit avy dired-sidebar dired-narrow dired-collapse which-key crux ag smex company delight counsel)))
 '(scroll-bar-mode nil)
 '(tool-bar-mode nil)
 '(tooltip-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(setq-default require-final-newline t
			  scroll-conservatively 101
			  make-cursor-line-fully-visible nil
              scroll-margin 3
              x-stretch-cursor t
			  x-select-enable-clipboard t
			  Select-enable-clipboard t
              mouse-drag-copy-region t
              tab-width 4                            
              kill-ring-max 100
              make-backup-files t
              delete-old-versions t
              delete-by-moving-to-trash t
              backup-directory-alist '(("" . "~/.emacs.d/backup"))
              line-move-visual t
              make-pointer-invisible t
              read-file-name-completion-ignore-case t
              mac-option-modifier 'meta
			  ;; mac-allow-anti-aliasing nil
              default-directory "~"
              inhibit-startup-message t
              inhibit-startup-echo-area-message t
              initial-scratch-message nil
              tooltip-use-echo-area t
              load-prefer-newer t
              delete-selection-mode t
              ring-bell-function 'ignore
              visible-bell t
              view-read-only t
			  visible-bell t
              view-read-only t
              indicate-empty-lines t
              use-dialog-box nil ;; avoid gui
			  menu-bar-mode nil
              )

(require 'server)
(unless (server-running-p)
  (server-start))

(require 'visual-regexp)
(define-key global-map (kbd "C-c r") 'vr/replace)
(define-key global-map (kbd "C-c q") 'vr/query-replace)
(define-key global-map (kbd "C-c m") 'vr/mc-mark)

(add-hook 'protobuf-mode-hook (lambda ()
						   (company-mode)
						   (smartparens-mode)))

(add-hook 'go-mode-hook (lambda ()
						  (company-mode)
						  (go-eldoc-setup)
						  (local-set-key (kbd "M-." 'godef-jump)
						  (local-set-key (kbd "C-c d") 'godoc)
						  (local-set-key (kbd "C-c i") 'go-goto-imports)
						  (local-set-key (kbd "C-c C-r") 'go-remove-unused-imports)
						  (set (make-local-variable 'company-backends) '(company-go))
                          (add-hook 'before-save-hook 'gofmt-before-save nil t)))

(use-package ivy
  :ensure t
  :delight
  :init
  (ivy-mode 1)
  :config
  (setq ivy-initial-inputs-alist nil)
  (setq ivy-count-format "%d/%d ")
  (setq ivy-height 10)
  :bind
  ("C-s" . swiper))

(use-package counsel
  :ensure t
  :delight
  :bind
  (("M-y" . counsel-yank-pop)
   ("M-x" . counsel-M-x)
   ("C-x C-f" . 'counsel-find-file)
   ("C-x f" . 'counsel-file-jump)
   ("C-x r b" . 'counsel-bookmark)
   :map ivy-minibuffer-map
   ("M-y" . ivy-next-line))
  :config
  (setq counsel-find-file-ignore-regexp "\\.DS_Store\\|.git"))

(use-package company
  :defer t
  :delight
  :bind ("C-." . company-complete)
  :init (add-hook 'prog-mode-hook 'company-mode)
  :config
  (setq company-idle-delay 0.1
        company-minimum-prefix-length 1
        company-selection-wrap-around t
        company-show-numbers t
		company-require-match nil
        company-dabbrev-ignore-case nil
        company-dabbrev-downcase nil
        company-transformers '(company-sort-by-occurrence))
  (bind-keys :map company-active-map
             ("C-n" . company-select-next)
             ("C-p" . company-select-previous)
             ("C-d" . company-show-doc-buffer)
             ("<tab>" . company-complete)))

(global-unset-key (kbd "M-;"))
(global-set-key (kbd "M-;") 'comment-line)
(global-set-key (kbd "C-/") 'undo)
(global-set-key (kbd "C-q") 'save-buffers-kill-terminal)

(use-package hl-todo
  :ensure t
  :config
  (global-hl-todo-mode))

(use-package markdown-mode
  :ensure t)

(use-package yaml-mode
  :ensure t)

(use-package rainbow-delimiters
  :ensure t
  :init
  (add-hook 'prog-mode-hook 'rainbow-delimiters-mode)
  :config
  (setq rainbow-delimiters-max-face-count 1)
  (set-face-attribute 'rainbow-delimiters-unmatched-face nil
                      :foreground 'unspecified
                      :inherit 'error))

(use-package smartparens-config
  :ensure smartparens
  :config
  (show-smartparens-global-mode t)
  (add-hook 'prog-mode-hook 'turn-on-smartparens-mode)
  (add-hook 'docker-compose-mode 'turn-on-smartparens-mode)
  (add-hook 'markdown-mode-hook 'turn-on-smartparens-mode)
  :delight)

(use-package ag
  :ensure t
  :config
  (setq ag-highlight-search t)
  (setq ag-reuse-buffers t)
  (add-to-list 'ag-arguments "--word-regexp"))

(use-package crux
             :ensure t
             :bind (("C-a" . crux-move-beginning-of-line)
                    ("M--" . crux-kill-whole-line)))

(use-package which-key
  :ensure t
  :init
  :delight
  :config
  (which-key-mode))

(use-package dired
  :config
  (setq dired-dwim-target t)
  (require 'dired-x))

(use-package dired-narrow
  :ensure t
  :bind (:map dired-mode-map
              ("/" . dired-narrow)))

(use-package dired-sidebar
  :bind (("C-x C-n" . dired-sidebar-toggle-sidebar))
  :ensure t
  :commands (dired-sidebar-toggle-sidebar)
  :config
  (setq dired-sidebar-subtree-line-prefix " .")
  (cond
   (:default
    (setq dired-sidebar-theme 'ascii)
        (setq dired-sidebar-use-term-integration t)
	)))

(use-package dired-subtree
  :config
  (bind-keys :map dired-mode-map
             ("i" . dired-subtree-insert)
             (";" . dired-subtree-remove)))

(use-package dired-collapse
  :ensure t
  :commands (dired-collapse-mode)
  :init
  (add-hook 'dired-mode-hook #'dired-collapse-mode))

;; time
(setq display-time-24hr-format t)
(setq display-time-format "%H:%M")
(setq display-time-interval 60)
(setq display-time-default-load-average nil)
(setq display-time-mail-string "")
(display-time-mode 1)

(fset 'yes-or-no-p 'y-or-n-p)

;; (set-frame-font "-*-M+ 1m-normal-normal-normal-*-13-*-*-*-m-0-iso10646-1")
;; (set-frame-font "-apple-Dina-medium-normal-normal--16--*-*-m-0-iso10646-1")
(set-frame-font "-*-sf mono-normal-normal-normal--12--*-*-m-0-iso10646-1")

