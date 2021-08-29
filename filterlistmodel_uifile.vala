/*
 * GtkFilterListModel and GtkSortListModel
 *
 * The GtkStringSorter expression is quite tricky probably its better to use 
 * attributes and decalre the callback via [GtkCallbakc] and specifcy a [GtkTemplate]
 * for the class otherwise the builder cannot find the callback (here get_name_test)
 *
 * disscussion on the same problem https://discourse.gnome.org/t/gtk-cclosureexpression-in-vala/3688/17
 * writing the function outside the class did not help!
 *
 * perhaps someone else might have a better idea..
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

    static string get_name_test(Test t) { //has to be static otherwise won't work
        return t.x;
    }
    protected override void activate() {
        var window = new Gtk.ApplicationWindow(this) {
            title = "ApplicationLauncher",
            default_width = 500,
            default_height = 600
        };
        var box = new Gtk.Box(Gtk.Orientation.VERTICAL, 25);




        var store = new GLib.ListStore( typeof (Test) );
        store.append( new Test("Robert Weiss"));
        store.append( new Test("Amamlie Nobert"));
        store.append( new Test("Sigmund gobel"));
        store.append( new Test("Harry nom"));
        store.append( new Test("Gustaf Heid"));
        store.append( new Test("Wenry Moon"));
        store.append( new Test("Florian Singer"));
        store.append( new Test("Vincent Main"));
        store.append( new Test("Cindy Marshall"));
        store.append( new Test("Quxotant Joe"));



        string filterUI = """

            <interface>
              <object class="GtkFilterListModel" id="filterlistmodel">
                <property name="model">
                  <object class="GtkSortListModel" id="sortlistmodel"> 
                    <property name="sorter">
                      <object class="GtkStringSorter" id="stringsorter">
                      </object>
                    </property>
                  </object>
                </property>
                <property name="filter">
                  <object class="GtkStringFilter" id="stringfilter">
                    <property name="match_mode">substring</property>
                    <property name="expression">
                      <lookup name="x" type="Test">
                      </lookup>
                    </property>
                  </object>
                </property>
              </object>
            </interface>

            """;

        var builder = new Gtk.Builder.from_string(filterUI, filterUI.length );
        var filter = (Gtk.StringFilter) builder.get_object("stringfilter");
        var filter_model = (Gtk.FilterListModel) builder.get_object("filterlistmodel");
        var sortlistmodel = (Gtk.SortListModel) builder.get_object("sortlistmodel");

        sortlistmodel.items_changed.connect( (model) => {
            var pending = ((Gtk.SortListModel)model).get_pending();
            print("%u\n", pending);
        });

        var stringsorter = (Gtk.StringSorter) builder.get_object("stringsorter");
        var expression = new Gtk.CClosureExpression( typeof(string)
                                                     , null , { }, 
                                                     (GLib.Callback) get_name_test,
                                                     null, null);
        stringsorter.set_expression(expression);


        sortlistmodel.set_model(store);

        var searchentry = new Gtk.SearchEntry();
        searchentry.placeholder_text = ("Enter name to filter");
        searchentry.activate.connect( (entry) => {
            var text = entry.get_text() ;
            filter.set_search(text);
        });

        box.append(searchentry);


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





