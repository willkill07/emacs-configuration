(defun next-error-wrapped (&optional arg reset)
  (interactive)
  (condition-case nil
      (call-interactively 'next-error)
    ('user-error (progn (next-error 1 t)
			(previous-error 1)))))

(defun jump-to-last-error (buffer)
  (save-selected-window
    (select-window (get-buffer-window buffer))
    (goto-char (point-max))
    (forward-line -1)
    (call-interactively 'compile-goto-error)))

(defun previous-error-wrapped (&optional arg)
  (interactive "P")
  (condition-case nil
      (if (compilation-buffer-p (current-buffer))
          (compilation-previous-error 1)
        (call-interactively 'previous-error))
    ('user-error (progn
                   (let ((error-buffer (next-error-find-buffer)))
		     (if (and (not (eq (current-buffer) error-buffer))
                              (compilation-buffer-p error-buffer))
                         (jump-to-last-error error-buffer)
		         (goto-char (point-max))
                         (call-interactively 'previous-error)))))))

(provide 'wrap-error-fix)
