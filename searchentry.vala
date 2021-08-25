/*
 * A SearchEntry has an appearance similar to a standard Entry, but is tailored
 * for use when being used to provide search functionality.
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
            title= "SearchEntry"
        };

        var searchentry = new SearchEntry();
        searchentry.placeholder_text="Enter search text...";
        searchentry.activate.connect(on_searchentry_activated);
        window.set_child(searchentry);
        window.present();
    }

    public void on_searchentry_activated(Gtk.SearchEntry searchentry)
    {
        var text = searchentry.get_text();
        stdout.printf("%s\n", text);
    }

    public static int main(string[] args)
    {
        var app = new Example();
        return app.run(args);
    }
}
