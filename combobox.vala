/*
 * Similar to a ComboBoxText, the ComboBox allows selection of items from a
 * dropdown list. It provides more features, and is capable of displaying
 * options of different types other than text.
 *
 * CellRenderer are hard to setup use something like DropDown instead
*/

using Gtk;

public class Example : Gtk.Application
{
    private Gtk.ListStore liststore;
    private ComboBox combobox;
    private CellRendererText cellrenderertext;

    public Example()
    {
        Object( application_id: "org.example.gtk4",
                flags: ApplicationFlags.HANDLES_OPEN);
    }

    protected override void activate() {
        var window = new Gtk.ApplicationWindow(this) {
            title= "ComboBox"
        };

        liststore = new Gtk.ListStore(1, typeof (string));
        Gtk.TreeIter iter;

        liststore.append(out iter);
        liststore.set(iter, 0, "Rafael Nadal", -1);
        liststore.append(out iter);
        liststore.set(iter, 0, "Roger Federer", -1);
        liststore.append(out iter);
        liststore.set(iter, 0, "Novak Djokovic", -1);

        cellrenderertext = new CellRendererText();

        combobox = new ComboBox();
        combobox.set_model(liststore);
        combobox.pack_start(cellrenderertext, true);
        combobox.add_attribute(cellrenderertext, "text", 0);
        combobox.changed.connect(on_combobox_changed);
        window.set_child(combobox);
        window.present();
    }

    private void on_combobox_changed()
    {
        Gtk.TreeIter iter;
        Value val;

        combobox.get_active_iter(out iter);
        liststore.get_value(iter, 0, out val);

        stdout.printf("Selection is '%s'\n", (string) val);
    }

    public static int main(string[] args)
    {
        var app = new Example();
        return app.run(args);
    }
}
