
sources = [
  ['applauncher.vala'],
  ['filebrowser.vala'],
  ['filebrowser_old.vala'],
  ['testtemplate.vala', 'testtemplatewindow.vala'],
]

gnome = import('gnome')
resource = gnome.compile_resources('resources',
  'filebrowser.gresource.xml'
)


foreach group : sources
  lsource = []
  foreach t_file : group
    lsource += t_file
  endforeach
  t_name = group[0].split('.')[0]
  executable(t_name, lsource, resource, dependencies: gtk_dep)
endforeach
