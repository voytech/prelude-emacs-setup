;;; prelude-clojure.el --- Emacs Prelude: Clojure programming configuration.
;;
;; Copyright © 2011-2013 Bozhidar Batsov
;;
;; Author: Bozhidar Batsov <bozhidar@batsov.com>
;; URL: http://batsov.com/prelude
;; Version: 1.0.0
;; Keywords: convenience

;; This file is not part of GNU Emacs.

;;; Commentary:

;; Some basic configuration for clojure-mode.

;;; License:

;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License
;; as published by the Free Software Foundation; either version 3
;; of the License, or (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;; Code:


(add-to-list 'load-path "~/.emacs.d")
(require 'prelude-lisp)
(require 'auto-complete-config)
(require 'flycheck)
(prelude-require-packages '(clojure-mode cider ac-cider paredit rainbow-delimiters flycheck-clojure flycheck-pos-tip))

(eval-after-load 'clojure-mode
  '(progn
     (defun prelude-clojure-mode-defaults ()
       (message "Applying clojure-mode defaults")
       (subword-mode +1)
       (auto-complete-mode +1)
       (cider-mode +1)
       (paredit-mode +1)

       (add-hook 'clojure-mode-hook 'rainbow-delimiters-mode)
       (add-hook 'clojure-mode-hook 'paredit-mode)

       (add-hook 'cider-mode-hook 'ac-flyspell-workaround)
       (add-hook 'cider-mode-hook 'ac-cider-setup)
       (add-hook 'cider-mode-hook 'cider-turn-on-eldoc-mode)
;;     (add-hook 'cider-repl-mode-hook 'ac-cider-setup)
       (add-to-list 'ac-modes 'cider-mode)
;;     (add-to-list 'ac-modes 'cider-repl-mode)
       (run-hooks 'prelude-lisp-coding-hook))
     (setq prelude-clojure-mode-hook 'prelude-clojure-mode-defaults)

     (add-hook 'clojure-mode-hook (lambda ()
                                    (run-hooks 'prelude-clojure-mode-hook)))))

(eval-after-load 'cider
  '(progn
     (message "cider after load")
     (setq nrepl-log-messages t)
     (setq cider-show-error-buffer nil)
     (add-hook 'cider-mode-hook 'cider-turn-on-eldoc-mode)

     (defun prelude-cider-repl-mode-defaults ()
       (message "Applying cider defaults...")
       (subword-mode +1)
       (add-hook 'cider-repl-mode-hook 'ac-cider-setup)
       (add-to-list 'ac-modes 'cider-repl-mode)
       (run-hooks 'prelude-interactive-lisp-coding-hook))

     (setq prelude-cider-repl-mode-hook 'prelude-cider-repl-mode-defaults)

     (add-hook 'cider-repl-mode-hook (lambda ()
                                       (run-hooks 'prelude-cider-repl-mode-hook)))))

(eval-after-load 'auto-complete-config
  '(progn
     (message "auto complete after load")
     (defun auto-complete-defaults ()
        (message "Applying auto-complete defaults...")
        (add-to-list 'ac-modes 'cider-mode)
        (add-to-list 'ac-modes 'cider-repl-mode)
        (add-to-list 'ac-dictionary-directories "~/.emacs.d/ac-dict")
        (ac-config-default)
        (auto-complete-mode 1)
     )

     (setq prelude-auto-complete-mode-hook 'auto-complete-defaults)

     (add-hook 'clojure-mode-hook (lambda ()
                                    (run-hooks 'prelude-auto-complete-mode-hook)))))

(eval-after-load 'flycheck '(flycheck-clojure-setup))
(add-hook 'after-init-hook #'global-flycheck-mode)

(eval-after-load 'flycheck
  '(setq flycheck-display-errors-function #'flycheck-pos-tip-error-messages))

(provide 'prelude-clojure)

;;; prelude-clojure.el ends here
