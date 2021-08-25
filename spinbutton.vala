/*
 * A SpinButton provides a way to enter numbers either by textual entry from the
 * user, or by changing the value with up/down buttons. Ranges to limit the
 * value entered are able to be set.
*/

using Gtk;

public class Example : Gtk.Application
{
    private SpinButton spinbutton;
    public Example()
    {
        Object( application_id: "org.example.gtk4",
                flags: ApplicationFlags.HANDLES_OPEN);
    }

    protected override void activate() {
        var window = new Gtk.ApplicationWindow(this) {
            title= "SpinButton"
        };

        spinbutton = new SpinButton.with_range(0, 10, 1);
        spinbutton.set_value(2);
        spinbutton.value_changed.connect(on_spinbutton_changed);
        window.set_child(spinbutton);
        window.present();
    }

    private void on_spinbutton_changed(SpinButton spinbutton)
    {
        var value = spinbutton.get_value();
        stdout.printf("%.2f\n", value);
    }

    public static int main(string[] args)
    {
        var app = new Example();
        return app.run(args);
    }
}
