public class Mondai.Application : He.Application {
    private const GLib.ActionEntry app_entries[] = {
        { "quit", quit },
    };

    public Application () {
        Object (application_id: Config.APP_ID);
    }

    public static int main (string[] args) {
        Intl.bindtextdomain (Config.GETTEXT_PACKAGE, Config.LOCALEDIR);
        Intl.textdomain (Config.GETTEXT_PACKAGE);
        Intl.bind_textdomain_codeset (Config.GETTEXT_PACKAGE, "UTF-8");

        var app = new Mondai.Application ();
        return app.run (args);
    }

    public override void activate () {
        this.active_window ? .present ();
    }

    public override void startup () {
        Gdk.RGBA accent_color = { 0 };
        accent_color.parse ("#828292");
        default_accent_color = He.Color.from_gdk_rgba (accent_color);

        resource_base_path = "/com/fyralabs/Mondai";

        base.startup ();

        add_action_entries (app_entries, this);

        new MainWindow (this);
    }
}