/*
 * Similar to a ComboBox but this time its based around a GListModel which 
 * should be easier to use. Note the use of dropdown.notify[property] which emits
 * when a set_<property> is called.
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
            title= "Dropdown"
        };

        string[] names = {
                        "Rafael Nadal",
                        "Roger Federer",
                        "Novak Dojokovic"
        };
        var dropdown = new Gtk.DropDown.from_strings(names);
        dropdown.notify["selected"].connect(() => {
            stdout.printf("%s\n", names[dropdown.get_selected()]);
        });
        window.set_child(dropdown);
        window.present();
    }

    public static int main(string[] args)
    {
        var app = new Example();
        return app.run(args);
    }
}
