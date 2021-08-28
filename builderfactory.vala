
/*
 * GtkListView example
 * Gtk4 introduces GListModel which only renders a part of the view of a complete 
 * List thus improving performance. Working with GListModel can be quite difficult the
 * blog is a good resource to learn more about the new ListWidgets
 *
 * https://blog.gtk.org/tag/lists/
 *
 * or this tutorial
 *
 * https://github.com/ToshioCP/Gtk4-tutorial/blob/main/gfm/sec25.md
 *
 * another source for good exampeles would be gtk4-demo and the tests in gtk/tests
 *
 * to use a GListView you need three things. 
 * 1. a GListModel which is your list of stuff 
 *    for example you have to wrap ["First", "Second", "Third"] in a GListStore
 *    via GListStore(typeof(listelement)) listelement can be any type thats derived from
 *    GObject
 * 2. a GtkSelectionModel to support selection of the Listitem via Mouse for example. Use
 *    GtkNoSelection for no selection
 * 3. a GtkListItemFactory to generate the ListItem once it should be rendered. The factory will
 *    emit a "setup" signal to setup the respective GtkListItem widget i.e. with a GtkLabel this 
 *    happens at the start and the GtkListItems are reused for the next instance.
 *    Afterwards once (or slightly before) the user scrolls into view the GtkListItem is constructed
 *    with the data supplied by the "bind" signal of the factory. This allows to get the underlying 
 *    object we wish to display. One used GtkListItem->item to get the object and assign the properties
 *    see the gtk blog above for better exampels.
 *    This structure can also be described by UI files instead of a <lookup name="memberVariable" type="Object">
 *    one could also use a closure and look up via a callback.
 *
 * tldr.
 *    1. setup model via GListStore
 *    2. select a SelectionModel
 *    3. construct your GtkListItemFactory either via Signals or Builder i.e. UI files. Use a gtkexpression
 *       to get the property of interest once its needed.
 *
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
    protected override void activate() {
        var window = new Gtk.ApplicationWindow(this) {
            title = "ApplicationLauncher",
            default_width = 500,
            default_height = 600
        };

        var store = new GLib.ListStore(typeof(Test));
        for(int i = 0; i < 100; ++i) {
            store.append(new Test("some common question my man " + i.to_string(), i));
        }

        var builder = new Gtk.Builder.from_string(listui, listui.length);
        var singleselection = (Gtk.SingleSelection) builder.get_object("singleselection");
        singleselection.set_model(store);
        var listview = (Gtk.ListView) builder.get_object("list");
        var scroll = new Gtk.ScrolledWindow();
        scroll.set_child(listview);
        window.set_child(scroll);

        window.present();
    }


    public static int main(string[] args)
    {
        var app = new Example();
        return app.run(args);
    }

        string listui = """
<interface>
  <object class="GtkListView" id="list">
    <property name="model">
      <object class="GtkSingleSelection" id="singleselection">
      </object>
    </property>
    <property name="factory">
      <object class="GtkBuilderListItemFactory">
        <property name="bytes"><![CDATA[
<interface>
  <template class="GtkListItem">
    <property name="child">
      <object class="GtkLabel">
        <binding name="label">
          <lookup name="x" type="Test">
            <lookup name="item">GtkListItem</lookup>
          </lookup>
        </binding>
      </object>
    </property>
  </template>
</interface>
      ]]></property>
      </object>
    </property>
  </object>
</interface>
""";
}





