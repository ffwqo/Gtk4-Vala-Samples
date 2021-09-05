



public class Example : Gtk.Application
{
    public Example()
    {
        Object( application_id: "org.example.gtk4",
                flags: ApplicationFlags.HANDLES_OPEN);
    }

    protected override void activate() {
        var window = new ExampleWindow(this) {
            title= "Box"
        };
        window.present();

    }

    public static int main(string[] args)
    {
        var app = new Example();
        return app.run(args);
    }
}

