/*
 * The Stack widget is similar to a Notebook in providing a container where the
 * visible object can be changed. On its own however, a Stack does not provide
 * a way for the user to change what is visible.
*/

using Gtk;

public class Example : Gtk.Application
{
    private Stack stack;
    public Example()
    {
        Object( application_id: "org.example.gtk4",
                flags: ApplicationFlags.HANDLES_OPEN);
    }

    protected override void activate() {
        var window = new Gtk.ApplicationWindow(this) {
            title= "Stack"
        };

        var grid = new Grid();
        window.set_child(grid);

        stack = new Stack();
        stack.set_vexpand(true);
        stack.set_hexpand(true);
        grid.attach(stack, 0, 0, 2, 1);

        var button1 = new Button.with_label("Page 1");
        button1.clicked.connect(on_button1_clicked);
        grid.attach(button1, 0, 1, 1, 1);
        var button2 = new Button.with_label("Page 2");
        button2.clicked.connect(on_button2_clicked);
        grid.attach(button2, 1, 1, 1, 1);

        var label1 = new Label("Page 1 of Stack");
        stack.add_named(label1, "Page1");

        var label2 = new Label("Page 2 of Stack");
        stack.add_named(label2, "Page2");

        window.present();
    }

    private void on_button1_clicked(Button button)
    {
        stack.set_visible_child_name("Page1");
    }

    private void on_button2_clicked(Button button)
    {
        stack.set_visible_child_name("Page2");
    }

    public static int main(string[] args)
    {
        var app = new Example();
        return app.run(args);
    }
}
