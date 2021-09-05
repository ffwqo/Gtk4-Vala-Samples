/*
 * The ListBox widget provides a vertical container holding ListBoxRow children.
 * The children are created automatically when another widget is added.. The
 * container also provides sorting and filtering, allowing more complex layouts
 * than can be achieved via a CellRenderer.
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
            title= "ListBox",
            default_width=400,
            default_height=200
        };

        var listbox = new ListBox();
        window.set_child(listbox);

        var label1 = new Label("Label 1");
        listbox.insert(label1, -1);

        var label2 = new Label("Label 2");
        listbox.insert(label2, -1);

        var label3 = new Label("Label 3");
        listbox.insert(label3, -1);

        window.present();
    }

    public static int main(string[] args)
    {
        var app = new Example();
        return app.run(args);
    }
}
