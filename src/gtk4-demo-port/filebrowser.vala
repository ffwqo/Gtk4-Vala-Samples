/*
 * Port of the FileBrowser demo with search as FilterListModel, sort via SortListModel,
 * thumbnail are set over THUMBNAIL_PATH that often fails to load.
 *
 * When using GtkHeaderBar is the application kills itself once I rightclick on
 * the title bar I assume its because of some weird kde/gtk bug where a single
 * rightclick is registered as two clicks and the close button is triggered as
 * the frist element by default.
 *
 * ListView is buggy when scrolling..
 *
 * TODO 
 * - [] offer a details view 
 * - [] a switch between the both
 * - [] save scroll position
 * - [] context menu to hide dotfiles via a MultiFilter
 * - [] look into alternatives to THUMBNAIL_PATH
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
    static string get_file_name(GLib.FileInfo file_info) { //can also be outside but needs static in class definition
        var name = file_info.get_name();
        return name;
    }
    protected override void activate() {
        var window = new Gtk.ApplicationWindow(this) {
            default_width = 500,
            default_height = 600
        };

        var mainbox = new Gtk.Box(Gtk.Orientation.VERTICAL, 5);
        var headerbar = new Gtk.HeaderBar();
        window.set_titlebar(headerbar);
        //mainbox.append(headerbar);
        var _hbox = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 25);
        var backbtn = new Gtk.Button.with_label("Back");
        var numberOfFilesLabel = new Gtk.Label("Loading...");
        _hbox.append(backbtn);
        _hbox.append(numberOfFilesLabel);
        mainbox.append(_hbox);


        var current_dir = GLib.Environment.get_current_dir();
        var file_path = GLib.File.new_for_path(current_dir);
        var attributes = "standard::name,standard::size,standard::icon,thumbnail::path";
        var store = new Gtk.DirectoryList( attributes, file_path );
        //print("%s\n", GLib.FileAttribute.STANDARD_NAME);
        //print("%s\n", GLib.FileAttribute.STANDARD_SIZE);
        //print("%s\n", GLib.FileAttribute.STANDARD_ICON);
        //print("%s\n", GLib.FileAttribute.THUMBNAIL_PATH);

        store.items_changed.connect( () => {
            window.set_title( store.get_file().get_path() );
        });
        store.notify["loading"].connect( (loading) => { // once its finished loading set the window title.
            var total_files = store.get_n_items();
            numberOfFilesLabel.set_label( @"Number of files: $total_files");
        });


        var stringsorter = new Gtk.StringSorter( 
                new Gtk.CClosureExpression(typeof( string) , 
                                           null , {} , 
                                           (GLib.Callback) get_file_name, 
                                           null, null)   
        );
        var sortModel = new Gtk.SortListModel(store, stringsorter);

        var filter = new Gtk.StringFilter( 
                new Gtk.CClosureExpression(typeof( string) , 
                                           null , {} , 
                                           (GLib.Callback) get_file_name, 
                                           null, null)
        );
        filter.set_match_mode(Gtk.StringFilterMatchMode.SUBSTRING);

        var searchsentry = new Gtk.SearchEntry();
        searchsentry.placeholder_text = "Search for file..";
        searchsentry.activate.connect( (entry) => {
            filter.set_search(entry.get_text() );
            print(@"$(entry.get_text())\n");
        });
        mainbox.append(searchsentry);
        var filterlistmodel = new Gtk.FilterListModel(sortModel, filter);
        filterlistmodel.set_incremental(true);
        filterlistmodel.items_changed.connect( () => { // update title
            var total_files = filterlistmodel.get_n_items();
            numberOfFilesLabel.set_label( @"Number of files: $total_files");
        });

        var singleselection = new Gtk.NoSelection(filterlistmodel);
        var signalfactory = new Gtk.SignalListItemFactory();
        signalfactory.setup.connect( (listitemfactory, listitem) => {

            var box = new Gtk.Box(Gtk.Orientation.VERTICAL, 5);
            var image = new Gtk.Image();
            //image.set_icon_size(Gtk.IconSize.LARGE);
            image.set_pixel_size( 200);
            var label = new Gtk.Label("");
            label.set_wrap(true);
            label.set_wrap_mode(Pango.WrapMode.WORD_CHAR);
            //label.set_halign(Gtk.Align.BASELINE);
            box.append(image);
            box.append(label);
            listitem.set_child(box);
        });
        signalfactory.bind.connect( (listitemfactory, listitem) => {
            var box = (Gtk.Box) listitem.get_child();
            var image = (Gtk.Image) box.get_first_child();
            var label = (Gtk.Label) image.get_next_sibling();

            var obj = (GLib.FileInfo) listitem.get_item(); //returns the object 
            var icon = obj.get_icon();
            var name = obj.get_name();

            var preview = obj.get_attribute_byte_string("thumbnail::path");
            if(preview != null) {
                image.set_from_file(preview);
                print(@"$preview\n");
            }
            else {
                image.set_from_gicon( icon );
            }

            label.set_label( name );
        });

        var listview = new Gtk.GridView(singleselection, signalfactory);
        //listview.set_min_columns(3);
        listview.activate.connect( (lv, pos) => { // clicked?
            var model = (GLib.ListModel) lv.get_model();
            var fileinfo = (GLib.FileInfo) model.get_item(pos);
            var new_path = file_path.get_path() + "/" + fileinfo.get_name();
            if (fileinfo.get_file_type() == GLib.FileType.DIRECTORY) {
                print("%s\n", new_path);
                file_path = GLib.File.new_for_path(new_path);
                store.set_file(file_path);
                filter.set_search("");
                searchsentry.set_text("");
            }
            else {
                print("%s\n", new_path );
            }
        });
        backbtn.clicked.connect( () => {
            var new_path = file_path.get_path();
            var pos = new_path.last_index_of("/");
            new_path = new_path.splice(pos, new_path.length, "");
            file_path = GLib.File.new_for_path(new_path);
            store.set_file(file_path);
            filter.set_search("");
            searchsentry.set_text("");
        });
        var scroll = new Gtk.ScrolledWindow() {
            hexpand=true,
            vexpand=true
        };
        scroll.set_child(listview);
        mainbox.append(scroll);

        window.set_child(mainbox);
        window.set_focus(scroll);
        window.present();
    }

    public static int main(string[] args)
    {
        var app = new Example();
        return app.run(args);
    }
}





