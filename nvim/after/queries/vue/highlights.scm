; extends

; Vue components use PascalCase; keep native HTML tags on the regular @tag color.
((tag_name) @type.class
  (#match? @type.class "^[A-Z]")
  (#set! priority 110))
