;;; openai-image.el --- Create image with OpenAI  -*- lexical-binding: t; -*-

;; Copyright (C) 2023  Shen, Jen-Chieh

;; This file is not part of GNU Emacs.

;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program. If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:
;;
;; Create image with OpenAI.
;;
;; See https://beta.openai.com/docs/api-reference/images/create
;;

;;; Code:

(require 'openai)

(defcustom openai-image-n 1
  "The number of images to generate. Must be between 1 and 10."
  :type 'integer
  :group 'openai)

(defcustom openai-image-size "1024x1024"
  "The size of the generated images.

Must be one of `256x256', `512x512', or `1024x1024'."
  :type 'string
  :group 'openai)

(defcustom openai-image-response-format "url"
  "The format in which the generated images are returned.

Must be one of `url' or `b64_json'."
  :type 'string
  :group 'openai)

(defcustom openai-image-user "url"
  "A unique identifier representing your end-user, which can help OpenAI to
monitor and detect abuse."
  :type 'string
  :group 'openai)

;;
;;; API

(defun openai-image (query callback)
  "Create image with QUERY.

Argument CALLBACK is function with data pass in."
  (openai-request "https://api.openai.com/v1/images/generations"
    :type "POST"
    :headers `(("Content-Type"  . "application/json")
               ("Authorization" . ,(concat "Bearer " openai-key)))
    :data (json-encode
           `(("prompt"          . ,query)
             ("n"               . ,openai-image-n)
             ("size"            . ,openai-image-size)
             ("response_format" . ,openai-image-response-format)
             ("user"            . ,openai-image-user)))
    :parser 'json-read
    :success (cl-function
              (lambda (&key data &allow-other-keys)
                (funcall callback data)))))

;;;###autoload
(defun openai-image-prompt (query)
  ""
  (interactive (list (read-string "Describe image: ")))
  (openai-image query
                (lambda ()
                  
                  )))

(provide 'openai-image)
;;; openai-image.el ends here
