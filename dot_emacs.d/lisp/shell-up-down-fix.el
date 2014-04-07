;;;###autoload
(defun shell-mode-up-down-fix ()
  (local-set-key (kbd "<up>") 'comint-previous-matching-input-from-input)
  (local-set-key (kbd "<down>") 'comint-next-matching-input-from-input))

;;;###autoload
(add-hook 'shell-mode-hook 'shell-mode-up-down-fix)

(provide 'shell-up-down-fix)
