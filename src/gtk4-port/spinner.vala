/*
 * The Spinner widget provides an animated indicator of activity in the program,
 * and is useful to indicate a long-running task.
*/

using Gtk;

public class Example : Gtk.Application
{
    private Spinner spinner;
    public Example()
    {
        Object( application_id: "org.example.gtk4",
                flags: ApplicationFlags.HANDLES_OPEN);
    }

    protected override void activate() {
        var window = new Gtk.ApplicationWindow(this) {
            title= "Spiiner"
        };
        window.set_default_size(400, 400);

        var grid = new Gtk.Grid();
        window.set_child(grid);

        var buttonStart = new Gtk.Button.with_label("Start");
        buttonStart.clicked.connect(on_start_button_clicked);
        grid.attach(buttonStart, 0, 1, 1, 1);
        var buttonStop = new Gtk.Button.with_label("Stop");
        buttonStop.clicked.connect(on_stop_button_clicked);
        grid.attach(buttonStop, 1, 1, 1, 1);

        spinner = new Spinner();
        spinner.set_vexpand(true);
        spinner.set_hexpand(true);
        grid.attach(spinner, 0, 0, 2, 1);

        window.present();
    }

    private void on_start_button_clicked(Button button)
    {
        spinner.start();
    }

    private void on_stop_button_clicked(Button button)
    {
        spinner.stop();
    }


    public static int main(string[] args)
    {
        var app = new Example();
        return app.run(args);
    }
}

