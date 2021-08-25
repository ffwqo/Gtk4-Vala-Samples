/*
 * The Scale widget provides a way for adjusting values between a set range,
 * with the user sliding a knob to the preferred value.
*/

using Gtk;

public class Example : Gtk.Application
{
    private Scale scale;
    public Example()
    {
        Object( application_id: "org.example.gtk4",
                flags: ApplicationFlags.HANDLES_OPEN);
    }

    protected override void activate() {
        var window = new Gtk.ApplicationWindow(this) {
            title= "Scale"
        };
        window.set_default_size(400, 400);

        scale = new Scale.with_range(Gtk.Orientation.VERTICAL, 0, 100, 1);
        scale.set_value(50);
        scale.adjustment.value_changed.connect(on_scale_changed);
        window.set_child(scale);

        window.present();
    }

    private void on_scale_changed(Adjustment adjustment)
    {
        var value = scale.get_value();
        stdout.printf("%.2f\n", value);
    }

    public static int main(string[] args)
    {
        var app = new Example();
        return app.run(args);
    }
}
