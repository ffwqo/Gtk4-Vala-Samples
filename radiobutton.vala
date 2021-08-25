/*
 * A RadioButton is often combined with others to indicate the status from a
 * number of items. Each provides a label and display to indicate which of the
 * group is selected.
 *
 * GtkRadioButton was removed with gtk4 use a GtkCheckBox or GtkToogleButton instead
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
            title= "RadioButton"
        };

        var box = new Gtk.Box(Gtk.Orientation.VERTICAL, 5);

        var radio  = new Gtk.CheckButton.with_label("RadioButton 1");
        var radio2 = new Gtk.CheckButton.with_label("RadioButton 2");
        var radio3 = new Gtk.CheckButton.with_label("RadioButton 3");
        radio.toggled.connect(on_radiobutton_toggle);
        radio2.toggled.connect(on_radiobutton_toggle);
        radio3.toggled.connect(on_radiobutton_toggle);
        radio2.set_group(radio);
        radio3.set_group(radio);
        box.append(radio);
        box.append(radio2);
        box.append(radio3);

        window.set_child(box);
        window.present();

    }

    private void on_radiobutton_toggle(Gtk.CheckButton radiobutton)
    {
        if (radiobutton.get_active())
        {
            var label = radiobutton.get_label();
            print("%s toggled\n", label);
        }
    }
    public static int main(string[] args)
    {
        var app = new Example();
        return app.run(args);
    }
}
