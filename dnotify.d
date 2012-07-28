module dnotify;

private {
    import std.string : toStringz;
    
    import deimos.notify.notify;
}

pragma(lib, "notify");
pragma(lib, "gmodule");

class NotificationError : Exception {
    string message;
    GError* gerror;
    
    this(string message, GError* gerror) {
        this.message = message;
        this.gerror = gerror;
        
        super(message);
    }
}


class Notification {
    NotifyNotification* notify_notification;

    const(char)[] summary;
    const(char)[] body_;
    const(char)[] icon;

    this(in char[] summary, in char[] body_, in char[] icon="") {
        this.summary = summary;
        this.body_ = body_;
        this.icon = icon;
        notify_notification = notify_notification_new(summary.toStringz(), body_.toStringz(), icon.toStringz());
    }

    bool update(in char[] summary, in char[] body_, in char[] icon="") {
        this.summary = summary;
        this.body_ = body_;
        this.icon = icon;
        return notify_notification_update(notify_notification, summary.toStringz(), body_.toStringz(), icon.toStringz());
    }

    void show() {
        GError* ge;

        if(!notify_notification_show(notify_notification, &ge)) {
            throw new NotificationError("showing notification was unsuccessful", ge);
        }
    }

}


version(TestMain) {
    void main() {
        notify_init("bla".toStringz());
        
        auto n = new Notification("foo", "bar");
        n.show();

        notify_uninit();
    }
}