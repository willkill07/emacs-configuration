
;;;###autoload
(add-hook 'linum-before-numbering-hook
	  (lambda ()
	    (setq-local linum-format-fmt
			(let ((w (length (number-to-string
					  (count-lines (point-min) (point-max))))))
			  (concat " %" (number-to-string w) "d ")))))
;;;###autoload
(setq linum-format (lambda (line)
		     (concat
		      (propertize (format linum-format-fmt line) 'face 'linum)
		      (propertize "" 'face 'linum))))

(provide 'linum-customize)

