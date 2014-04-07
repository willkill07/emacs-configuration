;;; civl-syntax.el --- CIVL-C Syntax Highlighting

;;;###autoload
(define-derived-mode civl-mode c-mode
  (setq mode-name "CIVL-C"))

;;;###autoload
(add-hook 'civl-mode-hook
  (lambda ()
    (font-lock-add-keywords nil
      '(("\\<_Bool\\>" . font-lock-type-face)
    	("\\$\\(bundle\\|scope\\|proc\\|message\\|gcomm\\|comm\\)\\>" . font-lock-type-face)
    	("\\$\\(here\\|root\\|self\\|true\\|false\\)\\>" . font-lock-constant-face)
    	("\\$\\(scope_parent\\|scopeof\\|choose_int\\|wait\\|exit\\|message_pack\\|message_tag\\|message_dest\\|message_size\\|message_unpack\\|gcomm_create\\|gcomm_destroy\\|comm_destroy\\|comm_create\\|comm_size\\|comm_place\\|comm_enqueue\\|comm_probe\\|comm_seek\\|comm_dequeue\\|assert\\|malloc\\|free\\)\\>" . font-lock-builtin-face)
    	("\\$\\(when\\|choose\\|spawn\\|atom\\|atomic\\|input\\|output\\|assume\\|forall\\|exists\\|requires\\|ensures\\|invariant\\|collective\\|abstract\\)\\>" . font-lock-keyword-face)))))

;;;###autoload
(add-to-list 'auto-mode-alist '("\\.\\(cvl\\|cvh\\)" . civl-mode))

(provide 'civl-syntax)
