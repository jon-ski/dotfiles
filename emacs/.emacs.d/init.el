;;; init.el --- Minimal org-mode config -*- lexical-binding: t; -*-

;; Restore reasonable GC threshold after init (deferred in early-init)
(add-hook 'emacs-startup-hook
          (lambda () (setq gc-cons-threshold (* 16 1024 1024))))

;;;; ---- Package infrastructure (no packages installed yet) ----

(require 'package)
(setq package-archives
      '(("melpa"  . "https://melpa.org/packages/")
        ("gnu"    . "https://elpa.gnu.org/packages/")))

;; use-package is built-in since Emacs 29. Adding a package later is
;; just another use-package block with :ensure t.
(require 'use-package)
(setq use-package-always-defer t)  ; lazy-load by default

;;;; ---- Appearance ----

(use-package emacs
  :config
  (load-theme 'modus-vivendi t)

  ;; Line numbers in programming and org buffers
  (add-hook 'prog-mode-hook  #'display-line-numbers-mode)
  (add-hook 'org-mode-hook   #'display-line-numbers-mode)

  ;; Highlight current line
  (global-hl-line-mode 1)

  ;; Show column number in modeline
  (column-number-mode 1))

;;;; ---- Sensible defaults ----

(use-package emacs
  :config
  ;; Typed text replaces selection
  (delete-selection-mode 1)

  ;; Revert buffers when files change on disk
  (global-auto-revert-mode 1)

  ;; Remember recent files
  (recentf-mode 1)
  (setq recentf-max-items 50)

  ;; Save place in files between sessions
  (save-place-mode 1)

  ;; Don't litter the filesystem with backups
  (setq backup-directory-alist
        `(("." . ,(expand-file-name "backups" user-emacs-directory))))
  (setq auto-save-file-name-transforms
        `((".*" ,(expand-file-name "auto-saves/" user-emacs-directory) t)))
  (make-directory (expand-file-name "auto-saves" user-emacs-directory) t)

  ;; UTF-8 everywhere
  (set-default-coding-systems 'utf-8)

  ;; y/n instead of yes/no
  (setq use-short-answers t)

  ;; Smoother scrolling
  (setq scroll-conservatively 101
        scroll-margin 3))

;;;; ---- Org mode ----

(use-package org
  :hook (org-mode . visual-line-mode)
  :custom
  ;; Appearance
  (org-startup-indented t)           ; virtual indentation (clean look)
  (org-startup-folded 'content)      ; show headings on open, bodies folded
  (org-ellipsis " ▾")               ; nicer fold indicator
  (org-hide-emphasis-markers t)      ; render *bold* as bold, not *bold*

  ;; Editing
  (org-return-follows-link t)        ; RET opens links
  (org-special-ctrl-a/e t)           ; C-a/C-e respect headline structure
  (org-catch-invisible-edits 'smart) ; don't silently edit folded text
  (org-src-tab-acts-natively t)      ; indent code blocks properly

  ;; Task management (light, for project.org files)
  (org-todo-keywords '((sequence "TODO" "DOING" "|" "DONE" "CANCELED")))
  (org-log-done 'time)              ; timestamp when task completed
  (org-enforce-todo-dependencies t)) ; can't close parent before children

;;;; ---- Completion (built-in) ----

;; Fido mode: lightweight fuzzy minibuffer completion (built-in)
(use-package fido-vertical-mode
  :config
  (fido-vertical-mode 1))

;;;; ---- Keybindings ----

;; Common org entry points
(global-set-key (kbd "C-c l") #'org-store-link)
(global-set-key (kbd "C-c a") #'org-agenda)
(global-set-key (kbd "C-c c") #'org-capture)

