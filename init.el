;;; init.el --- Personal Emacs Config

;;; Commentary:

;; Intelligent C++ autocomplete added to Emacs!
;;
;;  - Completion window can be prought up with C-\
;;
;;  - Code can be automatically formatted with clang-format (C-f)
;;    The format guidelines can be changed on a per-project basis.
;;    See: https://zed0.co.uk/clang-format-configurator/
;;
;;  - Warnings/errors/language standard can be changed by specifying a
;;    .clang_complete file on a per-project or computer basis.
;;    See: https://github.com/Rip-Rip/clang_complete
;;
;; Questions, comments or concerns? Contact Will Killian (willkill07)


;;; Code:

(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)
(package-initialize)

(if (not (package-installed-p 'use-package))
    (progn
      (package-refresh-contents)
      (package-install 'use-package)))
(eval-when-compile
  (require 'use-package))

(use-package diminish
  :ensure t)

;; Startup
(setq inhibit-startup-screen t)
(defalias 'yes-or-no-p 'y-or-n-p)

;; GUI Interface
(if window-system
    (progn
      (menu-bar-mode 1)
      (tool-bar-mode 1)
      (scroll-bar-mode 1)))

;; Modeline
(diminish 'abbrev-mode)
(column-number-mode 1)
(line-number-mode 1)

;; Editor
(show-paren-mode 1)
(electric-indent-mode 1)
(delete-selection-mode 1)

;; Scrolling
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1)))
(setq mouse-wheel-progressive-speed nil)
(setq mouse-wheel-follow-mouse 't)
(setq scroll-step 1)

;; Tab and whitespace hell
(setq-default indent-tabs-mode nil)
(defun untabify-except-makefiles ()
  "Replace tabs with spaces except in makefiles."
  (unless (derived-mode-p 'makefile-mode)
    (untabify (point-min) (point-max))))

(add-hook 'before-save-hook 'delete-trailing-whitespace)
(add-hook 'before-save-hook 'untabify-except-makefiles)

;; Package loading
(use-package exec-path-from-shell
  :ensure t
  :config
  (exec-path-from-shell-initialize))

(use-package smooth-scrolling
  :ensure t
  :config
  (setq smooth-scroll-margin 8)
  (smooth-scrolling-mode))

(use-package monokai-theme
  :ensure t
  :config (load-theme 'monokai t))

(use-package rainbow-delimiters
  :ensure t
  :diminish rainbow-delimiters-mode
  :init (add-hook 'prog-mode-hook 'rainbow-delimiters-mode))

(use-package rainbow-identifiers
  :ensure t
  :diminish rainbow-identifiers-mode
  :init (add-hook 'prog-mode-hook 'rainbow-identifiers-mode))

(use-package git-gutter
  :ensure t
  :diminish git-gutter-mode
  :init (add-hook 'prog-mode-hook 'linum-mode)
  :config
  (git-gutter:linum-setup)
  (global-git-gutter-mode))

(use-package tramp
  :config
  (setq tramp-verbose        9
        tramp-default-method "ssh"
        tramp-ssh-controlmaster-options
        (concat "-o ControlPath=/tmp/tramp.%%r@%%h:%%p "
                "-o ControlMaster=auto "
                "-o ControlPersist=no")))

(use-package gitconfig-mode
  :ensure t
  :mode ("/\\.gitconfig\\'" "/\\.git/config\\'" "/git/config\\'" "/\\.gitmodules\\'"))

(use-package gitignore-mode
  :ensure t
  :mode ("/\\.gitignore\\'" "/\\.git/info/exclude\\'" "/git/ignore\\'"))

(use-package cmake-mode
  :ensure t
  :mode ("CMakeLists\\.txt\\'" "\\.cmake\\'"))

(use-package modern-cpp-font-lock
  :ensure t
  :diminish modern-c++-font-lock-mode
  :init (add-hook 'c++-mode-hook 'modern-c++-font-lock-mode))

(use-package company
  :ensure t
  :defer 2
  :diminish company-mode "C "
  :config
  (setq company-backends (delete 'company-clang company-backends))
  (global-company-mode)
  :bind ("C-\\" . company-complete-common))

(use-package flycheck
  :ensure t
  :diminish flycheck-mode "F "
  :config
  (global-flycheck-mode)
  (setq-default flycheck-disabled-checkers '(c/c++-clang)))

(use-package irony
  :ensure t
  :after company
  :diminish irony-mode "I "
  :init
  (add-hook 'c-mode-hook 'irony-mode)
  (add-hook 'c++-mode-hook 'irony-mode)
  :config
  (progn
    (defun my-irony-mode-hook ()
      (define-key irony-mode-map [remap completion-at-point] 'irony-completion-at-point-async)
      (define-key irony-mode-map [remap complete-symbol] 'irony-completion-at-point-async))
    (add-hook 'irony-mode-hook 'my-irony-mode-hook)
    (add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)

    (add-hook 'c-mode-hook
              (lambda()
                (setq irony-additional-clang-options
                      (quote ("-Wall" "-Wextra")))))
    (add-hook 'c++-mode-hook
              (lambda()
                (setq irony-additional-clang-options
                      (quote ("-std=c++14" "-Wall" "-Wextra" "-pedantic-errors")))))))

(use-package company-irony
  :ensure t
  :after company)

(use-package company-irony-c-headers
  :ensure t
  :after company-irony
  :config (add-to-list 'company-backends '(company-irony-c-headers company-irony)))

(use-package flycheck-irony
  :ensure t
  :after flycheck
  :config (add-hook 'flycheck-mode-hook 'flycheck-irony-setup))

(use-package clang-format
  :ensure t
  :bind ("C-f" . clang-format-buffer))

(use-package bison-mode
  :ensure t
  :mode ("\\.y\\'" "\\.l\\'"))

;; Assembly / Bytecodes

(use-package autodisass-java-bytecode
  :disabled
  :ensure t)

(use-package llvm-mode
  :ensure t)

(use-package autodisass-llvm-bitcode
  :ensure t)

(use-package mips-mode
  :disabled
  :ensure t)

;; Plaintext Modes

(use-package markdown-mode
  :ensure t
  :mode ("\\.markdown\\'" "\\.mk?d\\'" "\\.text\\'"))

(use-package json-mode
  :ensure t
  :mode "\\.json$"
  :config (setq js-indent-level 2))

(use-package yaml-mode
  :ensure t
  :mode "\\.ya?ml\'")

;; Web languages

(use-package less-css-mode
  :ensure t
  :mode "\\.less\\'")

(use-package web-mode
  :ensure t
  :mode ("\\.css\\'" "\\.phtml\\'" "\\.tpl\\.php\\'" "\\.[agj]sp\\'" "\\.as[cp]x\\'" "\\.mustache\\'" "\\.djhtml\\'" "\\.html?\\'")
  :config
  (setq web-mode-markup-indent-offset 2
        web-mode-css-indent-offset 2
        web-mode-code-indent-offset 2
        web-mode-attr-indent-offset 2
        web-mode-style-padding 1
        web-mode-script-padding 1
        web-mode-block-padding 0
        web-mode-enable-auto-pairing t
        web-mode-enable-css-colorization t
        web-mode-enable-block-face t
        web-mode-enable-current-element-highlight t
        web-mode-enable-current-column-highlight t)
  (use-package web-beautify
    :ensure t)
  :bind ("C-n" . web-mode-tag-match))

(use-package rainbow-mode
  :ensure t
  :after web-mode
  :diminish rainbow-mode
  :init (add-hook 'web-mode-hook 'rainbow-mode))

(use-package company-web
  :ensure t
  :after company
  :config (add-to-list 'company-backends 'company-web-html))

(provide 'init)
;;; init.el ends here
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (company-web rainbow-mode web-mode less-css-mode yaml-mode json-mode markdown-mode autodisass-llvm-bitcode llvm-mode bison-mode clang-format flycheck-irony company-irony-c-headers company-irony irony flycheck company modern-cpp-font-lock cmake-mode gitignore-mode gitconfig-mode git-gutter rainbow-identifiers rainbow-delimiters monokai-theme smooth-scrolling exec-path-from-shell use-package))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
