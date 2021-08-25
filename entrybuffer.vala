/*
 * The EntryBuffer object provides a way to store text held in an Entry, with
 * functionality for handling the text and sharing to other Entry widgets.
*/

using Gtk;

public class Example : Gtk.Application
{
    private Entry entry;
    private EntryBuffer entrybuffer;
    public Example()
    {
        Object( application_id: "org.example.gtk4",
                flags: ApplicationFlags.HANDLES_OPEN);
    }

    protected override void activate() {
        var window = new Gtk.ApplicationWindow(this) {
            title= "EntryBuffer"
        };

        var grid = new Box(Gtk.Orientation.HORIZONTAL, 5);
        window.set_child(grid);

        unowned uint8[] text = (uint8[]) "Entry with EntryBuffer";
        entrybuffer = new EntryBuffer(text);

        entry = new Entry();
        entry.set_buffer(entrybuffer);
        grid.append(entry);

        entry = new Entry();
        entry.set_buffer(entrybuffer);
        grid.append(entry);

        entry = new Entry();
        entry.set_buffer(entrybuffer);
        grid.append(entry);

        window.present();
    }

    public static int main(string[] args)
    {
        var app = new Example();
        return app.run(args);
    }
}
