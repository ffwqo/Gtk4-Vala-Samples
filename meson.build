project('vala app', 'vala', 'c')
add_project_arguments('-DGDK_DISABLE_DEPRECATED -DGTK_DISABLE_DEPRECATED', language: 'c')

gtk_dep = [
  dependency('gio-2.0'),
  dependency('glib-2.0'),
  dependency('gobject-2.0'),
  dependency('gtk4'),
  #dependency('webkit2gtk-4.0')
  #dependency('gtksourceview-4'),
]

subdir('src')

