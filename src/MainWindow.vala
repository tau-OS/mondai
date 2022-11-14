[GtkTemplate (ui = "/co/tauos/Mondai/mainwindow.ui")]
public class Mondai.MainWindow : He.ApplicationWindow {
    public SimpleActionGroup actions { get; construct; }

    public const string ACTION_PREFIX = "win.";
    public const string ACTION_ABOUT = "about";

    private const GLib.ActionEntry[] ACTION_ENTRIES = {
        { ACTION_ABOUT, action_about }
    };

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
            {"Lleyton"},
            2022,
            He.AboutWindow.Licenses.GPLv3,
            He.Colors.RED
        );
        about.present ();
    }

    construct {
        actions = new SimpleActionGroup ();
        actions.add_action_entries (ACTION_ENTRIES, this);
        insert_action_group ("win", actions);

        to_describe.clicked.connect(() => {
            stack.visible_child_name = "describe";
        });
    }
}
