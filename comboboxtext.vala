/*
 * The ComboBoxText provides a simple dropdown menu to select values from a
 * list. Text is also permitted to be entered if the option is set.
*/

using Gtk;

public class Example : Gtk.Application
{
    private ComboBoxText comboboxtext;
    public Example()
    {
        Object( application_id: "org.example.gtk4",
                flags: ApplicationFlags.HANDLES_OPEN);
    }

    protected override void activate() {
        var window = new Gtk.ApplicationWindow(this) {
            title= "ComboBoxText"
        };

        comboboxtext = new ComboBoxText();
        comboboxtext.append_text("Madrid");
        comboboxtext.append_text("Valencia");
        comboboxtext.append_text("Seville");
        comboboxtext.append_text("Bilbao");
        comboboxtext.set_active(0);
        comboboxtext.changed.connect(on_comboboxtext_changed);
        window.set_child(comboboxtext);
        window.present();
    }

    private void on_comboboxtext_changed()
    {
        var selection = comboboxtext.get_active_text();
        stdout.printf("Selection is '%s'\n", selection);
    }

    public static int main(string[] args)
    {
        var app = new Example();
        return app.run(args);
    }
}
