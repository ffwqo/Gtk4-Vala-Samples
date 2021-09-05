/*
 * The StackSwitcher can be added to the Stack to provide a way to change the
 * visible child using buttons.
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
            title= "StackSwitcher"
        };

        var grid = new Grid();
        window.set_child(grid);

        var stackswitcher = new StackSwitcher();
        grid.attach(stackswitcher, 0, 0, 1, 1);

        var stack = new Stack();
        stack.set_vexpand(true);
        stack.set_hexpand(true);
        stackswitcher.set_stack(stack);
        grid.attach(stack, 0, 1, 1, 1);

        var label1 = new Label("Page 1 of Stack");
        stack.add_titled(label1, "Page1", "Page 1");

        var label2 = new Label("Page 2 of Stack");
        stack.add_titled(label2, "Page2", "Page 2");

        window.present();
    }

    public static int main(string[] args)
    {
        var app = new Example();
        return app.run(args);
    }
}
