/*
 * The FontButton provides the user with a button and dialog from which to
 * choose a font type, size, and styling options.
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
            title= "FontButton"
        };

        var fontbutton = new FontButton();
        fontbutton.font_set.connect(on_fontbutton_changed);
        window.set_child(fontbutton);
        window.present();
    }

    public void on_fontbutton_changed(FontButton fontbutton)
    {
        var font = fontbutton.get_font();
        stdout.printf("%s\n", (font));
    }

    public static int main(string[] args)
    {
        var app = new Example();
        return app.run(args);
    }
}
