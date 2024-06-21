;;default-directory
(setq default-directory "~/")

;; stops start-up message

(setq inhibit-splash-screen t)

;;change font
;;(set-face-attribute 'default nil :font "Cousine-16")

;; maximize screen on start-up
(add-hook 'window-setup-hook 'toggle-frame-maximized t)

;; set deault directory
(setq default-directory "c:/~")

;;disable the menu on start-up
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)


;;set "GNU" style indenting for c
(setq c-default-style "linux"
      c-basic-offset 4
      tab-width 4
      indent-tabs-mode t)

;; Set the compile command to use GCC
(setq-default compile-command "gcc -Wall -Werror -Wextra -pedantic -std=c89 -o %s %s")

;;install flycheck
(use-package flycheck
  :ensure t
  :init (global-flycheck-mode))

;;use fly-check for checking syntax in c/c++p
(flycheck-define-checker betty
  "A syntax checker using Betty for style checking and documentation."
  :command ("betty-style" source "--no-pedantic" "&&" "betty-doc" source)
  :error-patterns
  ((error line-start (file-name) ":" line ": error: " (message) line-end))
  :modes (c-mode c++-mode))

;; Add Betty checker to list of checkers
(add-to-list 'flycheck-checkers 'betty)

;; Set up keybinding for manual syntax check
(global-set-key (kbd "C-c C-v") 'flycheck-buffer)

;; electric pair mode
(electric-pair-mode 1)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(js-comint prettier-js tide js2-mode flycheck elpy magit ace-window)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :extend nil :stipple nil :background "white" :foreground "black" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight regular :height 127 :width normal :foundry "outline" :family "Courier New")))))

;;emacs for python.

(defun my-python-compile ()
  "Compile the current Python file to bytecode."
  (interactive)
  (when (eq major-mode 'python-mode)
    (let ((filename (buffer-file-name)))
      (shell-command (concat "python -m py_compile " filename))
      (message "Compiled %s" filename))))

;; Ensure python-mode is available
(require 'python)

;; Set python-indent-offset and disable guessing mechanism
(defun my-python-mode-config ()
  (setq python-indent-offset 4)
  (setq python-indent-guess-indent-offset nil))

(add-hook 'python-mode-hook 'my-python-mode-config)


;;install melpa
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

;;use magit
(use-package magit
  :ensure t
  :bind (("C-x g" . magit-status)))

;;make files executable
(defun make-file-executable ()
  "Make the current file executable."
  (interactive)
  (when buffer-file-name
    (chmod buffer-file-name #o755)
    (message "Made %s executable" buffer-file-name)))

;;splitting windows equally
(defun split-window-horizontally-equal ()
  "Split the current window into two windows of equal width."
  (interactive)
  (split-window-right)
  (balance-windows))

(defun split-window-vertically-equal ()
  "Split the current window into two windows of equal height."
  (interactive)
  (split-window-below)
  (balance-windows))

(defun setup-window-split-hooks ()
  "Set up hooks to balance windows after splitting."
  (add-hook 'window-configuration-change-hook 'balance-windows))

;; Bind the custom functions to the standard split window keys
(global-set-key (kbd "C-x 2") 'split-window-vertically-equal)
(global-set-key (kbd "C-x 3") 'split-window-horizontally-equal)

;; Ensure windows are balanced when configuration changes
(setup-window-split-hooks)

;;configuring java script.

;; Install use-package if not installed
(unless (package-installed-p 'use-package)
  (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure t)

;; Install and configure js2-mode
(use-package js2-mode
  :mode ("\\.js\\'" . js2-mode))

;; Install and configure tide
(use-package tide
  :after (js2-mode company flycheck)
  :hook ((js2-mode . tide-setup)
         (js2-mode . tide-hl-identifier-mode)
         (before-save . tide-format-before-save)))

;; Install and configure prettier-js
(use-package prettier-js
  :hook ((js2-mode . prettier-js-mode)))

;; Function to run current JS file
(defun run-js-file ()
  "Run the current JavaScript file."
  (interactive)
  (let ((file (buffer-file-name)))
    (if file
        (shell-command (concat "node " file))
      (message "Buffer is not visiting a file!"))))

;; js2-mode for JavaScript editing
(use-package js2-mode
  :ensure t
  :mode ("\\.js\\'" . js2-mode)
  :config
  (setq js2-basic-offset 2)  ;; Set indentation level to 2 spaces
  (add-hook 'js2-mode-hook (lambda () (setq mode-name "JS2"))))

;; js-comint for running JavaScript code
(use-package js-comint
  :ensure t
  :config
  (setq inferior-js-program-command "c:\"))  ;; Ensure the correct path to Node.js

;; Add hooks and keybindings for js-comint
(add-hook 'js2-mode-hook
          (lambda ()
            (local-set-key (kbd "C-x C-e") 'js-send-last-sexp)
            (local-set-key (kbd "C-M-x") 'js-send-last-sexp-and-go)
            (local-set-key (kbd "C-c b") 'js-send-buffer)
            (local-set-key (kbd "C-c C-b") 'js-send-buffer-and-go)
            (local-set-key (kbd "C-c l") 'js-load-file-and-go)))

(provide 'init)
;;; init.el ends here

