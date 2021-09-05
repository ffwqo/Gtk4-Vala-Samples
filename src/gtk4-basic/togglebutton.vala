/*
 * ToggleButton widgets is used to indicate whether something is active or not,
 * with the appearance of a standard Button widget.
*/

using Gtk;
public class Example : Gtk.Application
{

    private ToggleButton togglebutton;
    public Example()
    {
        Object( application_id: "org.example.gtk4",
                flags: ApplicationFlags.HANDLES_OPEN);
    }

    protected override void activate() {
        var window = new Gtk.ApplicationWindow(this) {
            title= "ToggleButton"
        };

        var box = new Box(Gtk.Orientation.VERTICAL, 5);
        window.set_child(box);

        togglebutton = new ToggleButton();
        togglebutton.set_label("ToggleButton 1");
        togglebutton.toggled.connect(on_checkbutton_toggle);
        box.append(togglebutton);
        togglebutton = new ToggleButton();
        togglebutton.set_label("ToggleButton 2");
        togglebutton.toggled.connect(on_checkbutton_toggle);
        box.append(togglebutton);

        window.present();
    }

    private void on_checkbutton_toggle(ToggleButton togglebutton)
    {
        var active = togglebutton.get_active();
        var label = togglebutton.get_label();

        if (active == true)
            stdout.printf("%s toggled on\n", label);
        else
            stdout.printf("%s toggled off\n", label);
    }

    public static int main(string[] args)
    {
        var app = new Example();
        return app.run(args);
    }
}
