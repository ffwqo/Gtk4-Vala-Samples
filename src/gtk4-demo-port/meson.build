
sources = [
  'applauncher.vala',
  'filebrowser.vala',
]

foreach t_file : sources
  t_name = t_file.split('.')[0]
  executable(t_name, t_file, dependencies: gtk_dep)
endforeach
