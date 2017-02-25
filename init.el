;;; init.el --- Personal Emacs Config

;;; Commentary:


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


;; Interface config
(diminish 'abbrev-mode)
(setq inhibit-startup-screen t)
(defalias 'yes-or-no-p 'y-or-n-p)

(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(column-number-mode 1)
(line-number-mode 1)
(show-paren-mode 1)
(electric-indent-mode 1)
(delete-selection-mode 1)
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1)))
(setq mouse-wheel-progressive-speed nil)
(setq mouse-wheel-follow-mouse 't)
(setq scroll-step 1)
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; Package loading
(use-package exec-path-from-shell
  :ensure t
  :config
  (when (memq window-system '(mac ns))
    (exec-path-from-shell-initialize)))

(use-package smooth-scrolling
  :ensure t
  :config
  (setq smooth-scroll-margin 5))

(use-package powerline
  :ensure t
  :config
  (powerline-default-theme)
  (setq powerline-buffer-size-suffix  t)
        powerline-default-separator   nil
        powerline-display-buffer-size nil
        powerline-display-hud         t
        powerline-display-mule-info   t
        powerline-gui-use-vcs-glyph   t)

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

(use-package modern-cpp-font-lock
  :ensure t
  :diminish modern-c++-font-lock-mode
  :config (add-hook 'c++-mode-hook 'modern-c++-font-lock-mode))

(use-package company
  :ensure t
  :defer 2
  :diminish company-mode "C "
  :config
  (setq company-backends (delete 'company-clang company-backends))
  (global-company-mode)
  :bind ("<backtab>" . company-complete-common))

(use-package flycheck
  :ensure t
  :defer 1
  :diminish flycheck-mode "F "
  :config
  (global-flycheck-mode)
  (setq-default flycheck-disabled-checkers '(c/c++-clang)))

(use-package irony
  :ensure t
  :defer 3
  :init
  (add-hook 'c-mode-hook 'irony-mode)
  (add-hook 'c++-mode-hook 'irony-mode)
  :config
  (defun my-irony-mode-hook ()
    (define-key irony-mode-map [remap completion-at-point] 'irony-completion-at-point-async)
    (define-key irony-mode-map [remap complete-symbol] 'irony-completion-at-point-async))
  (add-hook 'irony-mode-hook 'my-irony-mode-hook)
  (add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)
  (if (not (irony--locate-server-executable))
    (irony-install-server
     (format
      (concat "%s %s %s && %s --build . --use-stderr --config Release --target install")
      (shell-quote-argument irony-cmake-executable)
      (shell-quote-argument
       (concat "-DCMAKE_INSTALL_PREFIX=" (expand-file-name irony-server-install-prefix)))
      (shell-quote-argument irony-server-source-dir)
      (shell-quote-argument irony-cmake-executable))))

  (add-hook 'c-mode-hook
   (lambda()
     (setq irony-additional-clang-options
	   (quote ("-Wall" "-Wextra")))))
  (add-hook 'c++-mode-hook
   (lambda()
     (setq irony-additional-clang-options
	   (quote ("-std=c++14" "-Wall" "-Wextra" "-pedantic-errors")))))

  (use-package company-irony
    :ensure t
    :diminish irony-mode "I "
    :config
    (use-package company-irony-c-headers
      :ensure t))
  (add-to-list 'company-backends '(company-irony-c-headers company-irony))

  (use-package flycheck-irony
    :ensure t
    :config
    (eval-after-load 'flycheck
      '(add-hook 'flycheck-mode-hook 'flycheck-irony-setup))))

(use-package clang-format
  :ensure t
  :bind
  ("C-f" . clang-format-buffer))

(use-package bison-mode
  :ensure t)

(provide 'init)
;;; init.el ends here
