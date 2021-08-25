/*
 * The Button widget is commonly found in programs and used to launch processes
 * and operations.
*/

using Gtk;

public class Example : Gtk.Application
{
    private Button button;
    public Example()
    {
        Object( application_id: "org.example.gtk4",
                flags: ApplicationFlags.HANDLES_OPEN);
    }

    protected override void activate() {
        var window = new Gtk.ApplicationWindow(this) {
            title= "Button"
        };

        var box = new Box(Gtk.Orientation.VERTICAL, 5);
        window.set_child(box);

        button = new Button.with_label("Button 1");
        button.clicked.connect(on_button_clicked);
        box.append(button);
        button = new Button();
        button.set_label("Button 2");
        button.clicked.connect( () => {
            stdout.printf("%s clicked\n", button.get_label());
        });
        box.append(button);

        window.present();
    }

    private void on_button_clicked(Button button)
    {
        var label = button.get_label();
        stdout.printf("%s clicked\n", label);
    }

    public static int main(string[] args)
    {
        var app = new Example();
        return app.run(args);
    }

}
