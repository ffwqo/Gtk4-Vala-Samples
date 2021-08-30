#gnome = import('gnome')
##TODO fix this 
#resources = gnome.compile_resources(
#    'resources',
#    'gtk4_vala_samples.gresource.xml'
#)

sources = [
    'actionbar.vala',
    'box.vala',
    'button.vala',
    'checkbutton.vala',
    'comboboxtext.vala',
    'combobox.vala',
    'dropdown.vala',
    'entrybuffer.vala',
    'entrycompletion.vala',
    'entry.vala',
    'flowbox.vala',
    'fontbutton.vala',
    'grid.vala',
    'label.vala',
    'listbox.vala',
    'notebook.vala',
    'paned.vala',
    'radiobutton.vala',
    'scale.vala',
    'searchentry.vala',
    'separator.vala',
    #'sourceview.vala'
    'spinbutton.vala',
    'spinner.vala',
    'stack.vala',
    'stacksidebar.vala',
    'stackswitcher.vala',
    'texteditor.vala',
    'togglebutton.vala',
    #'webkit2.vala',
    
    'signalfactory.vala',
    'builderfactory.vala',
    'filterlistmodel.vala',
    'filterlistmodel_uifile.vala',

]

foreach t_file : sources
  t_name = t_file.split('.')[0]
  executable(t_name, t_file, dependencies: gtk_dep)
endforeach
