
[GtkTemplate(ui="/ui_files/resources/filebrowser_old.ui")]
class ExampleWindow : Gtk.ApplicationWindow {

    [GtkCallback]
    private string test_func() {
        return "hello";
    }
    public ExampleWindow(Gtk.Application app) {
        Object(application : app);
    }
}
