/*
 *
 * Basic FileBrowser demonstrates launching a file with the default app, moving
 * along the filesystem, search, filter, etc.
 *
 * vala templte ui attributes and signal registration seems to be bugged thus
 * SignalListItemFactory is used rather than BuilderListItemFactory
 *
 * TODO
 * - [] implement view by column blocks like on elementary finder
 *
 */


class PathBox : Gtk.Box {
    public PathBox( string _curr) {
        Object(orientation : Gtk.Orientation.HORIZONTAL,
               spacing: 0);
        curr_path = _curr;

        Gtk.Button temp;
        length = 0;
        string_builder = new GLib.StringBuilder();

        foreach(var slice in curr_path.split("/") ) {

            if ( slice == "" ) {
                continue;
            }

            temp = new Gtk.Button.with_label( slice );
            temp.clicked.connect( (btn) => {
                move_up(btn);
            });

            this.append( temp );
            length += 1;
        }
    }

    public void move_down(string dir_name) {
        //move a dir down i.e. open a directory
        var temp = new Gtk.Button.with_label( dir_name );
        temp.clicked.connect( (btn) => {
            move_up(btn);
        });
        string_builder.assign(curr_path + "/" + temp.get_label() );
        curr_path = string_builder.str;
        this.append(temp);
        length += 1;
    }

    public void move_up(Gtk.Button btn) {
        //move a dir up

        //check if path needs to be updated;
        if( btn.get_next_sibling() == null ) {
            return;
        }
        var temp_string_list = new GLib.List<string>();
        temp_string_list.append( btn.get_label() );
        for( var prev = (Gtk.Button) btn.get_prev_sibling() ; 
                 prev != null ; 
                 prev = (Gtk.Button) prev.get_prev_sibling() ) 
        {

            temp_string_list.append(prev.get_label());
        }

        for( var next = (Gtk.Button) btn.get_next_sibling() ; 
                 next != null ; ) 
        {
            var temp2 = next;
            next = (Gtk.Button) next.get_next_sibling();
            this.remove(temp2);
            length -= 1;
        }

        temp_string_list.reverse();
        string_builder.assign("");
        foreach(var entry in temp_string_list) {
            string_builder.append( "/" + entry);
        }
        curr_path = string_builder.str ;
        dir_changed(string_builder.str ); //emits
    }

    public signal void dir_changed(string new_path);
    public string curr_path;
    public int length;
    private GLib.StringBuilder string_builder;

}

[GtkTemplate(ui = "/ui_files/resources/filebrowser.ui")]
class ExampleWindow : Gtk.ApplicationWindow {

    [GtkChild]
    private unowned Gtk.Box headerbox;
    [GtkChild]
    private unowned Gtk.Box mainbox;


    [GtkChild]
    private unowned Gtk.ScrolledWindow scroll;
    [GtkChild]
    private unowned Gtk.ListView listview;
    [GtkChild]
    private unowned Gtk.GridView gridview;
    [GtkChild]
    private unowned Gtk.SignalListItemFactory signalfactory;
    [GtkChild]
    private unowned Gtk.StringSorter stringsorter;

    [GtkChild]
    private unowned Gtk.FilterListModel filterlist;
    private Gtk.EveryFilter multifilter;

    [GtkChild]
    private unowned Gtk.DirectoryList dlist;

    [GtkChild]
    private unowned Gtk.SearchEntry searchentry;

    public ExampleWindow(Gtk.Application app) {
        Object(application : app);


        stringsorter.set_expression( new Gtk.CClosureExpression(typeof( string) , 
                                           null , {} , 
                                           (GLib.Callback) get_file_name_sort, 
                                         null, null) );


        multifilter = new Gtk.EveryFilter();
        var dotfilter = new Gtk.FileFilter();
        dotfilter.add_pattern("[!.]*");
        multifilter.append(dotfilter);
        filterlist.set_filter(multifilter);

        searchentry.placeholder_text = "Filter";
        searchentry.search_changed.connect( (entry) => {
            var expression = new Gtk.CClosureExpression(typeof( string) , 
                                               null , {} , 
                                               (GLib.Callback) get_file_name_sort, 
                                             null, null);
            var stringfilter = new Gtk.StringFilter(expression);
            stringfilter.set_match_mode(Gtk.StringFilterMatchMode.SUBSTRING);
            stringfilter.set_ignore_case(true);
            stringfilter.set_search( entry.get_text() );

            if( multifilter.get_n_items() > 1) {
                multifilter.remove( multifilter.get_n_items() -1);
            }

            multifilter.append(stringfilter);
        });

        //style the button
        scroll.set_child(gridview);
        var variant_param = new GLib.Variant.string("grid");
        var res = variant_param.get_string();
        var css_provider = new Gtk.CssProvider();
        string css_string;
        switch(res) {
            case "list":
                css_string = ".listbtn { background: silver; } .gridbtn { background: white; }";
                break;
            case "grid":
                css_string = ".gridbtn { background: silver; } .listbtn { background: white; }";
                break;
            default:
                css_string = "";
                break;
        };
        css_provider.load_from_data( css_string.data );
        Gtk.StyleContext.add_provider_for_display( this.get_display() , css_provider, Gtk.STYLE_PROVIDER_PRIORITY_USER );
        
        var action = new GLib.SimpleAction.stateful("view", GLib.VariantType.STRING  , variant_param );
        action.activate.connect( (param) => {

            switch(param.get_string() ) {
                case "list":
                    css_string = ".listbtn { background: silver; } .gridbtn { background: white; }";
                    scroll.set_child(listview);
                    break;
                case "grid":
                    css_string = ".gridbtn { background: silver; } .listbtn { background: white; }";
                    scroll.set_child(gridview);
                    break;
                default:
                    break;
            };
            css_provider.load_from_data( css_string.data );
            action.change_state(param);
        });
        this.add_action(action);

        var curr = GLib.Environment.get_current_dir();
        var filecurr = GLib.File.new_for_path(curr);
        dlist.set_file(filecurr);


        var pathbox = new PathBox(curr);
        mainbox.prepend(pathbox);

        pathbox.dir_changed.connect( (path) => {
            dlist.set_file( GLib.File.new_for_path(path) );
        });

        gridview.activate.connect( (lv, pos) => {
            gridview_act_cb(lv, pathbox, pos);
        });
        listview.activate.connect( (lv, pos) => {
            listview_act_cb(lv, pathbox, pos);
        });



    }

    private void listview_act_cb( Gtk.ListView lv, PathBox pathbox, uint pos) {
        //TODO maybe handle more file types such as symbolic links or special
        var model = lv.get_model();
        var info = (GLib.FileInfo) model.get_item(pos);

        //handle dir
        if ( info.get_file_type() == GLib.FileType.DIRECTORY ) {
            pathbox.move_down( info.get_name() );
            pathbox.dir_changed(pathbox.curr_path); //emits
        }

        //rest
        if( info.get_file_type() == GLib.FileType.REGULAR ) {
            var temp_path = pathbox.curr_path + "/" + info.get_name();
            print("%s\n", temp_path);
            var temp_file = GLib.File.new_for_path( temp_path );
            var list = new GLib.List<string>();
            list.append(temp_path);
            print("%s\n", temp_file.get_uri() );

            var listapps = GLib.AppInfo.get_all_for_type( info.get_content_type() );
            if (listapps == null) {
                print("some\n");
            }
            foreach(var apps in listapps) {
                print("%s\n", ((GLib.AppInfo) apps).get_display_name() );
            }

            try {
                GLib.AppInfo.launch_default_for_uri( temp_file.get_uri() , null );

                //var appinfo = temp_file.query_default_handler();
                //appinfo.launch( null , null);
            } catch (Error e) {
                print("Error opening file: %s\n", e.message);
            }
        }
    }

    private void gridview_act_cb( Gtk.GridView lv, PathBox pathbox, uint pos) {
        //TODO maybe handle more file types such as symbolic links or special
        var model = lv.get_model();
        var info = (GLib.FileInfo) model.get_item(pos);

        //handle dir
        if ( info.get_file_type() == GLib.FileType.DIRECTORY ) {
            pathbox.move_down( info.get_name() );
            pathbox.dir_changed(pathbox.curr_path); //emits
        }

        //rest
        if( info.get_file_type() == GLib.FileType.REGULAR ) {
            var temp_path = pathbox.curr_path + "/" + info.get_name();
            print("%s\n", temp_path);
            var temp_file = GLib.File.new_for_path( temp_path );
            var list = new GLib.List<string>();
            list.append(temp_path);
            print("%s\n", temp_file.get_uri() );

            var listapps = GLib.AppInfo.get_all_for_type( info.get_content_type() );
            if (listapps == null) {
                print("some\n");
            }
            foreach(var apps in listapps) {
                print("%s\n", ((GLib.AppInfo) apps).get_display_name() );
            }

            try {
                GLib.AppInfo.launch_default_for_uri( temp_file.get_uri() , null );

                //var appinfo = temp_file.query_default_handler();
                //appinfo.launch( null , null);
            } catch (Error e) {
                print("Error opening file: %s\n", e.message);
            }
        }
    }

    static string get_file_name_sort(GLib.FileInfo info) {
        return info.get_name();
    }


    [GtkCallback]
    private void setup_items(Gtk.SignalListItemFactory model, Gtk.ListItem item) {

        var box = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 5);
        var image = new Gtk.Image() {
            icon_size = Gtk.IconSize.LARGE
        };
        var label = new Gtk.Label("");
        box.append(image);
        box.append(label);
        item.set_child(box);
    }

    [GtkCallback]
    private void bind_items(Gtk.SignalListItemFactory model, Gtk.ListItem item) {
        var box = (Gtk.Box) item.get_child();
        var image = (Gtk.Image) box.get_first_child();
        var label = (Gtk.Label) image.get_next_sibling();
        var info = (GLib.FileInfo) item.get_item();

        var thumbnail_path = info.get_attribute_byte_string("thumbnail::path");
        if( thumbnail_path == null) {
            image.set_from_gicon( info.get_icon() );
        }
        else {
            image.set_from_file( thumbnail_path );
        }
        label.set_label( info.get_name() );

    }


}




class Example : Gtk.Application {

    public Example() {
        Object( application_id : "org.name.app",
                flags: GLib.ApplicationFlags.FLAGS_NONE);
    }
    protected override void activate() {

        var window = new ExampleWindow(this);
        window.present();
    }

    public static int main(string[] args)
    {
        var app = new Example();
        return app.run(args);
    }
}





