/*
 * The Box container allows child widgets to be added in a horizontal or
 * vertical orientation, with customisations for the sizing on the added widget.
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
        var vbox = new Box(Gtk.Orientation.VERTICAL, 5);
        window.set_child(vbox);
        var button1 = new Button.with_label("Button 1");
        var button2 = new Button() {
            label="Button 2",
            margin_top=25,
            margin_bottom=25
        };
        vbox.append(button1);

        var hbox = new Box(Gtk.Orientation.HORIZONTAL, 5);
        vbox.append(hbox);

        var button3 = new Button.with_label("Button 3");
        hbox.append(button3);
        var button4 = new Button.with_label("Button 4");
        hbox.append(button4);
        vbox.append(button2);
        window.present();

    }

    public static int main(string[] args)
    {
        var app = new Example();
        return app.run(args);
    }
}
