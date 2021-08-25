/*
 * Similar to the RadioButton, the CheckButton combines a label and box to
 * indicate the current state. When the CheckButton is toggled, a tick is either
 * shown or hidden.
*/

using Gtk;

public class Example : Gtk.Application
{
    private CheckButton checkbutton;
    public Example()
    {
        Object( application_id: "org.example.gtk4",
                flags: ApplicationFlags.HANDLES_OPEN);
    }

    protected override void activate() {
        var window = new Gtk.ApplicationWindow(this) {
            title= "CheckButton"
        };

        checkbutton = new CheckButton();
        checkbutton.set_label("Toggle the CheckButton");
        checkbutton.toggled.connect(on_checkbutton_toggle);
        window.set_child(checkbutton);
        window.present();
    }

    private void on_checkbutton_toggle()
    {
        var active = checkbutton.get_active();

        if (active == true)
            stdout.printf("CheckButton toggled on\n");
        else
            stdout.printf("CheckButton toggled off\n");
    }

    public static int main(string[] args)
    {
        var app = new Example();
        return app.run(args);
    }
}
