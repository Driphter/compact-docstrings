;;; compact-lisp.el --- Shrink blank lines in lisp forms

;; Copyright (C) 2016  Free Software Foundation, Inc.

;; Author: Mike Myers <thedriphter@gmail.com>
;; Maintainer: Mike Myers <thedriphter@gmail.com>
;; URL: https://github.com/driphter/compact-lisp
;; Package-Version: 0.1
;; Keywords: convenience, faces, lisp, maint

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; Shrink blank lines in lisp forms
;;
;; Enable locally with `compact-lisp-mode':
;;   (add-hook 'some-mode-hook #'compact-lisp-mode)
;;
;; Enable globally (in all programming modes) with
;;   (add-hook 'after-init-hook #'global-compact-lisp--mode)

;;; Code:

(defgroup compact-lisp nil
  "Shrink empty lines in lisp forms."
  :group 'faces)

(defface compact-lisp-face
  '((t :height 0.35))
  "Face applied to blank lines in lisp forms."
  :group 'compact-lisp)

(defun compact-lisp--matcher (bound)
  "Find blank line in lisp form, looking in point .. BOUND."
  (let ((found nil))
    (while (and (not found) (re-search-forward "^\\s-*\n" bound t))
      (let ((syntax (syntax-ppss)))
        (when (< 0 (nth 0 syntax))  ;; Parenthesis depth
          (setq found t))))
    found))

(defconst compact-lisp--keywords
  '((compact-lisp--matcher 0 'compact-lisp-face prepend)) 'append)

;;;###autoload
(define-minor-mode compact-lisp-mode
  "Shrink empty lines in lisp forms."
  :lighter " →∥←"
  (if compact-lisp-mode
      (font-lock-add-keywords nil compact-lisp--keywords 'append)
    (font-lock-remove-keywords nil compact-lisp--keywords))
  (if (fboundp #'font-lock-flush)
      (font-lock-flush)
    (with-no-warnings (font-lock-fontify-buffer))))

(defun compact-lisp--mode-on ()
  "Turn on `compact-lisp-mode', if appropriate."
  (when (derived-mode-p #'prog-mode)
    (compact-lisp-mode)))

;;;###autoload
(defalias 'shrink-lisp-forms #'compact-lisp--mode-on)

;;;###autoload
(define-globalized-minor-mode global-compact-lisp-mode compact-lisp-mode
  compact-lisp--mode-on
  :init-value nil)

(provide 'compact-lisp)
;;; compact-lisp.el ends here
