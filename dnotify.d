module dnotify;

private {
    import std.string : toStringz;
    import std.conv : to;
    
    import deimos.notify.notify;
}

pragma(lib, "notify");
pragma(lib, "gmodule");

class NotificationError : Exception {
    string message;
    GError* gerror;
    
    this(GError* gerror) {
        this.message = to!(string)(gerror.message);
        this.gerror = gerror;
        
        super(this.message);
    }
}


class Notification {
    NotifyNotification* notify_notification;
    
    const(char)[] summary;
    const(char)[] body_;
    const(char)[] icon;

    bool closed = true;
    
    private int _timeout = NOTIFY_EXPIRES_DEFAULT;
    const(char)[] _category;
    NotifyUrgency _urgency;
    const(char)[] _app_name;

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
            throw new NotificationError(ge);
        }
    }

    @property int timeout() { return _timeout; }
    @property void timeout(int timeout) {
        this._timeout = timeout;
        notify_notification_set_timeout(notify_notification, timeout);
    }

    @property const(char[]) category() { return _category; }
    @property void category(in char[] category) {
        this._category = category;
        notify_notification_set_category(notify_notification, category.toStringz());
    }

    @property NotifyUrgency urgency() { return _urgency; }
    @property void urgency(NotifyUrgency urgency) {
        this._urgency = urgency;
        notify_notification_set_urgency(notify_notification, urgency);
    }

    // set_image
    // set_icon
    // set_hint

    @property const(char)[] app_name() { return _app_name; }
    @property void app_name(in char[] name) {
        this._app_name = app_name;
        notify_notification_set_app_name(notify_notification, app_name.toStringz());
    }

    // add_action

    void close() {
        GError* ge;
        
        if(!notify_notification_close(notify_notification, &ge)) {
            throw new NotificationError(ge);
        }
    }

    @property int closed_reason() {
        return notify_notification_get_closed_reason(notify_notification);
    }
}


version(TestMain) {
    import std.stdio;
    
    void main() {
        notify_init("bla".toStringz());

        writeln(notify_notification_get_type());
        
        auto n = new Notification("foo", "bar");
        n.show();

        notify_uninit();
    }
}