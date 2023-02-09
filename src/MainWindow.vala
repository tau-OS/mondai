[GtkTemplate (ui = "/com/fyralabs/Mondai/mainwindow.ui")]
public class Mondai.MainWindow : He.ApplicationWindow {
    public SimpleActionGroup actions { get; construct; }

    public const string ACTION_PREFIX = "win.";
    public const string ACTION_ABOUT = "about";

    private const GLib.ActionEntry[] ACTION_ENTRIES = {
        { ACTION_ABOUT, action_about }
    };

    private Gtk.ListBoxRow? selected;
    private string description = "";
    private string expected = "";
    private bool agreed_tos = false;

    [GtkChild]
    unowned He.AppBar appbar;
    [GtkChild]
    unowned Gtk.ScrolledWindow s;
    [GtkChild]
    unowned Gtk.ScrolledWindow s1;
    [GtkChild]
    unowned Gtk.ScrolledWindow s2;

    [GtkChild]
    unowned Gtk.Stack stack;

    [GtkChild]
    unowned He.PillButton to_describe;

    [GtkChild]
    unowned He.PillButton submit;

    public MainWindow (He.Application application) {
        Object (
                application: application,
                icon_name: Config.APP_ID,
                title: _("Mondai"),
                resizable: false
        );
    }

    public void action_about () {
        var about = new He.AboutWindow (
                                        this,
                                        "Mondai",
                                        Config.APP_ID,
                                        Config.VERSION,
                                        Config.APP_ID,
                                        "https://github.com/tau-os/mondai/tree/main/po",
                                        "https://github.com/tau-os/mondai/issues/new",
                                        "https://github.com/tau-os/mondai",
                                        // TRANSLATORS: 'Name <email@domain.com>' or 'Name https://website.example'
                                        {},
                                        { "Fyra Labs" },
                                        2022,
                                        He.AboutWindow.Licenses.GPLv3,
                                        He.Colors.DARK
        );
        about.present ();
    }

    [GtkCallback]
    private void on_listbox_row_selected (Gtk.ListBox self, Gtk.ListBoxRow? row) {
        this.selected = row;
        this.to_describe.sensitive = row != null;
    }

    [GtkCallback]
    private void on_description_textbuffer_changed (Gtk.TextBuffer self) {
        Gtk.TextIter start;
        Gtk.TextIter end;
        self.get_bounds (out start, out end);

        this.description = self.get_text (start, end, false);
        update_submit_state ();
    }

    [GtkCallback]
    private void on_expected_textbuffer_changed (Gtk.TextBuffer self) {
        Gtk.TextIter start;
        Gtk.TextIter end;
        self.get_bounds (out start, out end);

        this.expected = self.get_text (start, end, false);
        update_submit_state ();
    }

    [GtkCallback]
    private void on_checkbutton_toggled (Gtk.CheckButton self) {
        this.agreed_tos = self.active;
        update_submit_state ();
    }

    private void update_submit_state () {
        this.submit.sensitive = this.agreed_tos && this.description != "" && this.expected != "";
    }

    private async void submit_report () {
        var session = new Soup.Session ();
        var message = new Soup.Message ("POST", "https://mondai.fyralabs.com");

        var gen = new Json.Generator ();
        var root = new Json.Node (Json.NodeType.OBJECT);
        var object = new Json.Object ();
        root.set_object (object);
        gen.set_root (root);

        object.set_string_member ("product_id", ((Mondai.ProductItem) this.selected.child).product.id ());
        object.set_string_member ("description", this.description);
        object.set_string_member ("expected", this.expected);

        size_t length;
        var json = gen.to_data (out length);
        message.set_request_body_from_bytes ("application/json", new Bytes (json.data));
        yield session.send_async (message, Priority.DEFAULT, null);

        var status = message.get_status ();

        if (status != Soup.Status.CREATED) {
            error ("Server returned a non-created status");
        }
    }

    construct {
        actions = new SimpleActionGroup ();
        actions.add_action_entries (ACTION_ENTRIES, this);
        insert_action_group ("win", actions);

        stack.visible_child_name = "select";
        appbar.viewtitle_label = "";
        appbar.viewtitle_label = _("Select a component");
        appbar.show_back = false;
        appbar.scroller = s;

        to_describe.clicked.connect (() => {
            stack.visible_child_name = "describe";
            appbar.viewtitle_label = "";
            appbar.viewtitle_label = _("Describe the issue");
            appbar.scroller = s1;
            appbar.show_back = true;

            appbar.back_button.clicked.connect (() => {
                stack.visible_child_name = "select";
                appbar.viewtitle_label = "";
                appbar.viewtitle_label = _("Select a component");
                appbar.show_back = false;
                appbar.scroller = s;
            });
        });

        submit.clicked.connect (() => {
            submit_report.begin (() => {
                stack.visible_child_name = "submitted";
                appbar.viewtitle_label = "";
                appbar.viewtitle_label = _("Report submitted!");
                appbar.scroller = s2;

                appbar.back_button.clicked.connect (() => {
                    stack.visible_child_name = "describe";
                    appbar.viewtitle_label = "";
                    appbar.viewtitle_label = _("Describe the issue");
                    appbar.scroller = s1;
                });
            });
        });
    }
}