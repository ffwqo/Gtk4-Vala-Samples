/*
 * The Paned widget provides two panels oriented vertically or horizontally.
 * Widgets can be added to the Paned container, with the separator between the
 * two panes being adjustable.
*/

using Gtk;
public class Example : Gtk.Application
{
    public Example()
    {
        Object( application_id: "org.example.gtk4",
                flags: ApplicationFlags.HANDLES_OPEN);
    }

    protected override void activate() {
        var window = new Gtk.ApplicationWindow(this) {
            title= "Box"
        };
        var paned = new Paned(Gtk.Orientation.VERTICAL);
        window.set_child(paned);

        var label1 = new Label("Paned area 1");
        paned.set_start_child(label1);

        var label2 = new Label("Paned area 2");
        paned.set_end_child(label2);
        window.present();
    }

    public static int main(string[] args)
    {
        var app = new Example();
        return app.run(args);
    }
}
