/*
 * A Notebook can be used to provide tabulated pages on which different content
 * can be added.
*/

using Gtk;

public class Example : Gtk.Application
{
    private Notebook notebook;
    public Example()
    {
        Object( application_id: "org.example.gtk4",
                flags: ApplicationFlags.HANDLES_OPEN);
    }

    protected override void activate() {
        var window = new Gtk.ApplicationWindow(this) {
            title= "Notebook"
        };
        window.set_default_size(200, 200);
        notebook = new Notebook();
        window.set_child(notebook);

        int count;

        for (count = 1; count <= 3; count++)
        {
            var text1 = "Tab %i".printf(count);

            var label = new Label(null);
            label.set_label(text1);

            var text2 = "Button %i in Tab %i".printf(count, count);

            var button = new Button.with_label(text2);
            notebook.append_page(button, label);
        }

        window.present();
    }

    public static int main(string[] args)
    {
        var app = new Example();
        return app.run(args);
    }
}
