;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Courier" :size 16 :weight 'semi-light)
;;     doom-variable-pitch-font (font-spec :family "Courier" :size 16))
(setq doom-font (font-spec :family "Fira Code" :size 14 :weight 'medium)
      doom-variable-pitch-font (font-spec :family "Fira Code" :size 14))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'cyberpunk)
;;(setq doom-theme 'doom-one)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

(remove-hook 'doom-first-buffer-hook #'smartparens-global-mode)

;; (defun my/workspace-new-with-current-file ()
;;   "Create a new workspace and open the current file at the same point."
;;   (interactive)
;;   (let ((file (buffer-file-name))
;;         (point (point)))
;;     (if file
;;         (progn
;;           (+workspace/new (buffer-name)) ;; Create new workspace
;;           (find-file file)               ;; Open the same file
;;           (goto-char point))             ;; Restore the cursor position
;;       (message "No file is currently open.")))) ;; Fallback when there's no file
(defvar my/workspace-counter 1
  "Counter to append to workspace names to make them unique.")

(defun my/generate-workspace-name (base-name)
  "Generate a unique workspace name using BASE-NAME and a counter."
  (let ((name (format "%s-%d" base-name my/workspace-counter)))
    (setq my/workspace-counter (1+ my/workspace-counter))
    name))

(defun my/workspace-new-with-current-file ()
  "Create a new workspace and open the current file at the same point with a unique workspace name."
  (interactive)
  (let ((file (buffer-file-name))
        (point (point)))
    (if file
        (progn
          (let ((workspace-name (my/generate-workspace-name (file-name-nondirectory file))))
            (+workspace/new workspace-name)  ;; Create new workspace with unique name
            (find-file file)                 ;; Open the same file
            (goto-char point))               ;; Restore the cursor position
          (message "Opened file in new workspace: %s" (buffer-name)))
      (message "No file is currently open."))))

(use-package! key-chord
  :ensure t
  :demand t
  :init
  (setq key-chord-two-keys-delay 0.1)
  (key-chord-define-global "kj" 'evil-normal-state)
  :config
  (key-chord-mode t)
  )

(use-package! consult
  :ensure t
  :demand t
  :config
  (setq consult-narrow-key "<")
  )

(use-package! marginalia :ensure t)
(use-package! orderless :ensure t)
(use-package! vertico  :ensure t)

(use-package! embark  :ensure t
              :bind
              (("C-." . embark-act)
               ("C-;" . embark-dwim)
               ("C-'" . embark-collect)
               ("C-h B" . embark-bindings))
              )

(setq warning-minimum-level :error)

(defun toggle-dedicated-mode ()
  "Toggle window dedicated mode and print whether it is enabled or disabled."
  (interactive)
  (if (window-dedicated-p)
      (progn
        (set-window-dedicated-p (selected-window) nil)
        (message "Dedicated mode disabled"))
    (progn
      (set-window-dedicated-p (selected-window) t)
      (message "Dedicated mode enabled"))))

;; (doom-modeline-def-segment workspace-list
;;   "Show the list of workspaces with the current one highlighted."
;;   (let ((workspaces (+workspace-list-names)))
;;     (if workspaces
;;         (string-join
;;          (mapcar (lambda (ws)
;;                    (if (equal ws (+workspace-current-name))
;;                        (propertize ws 'face 'doom-modeline-buffer-modified)  ;; Highlight current workspace
;;                      ws))
;;                  workspaces)
;;          " | ")
;;       "")))

(use-package! ranger
  :ensure t
  :bind
  (
   ("M-l" .'evil-window-right)
   ("M-h" .'evil-window-left)
   ("M-k" .'evil-window-up)
   ("M-j" .'evil-window-down)
   ("M-L" .'+evil/window-move-right)
   ("M-H" .'+evil/window-move-left)
   ("M-K" .'+evil/window-move-up)
   ("M-J" .'+evil/window-move-down)
   ("M-0" .'+workspace/switch-right)
   ("M-9" .'+workspace/switch-left)
   ("M-e" .'evil-window-delete)
   ("M-\\" .'+evil/window-vsplit-and-follow)
   ("M-\-" .'+evil/window-split-and-follow)
   ("M-)" .'+workspace/swap-right)
   ("M-(" .'+workspace/swap-left)
   ("M-c" .'+workspace/new)
   ("M-z" .'doom/window-maximize-buffer)
   ("M-," .'+workspace/rename)
   ("M-p" . toggle-input-method-active)
   ("M-." .'+workspace/display))
  )


(use-package! embark-consult
  :ensure t
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))

(map! :leader "fj" #'deer)
(map! :leader "SPC" #'execute-extended-command)
(map! :leader "`" #'+vterm/toggle)

;; org mode
(map! :leader "ly" #'org-store-link)
(map! :leader "lp" #'org-insert-link)

;; code
(map! :leader "cl" #'comment-line)
(map! :leader "cF" #'lsp-format-buffer)
(map! :leader "cR" #'lsp-restart-workspace)
(map! :leader "." #'lsp-ui-doc-show)
(map! :leader "c>" #'lsp-describe-thing-at-point)
(map! :leader "c." #'lsp-ui-doc-toggle)
(map! :leader "c," #'lsp-ui-doc-glance)

;; search
(map! :leader "sj" #'consult-outline)
(map! :leader "s." #'consult-ripgrep)

;; window management
(map! :leader "wD" #'dedicated-mode)
(map! :leader "wV" #'+evil/window-vsplit-and-follow)
(map! :leader "wS" #'+evil/window-split-and-follow)
(map! :leader "wO" #'other-frame)


;; other fast shortcuts
(map! :n "M-r" #'+tmux/rerun)
(map! :n "M-f" #'+tmux/run)
(map! :n "M-b" #'+tmux/cd-to-here)

;; workspaces
(map! :leader "ol" #'+workspace/other)
(map! :leader "o." #'+workspace/display)
(map! :leader "oo" #'+workspace/switch-to)
(map! :leader "od" #'+workspace/delete)

;; (map! :leader "oc" #'+workspace/new)
(map! :leader "oC" #'+workspace/new-named)
(map! :leader "oS" #'+workspace/save)
(map! :leader "oR" #'+workspace/load)
(map! :leader :n "o<tab>" #'+workspace/other)
(map! :leader "o1" #'+workspace/switch-to-1)
(map! :leader "o2" #'+workspace/switch-to-2)
(map! :leader "o3" #'+workspace/switch-to-3)
(map! :leader "o4" #'+workspace/switch-to-4)
(map! :leader "o5" #'+workspace/switch-to-5)
(map! :leader "o6" #'+workspace/switch-to-6)
(map! :leader "o7" #'+workspace/switch-to-7)
(map! :leader "o8" #'+workspace/switch-to-8)
(map! :leader "o9" #'+workspace/switch-to-9)

(defun doom-modeline-dedicated-mode-indicator ()
  "Return a symbol if the window is dedicated."
  (if (window-dedicated-p)
      " 🔒"  ;; locked symbol
    " 🔓")) ;; unlocked symbol

(doom-modeline-def-segment dedicated-mode
  "Show an indicator for window dedicated mode."
  (doom-modeline-dedicated-mode-indicator))

(doom-modeline-def-modeline 'main
  '(bar window-number dedicated-mode modals matches buffer-info remote-host buffer-position parrot selection-info)
  '(misc-info  lsp major-mode process vcs ))

;; (package! emacs-codeql
;;   :recipe (:host github :repo "anticomputer/emacs-codeql"
;;            :fetcher github-ssh
;;            :branch "main"
;;            :files (:defaults "bin"))
;;   :demand t
;;   :init
;;   (setq codeql-transient-binding "C-c q")
;;   (setq codeql-configure-eglot-lsp t))

(after! doom-modeline
  (setq doom-modeline-persp-name t)
  (setq doom-modeline-lsp-icon t)
  (setq doom-modeline-workspace-name t)
  (setq doom-modeline-persp-name t)
  (setq doom-modeline-minor-modes nil)
  (setq doom-modeline-major-mode-icon t))

(after! lsp-ui
  (setq lsp-ui-doc-max-width 500)
  (setq lsp-ui-doc-max-height 30)
  (setq lsp-ui-sideline-diagnostic-max-lines 4)
  (setq lsp-ui-sideline-diagnostic-max-line-length 200))

(add-hook 'lsp-ui-doc-frame-hook
          (lambda (frame _w)
            (set-face-attribute 'default frame :font "Fira Code" :height 180)))

(use-package! org-modern :ensure t :init (add-hook 'org-mode 'org-modern-mode))
(setq treesit-auto-langs '(python rust go))
(use-package! treesit-auto :ensure t :config (treesit-auto-add-to-auto-mode-alist 'all))
(use-package! beacon :ensure t :config (beacon-mode t))
(use-package! vertico-posframe :ensure t :config (vertico-posframe-mode t))
;; (use-package! dimmer :ensure t :config (dimmer-mode t))
(use-package! zoom :ensure t :config (zoom-mode t))

(use-package! vterm :ensure t)

(use-package! ranger :ensure t
              :bind (("M-d". evil-window-delete)))

(use-package treesit
  :commands (treesit-install-language-grammar nf/treesit-install-all-languages)
  :init
  (setq treesit-language-source-alist
        '((bash . ("https://github.com/tree-sitter/tree-sitter-bash"))
          (c . ("https://github.com/tree-sitter/tree-sitter-c"))
          (cpp . ("https://github.com/tree-sitter/tree-sitter-cpp"))
          (css . ("https://github.com/tree-sitter/tree-sitter-css"))
          (cmake . ("https://github.com/uyha/tree-sitter-cmake"))
          (go . ("https://github.com/tree-sitter/tree-sitter-go"))
          (html . ("https://github.com/tree-sitter/tree-sitter-html"))
          (javascript . ("https://github.com/tree-sitter/tree-sitter-javascript"))
          (json . ("https://github.com/tree-sitter/tree-sitter-json"))
          (make . ("https://github.com/alemuller/tree-sitter-make"))
          (ocaml . ("https://github.com/tree-sitter/tree-sitter-ocaml" "master" "ocaml/src"))
          (python . ("https://github.com/tree-sitter/tree-sitter-python"))
          (typescript . ("https://github.com/tree-sitter/tree-sitter-typescript" "master" "typescript/src"))
          (rust . ("https://github.com/tree-sitter/tree-sitter-rust"))
          (sql . ("https://github.com/m-novikov/tree-sitter-sql"))
          (toml . ("https://github.com/tree-sitter/tree-sitter-toml"))
          (codeql . ("https://github.com/tree-sitter/tree-sitter-ql"))
          (zig . ("https://github.com/GrayJack/tree-sitter-zig"))))
  :config
  (defun nf/treesit-install-all-languages ()
    "Install all languages specified by `treesit-language-source-alist'."
    (interactive)
    (let ((languages (mapcar 'car treesit-language-source-alist)))
      (dolist (lang languages)
        (treesit-install-language-grammar lang)
        (message "`%s' parser was installed." lang)
        (sit-for 0.75)))))


(setq major-mode-remap-alist
      '((yaml-mode . yaml-ts-mode)
        (bash-mode . bash-ts-mode)
        (js2-mode . js-ts-mode)
        (typescript-mode . typescript-ts-mode)
        (json-mode . json-ts-mode)
        (rustic-mode . rust-ts-mode)
        (go-mode . go-mode)
        (css-mode . css-ts-mode)
        (python-mode . python-ts-mode)))


(after! lsp-rust
  (setq lsp-rust-server 'rust-analyzer))

(use-package! popper
  :ensure t
  :bind (("M-y"   . popper-toggle)
         ("C-`"   . popper-cycle)
         ("M-Y" . popper-toggle-type))
  :init
  (setq popper-reference-buffers
        '("\\*Messages\\*"
          "Output\\*$"
          help-mode
          compilation-mode))
  (popper-mode t))

(use-package! org
  :ensure t
  :after org
  ;; :bind (
  ;;        ("M-l" . 'evil-window-right)
  ;;        ("M-h" . 'evil-window-left))
  :config
  (setq org-todo-keywords
        '((sequence "TODO(t)" "HABIT(h)" "STARTED(s@/!)" "WAITING(w@/!)" "DELEGATED(y@/!)" "|" "DONE(d!)" "DEFERRED(a@/!)" "CANCELLED(c@/!)")))
  (org-babel-do-load-languages 'org-babel-load-languages
                               '((sh . t)
                                 (python . t)
                                 (gnuplot . t)
                                 (js . t)
                                 (sql . t)
                                 (C . t)
                                 (emacs-lisp . t)
                                 (sqlite . t)
                                 (plantuml . t)
                                 (ditaa . t)
                                 (rust . t)
                                 (go . t)

                                 ))
  (add-hook 'org-mode-hook (lambda ()
                             "Beautify Org Checkbox Symbol"
                             ;; (push '("[ ]" .  "☐") prettify-symbols-alist)
                             ;; (push '("[X]" . "☑" ) prettify-symbols-alist)
                             ;; (push '("[-]" . "❍" ) prettify-symbols-alist)
                             (push '("#+BEGIN_SRC" . "λ" ) prettify-symbols-alist)
                             (push '("#+END_SRC" . "λ" ) prettify-symbols-alist)
                             (push '("#+BEGIN_EXAMPLE" . "▷" ) prettify-symbols-alist)
                             (push '("#+END_EXAMPLE" . "◁" ) prettify-symbols-alist)
                             (push '("#+BEGIN_QUOTE" . "ײ" ) prettify-symbols-alist)
                             (push '("#+END_QUOTE" . "ײ" ) prettify-symbols-alist)
                             (push '("#+begin_src" . "λ" ) prettify-symbols-alist)
                             (push '("#+end_src" . "λ" ) prettify-symbols-alist)
                             (push '("#+begin_example" . "▷" ) prettify-symbols-alist)
                             (push '("#+end_example" . "◁" ) prettify-symbols-alist)
                             (push '("#+begin_quote" . "ײ" ) prettify-symbols-alist)
                             (push '("#+end_quote" . "ײ" ) prettify-symbols-alist)
                             (push '("#+RESULTS:" . "»" ) prettify-symbols-alist)
                             (push '(":PROPERTIES:" . ":" ) prettify-symbols-alist)
                             (push '(":END:" . ":" ) prettify-symbols-alist)
                             (push '("#+TBLFM:" . "∫" ) prettify-symbols-alist)
                             (prettify-symbols-mode))))

(use-package! org-super-agenda
  :ensure t
  :after org-agenda
  :config
  ;;       ;;clock setup
  ;;       ;; Resume clocking task on clock-in if the clock is open
  ;;       (setq org-clock-in-resume t)
  ;;       ;; Sometimes I change tasks I'm clocking quickly - this removes clocked tasks with 0:00 duration
  ;;       (setq org-clock-out-remove-zero-time-clocks t)
  ;;       ;; Clock out when moving task to a done state
  ;;       (setq org-clock-out-when-done t)
  ;;       ;; Save the running clock and all clock history when exiting Emacs, load it on startup
  ;;       (setq org-clock-persist t)
  ;;       ;; Do not prompt to resume an active clock
  ;;       (setq org-clock-persist-query-resume nil)
  ;;       ;; Clock out when moving task to a done state
  ;;       (setq org-clock-out-when-done t)
  )

(defun my/eyebrowse-print-window-configs ()
  "Print the current Eyebrowse window configurations and highlight the active one."
  (interactive)
  (let* ((configs (eyebrowse--get 'window-configs))
         (current-slot (eyebrowse--get 'current-slot)))
    (message
     (string-join
      (mapcar (lambda (config)
                (let* ((slot (car config))
                       (name (nth 2 config))  ;; Get the name associated with the window config
                       (display-name (if name
                                         (format "%d:%s" slot name) ;; Display as <slot>:<name>
                                       (format "%d:Workspace" slot))))  ;; Fallback to <slot>:Workspace if no name
                  (if (eq slot current-slot)
                      (propertize (format "[%s]" display-name) 'face 'highlight)  ;; Highlight current
                    (format "%s" display-name))))
              configs)
      " | "))))

(defun my/eyebrowse-next-and-print ()
  "Switch to the next Eyebrowse configuration and print the window configurations."
  (interactive)
  (let* ((configs (eyebrowse--get 'window-configs))
         (current-slot (eyebrowse--get 'current-slot))
         (slots (mapcar #'car configs))  ;; Get the list of all slots
         (next-slot (or (car (cl-remove-if-not (lambda (slot) (> slot current-slot)) slots))  ;; Find the next slot
                        (car slots))))  ;; If no next slot, wrap to the first one
    (eyebrowse-switch-to-window-config next-slot)  ;; Switch to the identified next slot
    (my/eyebrowse-print-window-configs)))

(defun my/eyebrowse-prev-and-print ()
  "Switch to the previous Eyebrowse configuration and print the window configurations."
  (interactive)
  (eyebrowse-prev-window-config 1)
  (my/eyebrowse-print-window-configs))

;; workspaces
(map! :map general-override-mode-map :n "M-0" #'+workspace/switch-right)
(map! :map general-override-mode-map :n "M-9" #'+workspace/switch-left)
(map! :map general-override-mode-map :n "M-)" #'+workspace/swap-right)
(map! :map general-override-mode-map :n "M-(" #'+workspace/swap-left)
(map! :map general-override-mode-map :n "M-n" #'my/workspace-new-with-current-file)
(map! :map general-override-mode-map :n "M-N" #'+workspace/new)
(map! :map general-override-mode-map :n "M-<" #'+workspace/rename)
(map! :map general-override-mode-map :n "M->" #'+workspace/switch-to)
(map! :map general-override-mode-map :n "M-/" #'+workspace/display)


;; eyebrowse
(map! :map general-override-mode-map :n "M-o" #'my/eyebrowse-next-and-print)
(map! :map general-override-mode-map :n "M-i" #'my/eyebrowse-prev-and-print)
(map! :map general-override-mode-map :n "M-O" #'eyebrowse-switch-to-window-config)
(map! :map general-override-mode-map :n "M-I" #'eyebrowse-switch-to-window-config)
(map! :map general-override-mode-map :n "M-c" #'eyebrowse-create-window-config)
(map! :map general-override-mode-map :n "M-C" #'eyebrowse-create-named-window-config)
(map! :map general-override-mode-map :n "M-," #'eyebrowse-rename-window-config)
(map! :map general-override-mode-map :n "M-." #'eyebrowse-switch-to-window-config)
(map! :map general-override-mode-map :n "M-p" #'eyebrowse-close-window-config)


(map! :map general-override-mode-map :n "M-e" #'evil-window-delete)
(map! :map general-override-mode-map :n "M-\\" #'+evil/window-vsplit-and-follow)
(map! :map general-override-mode-map :n "M-\-" #'+evil/window-split-and-follow)
(map! :map general-override-mode-map :n "M-z" #'zoom-window-zoom)

(map! :map general-override-mode-map :n "M-l" #'evil-window-right)
(map! :map general-override-mode-map :n "M-H" #'evil-window-left)
(map! :map general-override-mode-map :n "M-k" #'evil-window-up)
(map! :map general-override-mode-map :n "M-j" #'evil-window-down)
(map! :map general-override-mode-map :n "M-L" #'+evil/window-move-right)
(map! :map general-override-mode-map :n "M-H" #'+evil/window-move-left)
(map! :map general-override-mode-map :n "M-K" #'+evil/window-move-up)
(map! :map general-override-mode-map :n "M-J" #'+evil/window-move-down)

(map! :map general-override-mode-map :n "M-p" #'toggle-dedicated-mode)
