# Gtk4 Vala Sampels

Collection of vala samples.  Gtk4 version of the original
[vala-gtk-exampels](https://github.com/gerito1/vala-gtk-examples) and ports of
the gtk4-demo and some other applications/experiments.

Use 

```
meson build
```

in the root directory to generate the build files and then either 

```
ninja -C build 
```

to build every example or 

```
ninja -C build <file_path>
#for example
ninja -C build src/gtk4-demo/applauncher
```

to build a specific example.

# Deprecated
According to [gtk4 docs](https://docs.gtk.org/gtk4/migrating-3to4.html) these were deprecated

- GtkButtonbox
- GtkFileChooserButton
- GtkRadioButton
- GtkMenu
- GtkMenuBar
- GtkMenuItem
- GtkToolButton ?? 

# TODO 

- [] need to figure out which GtkSourceView version works with gtk4
- [] same problem with webkit2gtk
- [] port Valadoc examples
- [] maybe a full application and/or port of gtk4-demo, widget factory
    - [x] applauncher
    - [] filebrowser with thumbnails and different views
    - [] shadertoy version maybe a vertex shader art version instead

---- 

For more information and links see 

[vala-gtk-exampels](https://github.com/gerito1/vala-gtk-examples)

[valadoc](https://valadoc.org/gtk4/index.htm)

[gtk docs](https://docs.gtk.org/gtk4/)


