/*
 * An Entry is used to receive and display short lines of text, with functions
 * to handle the data.
*/

using Gtk;

public class Example : Gtk.Application
{
    private Entry entry;
    public Example()
    {
        Object( application_id: "org.example.gtk4",
                flags: ApplicationFlags.HANDLES_OPEN);
    }

    protected override void activate() {
        var window = new Gtk.ApplicationWindow(this) {
            title= "Entry"
        };

        entry = new Entry();
        entry.set_placeholder_text("Enter some text...");
        entry.activate.connect(on_entry_activated);
        window.set_child(entry);

        window.present();
    }

    public void on_entry_activated()
    {
        var text = entry.get_text();
        stdout.printf("%s\n", text);
    }

    public static int main(string[] args)
    {
        var app = new Example();
        return app.run(args);
    }
}
