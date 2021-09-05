/*
 * The Separator is a sparsely used widget to visually separate content being
 * displayed. They can be horizontally or vertically oriented.
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
            title= "Separator"
        };
        window.set_default_size(400, 200);

        var grid = new Grid();
        window.set_child(grid);

        var hseparator = new Separator(Gtk.Orientation.HORIZONTAL);
        hseparator.set_vexpand(true);
        hseparator.set_hexpand(true);
        grid.attach(hseparator, 0, 0, 1, 1);

        var vseparator = new Separator(Gtk.Orientation.VERTICAL);
        vseparator.set_vexpand(true);
        vseparator.set_hexpand(true);
        grid.attach(vseparator, 1, 0, 1, 1);
        window.present();
    }

    public static int main(string[] args)
    {
        var app = new Example();
        return app.run(args);
    }
}
