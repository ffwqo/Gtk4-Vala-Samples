/*
 * The Grid allows widgets to be placed horizontally and vertically across one
 * or more cells with options provided for spacing and sizing.
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
            title= "Grid"
        };

        var grid = new Grid() {
            row_spacing=5,
            column_spacing=5
        };
        window.set_child(grid);

        var button1 = new Button.with_label("Button 1");
        grid.attach(button1, 0, 0, 1, 1);
        var button2 = new Button.with_label("Button 2");
        grid.attach(button2, 1, 0, 1, 2);
        var button3 = new Button.with_label("Button 3");
        grid.attach(button3, 0, 1, 1, 1);

        window.present();
    }

    public static int main(string[] args)
    {
        var app = new Example();
        return app.run(args);
    }
}
