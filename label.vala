/*
 * The Label is commonly used for basic purposes such as displaying short
 * amounts of text. It does however provide a number of extra features allowing
 * the display of complex text layouts.
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
            title= "Label"
        };
        var vbox = new Box(Gtk.Orientation.VERTICAL, 5);
        vbox.set_spacing(5);
        window.set_child(vbox);

        var label1 = new Label("This is a single-line example.");
        vbox.append(label1);
        var label2 = new Label("This is a multiple\nline\nexample using new line breaks.");
        vbox.append(label2);

        var hbox = new Box(Gtk.Orientation.HORIZONTAL, 5);
        hbox.set_spacing(5);
        vbox.append(hbox);

        var label3 = new Label(null);
        label3.set_justify(Gtk.Justification.RIGHT);
        label3.set_label("This is an\nexample label\nright justified.");
        hbox.append(label3);
        var label4 = new Label(null);
        label4.set_justify(Gtk.Justification.CENTER);
        label4.set_markup("This is a\ncenter aligned\n label with <b>markup</b>.");
        hbox.append(label4);

        window.present();
    }

    public static int main(string[] args)
    {
        var app = new Example();
        return app.run(args);
    }
}
