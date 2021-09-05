/*
 * Coupled with an Entry, the EntryCompletion object provides matching of text
 * to a list of entries, allowing the user to select a value.
*/

using Gtk;

public class Example : Gtk.Application
{
    private Gtk.ListStore liststore;
    private Entry entry;
    private EntryCompletion entrycompletion;

    public Example()
    {
        Object( application_id: "org.example.gtk4",
                flags: ApplicationFlags.HANDLES_OPEN);
    }

    protected override void activate() {
        var window = new Gtk.ApplicationWindow(this) {
            title= "EntryCompletion"
        };

        entry = new Entry();
        window.set_child(entry);

        liststore = new Gtk.ListStore(1, typeof(string));

        Gtk.TreeIter iter;
        liststore.append(out iter);
        liststore.set(iter, 0, "Oklahoma");
        liststore.append(out iter);
        liststore.set(iter, 0, "California");
        liststore.append(out iter);
        liststore.set(iter, 0, "Texas");
        liststore.append(out iter);
        liststore.set(iter, 0, "Connecticut");
        liststore.append(out iter);
        liststore.set(iter, 0, "Arizona");

        entrycompletion = new EntryCompletion();
        entrycompletion.set_model(liststore);
        entrycompletion.set_text_column(0);
        entrycompletion.set_popup_completion(true);
        entry.set_completion(entrycompletion);

        window.present();
    }

    public static int main(string[] args)
    {
        var app = new Example();
        return app.run(args);
    }
}
