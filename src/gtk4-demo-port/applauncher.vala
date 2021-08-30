/*
 * Port of the Application Launcher example from gtk4-demo
 * with search and sorting via GtkSortListModel and GtkFilterListModel
 *
 * there is a bug where if you scroll too fast there will be a jump
 * https://gitlab.gnome.org/GNOME/gtk/-/issues/2971
 */
class Test : GLib.Object {
    public Test(string _x, int _y) { x = _x; y=_y;}
    public string x {get; set; } // property have to be public to be accessed
    public int y {get; set; }
}

class Example : Gtk.Application {
    public Example() {
        Object( application_id : "org.name.app",
                flags: GLib.ApplicationFlags.FLAGS_NONE);
    }
    static string app_info_get_display_name(GLib.AppInfo app_info) { //can also be outside but needs static in class definition
        var name = app_info.get_display_name();
        return name;
    }
    protected override void activate() {
        var window = new Gtk.ApplicationWindow(this) {
            title = "ApplicationLauncher",
            default_width = 500,
            default_height = 600
        };

        var mainbox = new Gtk.Box(Gtk.Orientation.VERTICAL, 5);



        var store = new GLib.ListStore(typeof(GLib.AppInfo));
        var apps = GLib.AppInfo.get_all();

        unowned var iter = apps.first();
        for( ; iter != null; iter = iter.next ) {
            store.append( iter.data );
        }


        var stringsorter = new Gtk.StringSorter( 
                new Gtk.CClosureExpression(typeof( string) , 
                                           null , {} , 
                                           (GLib.Callback) app_info_get_display_name, 
                                           null, null)   
        );
        var sortModel = new Gtk.SortListModel(store, stringsorter);
        var filter = new Gtk.StringFilter( 
                new Gtk.CClosureExpression(typeof( string) , 
                                           null , {} , 
                                           (GLib.Callback) app_info_get_display_name, 
                                           null, null)
        );
        var filterlistmodel = new Gtk.FilterListModel(sortModel, filter);
        filterlistmodel.set_incremental(true);

        var searchentry = new Gtk.SearchEntry();
        searchentry.placeholder_text = "Enter name to search..";
        searchentry.activate.connect( (entry) => {
            var text = entry.get_text();
            filter.set_search(text); //TODO maybe use g_object_bind_propertiy for this
        });
        mainbox.append(searchentry);

        var singleselection = new Gtk.SingleSelection(filterlistmodel);
        var signalfactory = new Gtk.SignalListItemFactory();
        signalfactory.setup.connect( (listitemfactory, listitem) => {

            var box = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 12);
            var image = new Gtk.Image();
            image.set_icon_size(Gtk.IconSize.LARGE);
            var label = new Gtk.Label("");
            box.append(image);
            box.append(label);
            listitem.set_child(box);
        });
        signalfactory.bind.connect( (listitemfactory, listitem) => {
            var box = (Gtk.Box) listitem.get_child();

            var image = (Gtk.Image) box.get_first_child();
            var label = (Gtk.Label) image.get_next_sibling();

            var obj = (GLib.AppInfo) listitem.get_item(); //returns the object 
            image.set_from_gicon( obj.get_icon() );
            label.set_label( obj.get_display_name() );
        });
        var listview = new Gtk.ListView(singleselection, signalfactory);
        listview.activate.connect( (lv, pos) => {
            var model = (GLib.ListModel) lv.get_model();
            var app_info = (GLib.AppInfo) model.get_item(pos);
            // print("%s\n", app_info.get_type().name() );

            var display = (Gdk.Display) lv.get_display();
            var context = display.get_app_launch_context();
            try {
                app_info.launch(null, context);
            } catch(Error e) {
                var dialog = new Gtk.MessageDialog( (Gtk.Window) lv.get_root() , 
                                       Gtk.DialogFlags.DESTROY_WITH_PARENT | Gtk.DialogFlags.MODAL,
                                       Gtk.MessageType.ERROR,
                                       Gtk.ButtonsType.CLOSE,
                                       "Could not launch %s", app_info.get_display_name());
                dialog.format_secondary_text("%s", e.message);
                dialog.show();
            }
        });
        var scroll = new Gtk.ScrolledWindow() {
            hexpand=true,
            vexpand=true
        };
        scroll.set_child(listview);
        mainbox.append(scroll);

        window.set_child(mainbox);
        window.present();
    }

    public static int main(string[] args)
    {
        var app = new Example();
        return app.run(args);
    }
}





