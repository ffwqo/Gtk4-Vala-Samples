/*
 * GtkFilterListModel
 * Example usage of GtkFilterListModel and GtkStringFilter for a general
 * introduction to GListModel see signalfactory.vala
 */
class Test : GLib.Object {
    public Test(string _x) { x = _x;}
    public string x {get; set; } // property have to be public to be accessed
}

class Example : Gtk.Application {
    public Example() {
        Object( application_id : "org.name.app",
                flags: GLib.ApplicationFlags.FLAGS_NONE);
    }
    protected override void activate() {
        var window = new Gtk.ApplicationWindow(this) {
            title = "ApplicationLauncher",
            default_width = 500,
            default_height = 600
        };
        var box = new Gtk.Box(Gtk.Orientation.VERTICAL, 25);


        //var store = new Gtk.StringList( { // need to change PropertyExpression: "x" -> "string"; bind signal: obj.x -> get_string()
        //    "Robert Weiss",
        //    "Amamlie Nobert",
        //    "Sigmund gobel",
        //    "Harry nom",
        //    "Gumby the dea"
        //});

        var store = new GLib.ListStore( typeof (Test) );
        store.append( new Test("Robert Weiss"));
        store.append( new Test("Amamlie Nobert"));
        store.append( new Test("Sigmund gobel"));
        store.append( new Test("Harry nom"));
        store.append( new Test("Gumby the dea"));


        var filter = new Gtk.StringFilter(new Gtk.PropertyExpression( typeof( Test) , null, "x")); // get the property string from the type Gtk.StringObject
        filter.set_match_mode(Gtk.StringFilterMatchMode.SUBSTRING);
        var searchentry = new Gtk.SearchEntry();
        searchentry.placeholder_text = ("Enter name to filter");
        searchentry.activate.connect( (entry) => {
            var text = entry.get_text() ;
            filter.set_search(text);
        });

        box.append(searchentry);
        var filter_model = new Gtk.FilterListModel(store, filter);
        //filter_model.set_incremental(true);


        var singleselection = new Gtk.NoSelection(filter_model);
        var signalfactory = new Gtk.SignalListItemFactory();
        signalfactory.setup.connect( (listitemfactory, listitem) => {
            
            var label = new Gtk.Label(null);
            listitem.set_child(label); //add the label to the listitem which keeps it alive and uses it to render
        });
        signalfactory.bind.connect( (listitemfactory, listitem) => {
            var label = (Gtk.Label) listitem.get_child();
            var obj = (Test) listitem.get_item(); //returns the object 
            label.set_label( obj.x );
        });
        var listview = new Gtk.ListView(singleselection, signalfactory);
        var scroll = new Gtk.ScrolledWindow() {
            hexpand=true,
            vexpand=true
        };
        scroll.set_child(listview);
        box.append(scroll);

        window.set_child(box);
        window.present();
    }

    public static int main(string[] args)
    {
        var app = new Example();
        return app.run(args);
    }
}





