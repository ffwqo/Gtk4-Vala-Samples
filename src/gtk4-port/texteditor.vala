/*
 * TextView is a Gtk widget used to display text replicating the same appearance
 * of many text editors.
 * TODO fix some weird bug with SaveAs and input going to search instead of name field.
 */

public class Example : Gtk.Application {
    private const string TITLE = "My Text Editor";


    private Gtk.TextView text_view;
    private File file;

    public Example()
    {
        Object( application_id: "org.example.gtk4",
                flags: ApplicationFlags.HANDLES_OPEN);
    }

    protected override void activate() {
        var window = new Gtk.ApplicationWindow(this) {
            title= "TextEditor"
        };
        window.set_default_size (800, 600);
        string menuui = """
<?xml version="1.0" encoding="UTF-8"?>
  <interface>
    <menu id="menu">
      <section>
        <item>
          <attribute name="label" translatable="yes">_Open</attribute>
          <attribute name="action">app.mopen</attribute>
        </item>
      </section>
      <section>
        <item>
          <attribute name="label" translatable="yes">_Save</attribute>
          <attribute name="action">app.msave</attribute>
        </item>
      </section>
      <section>
        <item>
          <attribute name="label" translatable="yes">_Save As</attribute>
          <attribute name="action">app.msaveas</attribute>
        </item>
      </section>
      <section>
        <item>
          <attribute name="label" translatable="yes">_Quit</attribute>
          <attribute name="action">app.mquit</attribute>
        </item>
      </section>
    </menu>
  </interface>
""";
        var mopen = new GLib.SimpleAction("mopen", null);
        var msave = new GLib.SimpleAction("msave", null);
        var msaveas = new GLib.SimpleAction("msaveas", null);
        var mquit = new GLib.SimpleAction("mquit", null);
        mopen.activate.connect( () => {
            var filechooser = new Gtk.FileChooserDialog("Select a file to read", window, 
                                                        Gtk.FileChooserAction.OPEN,
                                                        "Cancel", Gtk.ResponseType.CANCEL,
                                                        "Open", Gtk.ResponseType.ACCEPT);
            filechooser.set_select_multiple(false);
            filechooser.show();
            filechooser.response.connect( (dialog, response) => { //dialog, int
                if( response == Gtk.ResponseType.ACCEPT) {
                    file = ((Gtk.FileChooserDialog)dialog).get_file();
                    if(file != null) {
                        set_text_buffer_content(file);
                    }
                } 
                dialog.destroy();
            });
            file = filechooser.get_file();
        });
        msave.activate.connect( () => {
            if( file != null) {
                try {
                    file.replace_contents (text_view.buffer.text.data, null, false, FileCreateFlags.NONE, null);
                } catch (Error e) {
                    stdout.printf ("Error: %s\n", e.message);
                }
            }
        });
        msaveas.activate.connect( () => {
            var filechooser = new Gtk.FileChooserDialog("Save current File as", window, 
                                                        Gtk.FileChooserAction.SAVE,
                                                        "Cancel",
                                                        Gtk.ResponseType.CANCEL,
                                                        "Save",
                                                        Gtk.ResponseType.ACCEPT);
            //filechooser.set_select_multiple(false);
            filechooser.show();
            filechooser.response.connect( (dialog, response) => {
                if(response == Gtk.ResponseType.ACCEPT) {
                    var nfile = ((Gtk.FileChooserDialog)dialog).get_file(); 
                    GLib.FileUtils.set_contents(nfile.get_path(), text_view.buffer.text);
                }
                dialog.destroy();
            });
        });
        mquit.activate.connect( () => {
            window.destroy();
        });
        this.add_action(mopen);
        this.add_action(msave);
        this.add_action(msaveas);
        this.add_action(mquit);

        var builder = new Gtk.Builder.from_string(menuui, menuui.length);
        var menu = (GLib.Menu) builder.get_object("menu");

        //version 1 
        //var menubtn = new Gtk.MenuButton();
        //menubtn.set_menu_model(menu);
        //var box = new Gtk.Box(Gtk.Orientation.VERTICAL, 5);
        //box.append(menubtn);
        //window.set_child(box);

        //version 2
        var menubar = new GLib.Menu();
        var menu_item_menu = new GLib.MenuItem("Menu", null);
        menu_item_menu.set_submenu(menu);
        menubar.append_item(menu_item_menu);
        this.set_menubar(menubar);
        window.set_show_menubar(true);
        window.present();

        text_view = new Gtk.TextView() {
            wrap_mode = Gtk.WrapMode.WORD
        };
        var scrolled = new Gtk.ScrolledWindow() {
            hexpand=true,
            vexpand=true
        };
        scrolled.set_policy(Gtk.PolicyType.AUTOMATIC, Gtk.PolicyType.AUTOMATIC);
        scrolled.set_child(text_view);
        window.set_child(scrolled);

    }
    private void set_text_buffer_content(GLib.File file) {
        /// ensure file is not full
        string content = "";

        try {
            GLib.FileUtils.get_contents(file.get_path(), out content);
        } catch(GLib.FileError fe) {
            stdout.printf("%s\n", fe.message);
            return;
        }
        text_view.buffer.set_text(content);
    }

    public static int main(string[] args)
    {
        var app = new Example();
        return app.run(args);
    }
}

