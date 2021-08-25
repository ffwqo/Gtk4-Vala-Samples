/*
 * The FlowBox positions child widgets either horizontally or vertically
 * depending on how much size the container is allocated. Widgets are moved
 * dynamically as the container changes size and shape.
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
            title= "FlowBox"
        };

        var flowbox = new FlowBox();
        window.set_child(flowbox);

        var button = new Button.with_label("Button in FlowBox");
        flowbox.insert(button, 0);

        var togglebutton = new ToggleButton.with_label("ToggleButton in FlowBox");
        flowbox.insert(togglebutton, 1);

        var checkbutton = new CheckButton.with_label("CheckButton in FlowBox");
        flowbox.insert(checkbutton, -1);

        window.present();
    }

    public static int main(string[] args)
    {
        var app = new Example();
        return app.run(args);
    }
}
