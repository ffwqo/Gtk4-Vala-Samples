/*
 * The ActionBar container is often placed below the content of the window, and
 * is used to show contextual actions.
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
            title="ActionBar",
            default_width=200,
            default_height=200
        };

        var grid = new Grid() {
            row_spacing=5,
            column_spacing=5
        };
        window.set_child(grid);

        var label = new Label("") {
            vexpand=true
        };
        grid.attach(label, 0, 0, 1, 1);

        var actionbar = new ActionBar() {
            hexpand=true
        };
        grid.attach(actionbar, 0, 1, 1, 1);

        var button1 = new Button.with_label("Cut");
        actionbar.pack_start(button1);
        var button2 = new Button.with_label("Copy");
        actionbar.pack_start(button2);
        var button3 = new Button.with_label("Paste");
        actionbar.pack_end(button3);

        window.present();
    }

    public static int main(string[] args)
    {
        var app = new Example();
        return app.run(args);
    }
}
