(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

(require 'doom-modeline)
(doom-modeline-mode 1)

(use-package doom-themes
  :ensure t
  :config
  ;; Global settings (defaults)
  (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
        doom-themes-enable-italic t) ; if nil, italics is universally disabled
  (load-theme 'doom-snazzy t)
  ;; Enable flashing mode-line on errors
  (doom-themes-visual-bell-config)
  ;; Corrects (and improves) org-mode's native fontification.
  (doom-themes-org-config))

(setq inhibit-startup-message t)
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(set-fringe-mode -1)

(add-hook 'after-init-hook 'eshell)

(setq backup-directory-alist
      `(("." . ,(concat user-emacs-directory "~/.emacs.d/auto-save/"))))

(set-frame-parameter (selected-frame) 'alpha '(80 . 50))
(add-to-list 'default-frame-alist '(alpha . (80 . 50)))

(defun jwd/org-startup ()
  (org-bullets-mode 1)                 
  (visual-line-mode 1)                 ; Corrects line-wrapping
  (setq org-odd-levels-only t         
        org-ellipsis "  ⬎"            
        org-hide-emphasis-markers t    ; Hides emphasis markers (*, /, _)
	org-indent-mode t              
	org-startup-indented t)
  (message "Org hook called"))

(defun jwd/org-mode-visual-fill-column ()
  (setq visual-fill-column-width 100            ; Fatter column padding
        visual-fill-column-center-text t)       ; Centers text
  (visual-fill-column-mode 1))                  ; Turns on visual-fill-column-mode

(use-package org
  :hook (org-mode . jwd/org-startup))

(use-package visual-fill-column
  :hook (org-mode . jwd/org-mode-visual-fill-column))

(font-lock-add-keywords 'org-mode
    '(("^ *\\([-]\\) "
       (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))

(require 'org-tempo)
(add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))
(add-to-list 'org-structure-template-alist '("py" . "src python"))

(org-babel-do-load-languages
 'org-babel-load-languages
 '((emacs-lisp . t)               ; Emacs Lisp
   (python . t)))                 ; Python

(setq org-confirm-babel-evaluate nil)

(defun jwd/org-babel-tangle-qtile-config ()
  (when (string-equal (buffer-file-name)
		      (expand-file-name "~/.dotfiles/QTile.org"))
    (let ((org-confirm-babel-evaluate nil))
      (org-babel-tangle))))

(add-hook 'org-mode-hook (lambda () (add-hook 'after-save-hook #'jwd/org-babel-tangle-qtile-config)))

(defun jwd/org-babel-tangle-emacs-config ()
  (when (string-equal (buffer-file-name)
		      (expand-file-name "~/.dotfiles/Emacs.org"))
    (let ((org-confirm-babel-evaluate nil))
      (org-babel-tangle))))

(add-hook 'org-mode-hook (lambda () (add-hook 'after-save-hook #'jwd/org-babel-tangle-emacs-config)))

(ivy-mode)
(setq ivy-use-virtual-buffers t)
(setq enable-recursive-minibuffers t)
(global-set-key "\C-s" 'swiper)
(global-set-key (kbd "M-x") 'counsel-M-x)
(global-set-key (kbd "C-x C-f") 'counsel-find-file)
(global-set-key (kbd "<f1> f") 'counsel-describe-function)
(global-set-key (kbd "<f1> v") 'counsel-describe-variable)
(global-set-key (kbd "<f1> o") 'counsel-describe-symbol)
(global-set-key (kbd "<f2> u") 'counsel-unicode-char)
(global-set-key (kbd "C-c g") 'counsel-git)
(global-set-key (kbd "C-c j") 'counsel-git-grep)
(define-key minibuffer-local-map (kbd "C-r") 'counsel-minibuffer-history)
