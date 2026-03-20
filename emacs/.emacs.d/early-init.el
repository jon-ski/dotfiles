;;; early-init.el --- Pre-frame startup -*- lexical-binding: t; -*-

;; Disable GUI chrome before the frame draws (avoids flash of defaults)
(setq inhibit-startup-message t)
(push '(menu-bar-lines . 0) default-frame-alist)
(push '(tool-bar-lines . 0) default-frame-alist)
(push '(vertical-scroll-bars) default-frame-alist)

;; Don't resize frame at startup (faster)
(setq frame-inhibit-implied-resize t)

;; Defer garbage collection during init
(setq gc-cons-threshold most-positive-fixnum)
