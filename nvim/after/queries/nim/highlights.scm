; extends

((comment) @disableComment
  (#match? @disableComment "^#_")
  (#set! priority 105))
