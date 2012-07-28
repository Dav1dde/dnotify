dnotify
=======

**dnotify** is an abstraction of [libnotify](http://developer.gnome.org/libnotify/) for the D programming language.

## Tutorial ##

### Compilation ###
Just compile your sources with `dnotify.d` and `deimos.notify.notify.d` and you can use it.
External libraries are automatically linked in with `pragma(lib, …)`,
you can disable this with the `-version=NoPragma` switch.
Furthermore there is a `-version=NoGdk` switch, which will disable the support
for loading images from the filesystem with `Notification.set_image`,
but it also removes the `libgdk_pixbuf` dependency.

### Usage ###
Before using anything of **dnotify** you have to call `init(string name)`, which
initializes libnotify. At the end of the application you should call `uninit()`.

To create a notification bubble you have to instantiate the `Notification` class.
The `Notification` class is an abstraction of [NotifyNotification](http://developer.gnome.org/libnotify/0.7/NotifyNotification.html).

```D
auto n = new Notification("headline/summary", "body", "icon");
```

A list of available icons can be found [here](https://wiki.ubuntu.com/NotificationDevelopmentGuidelines#How_do_I_get_these_slick_icons)
or in `/usr/share/icons/gnome/scalable/status`. Instead of passing one of the predefined
icons you can also pass a full path to a .sqv/.png/.jpg. If the path or name does not exist
an empty notification bubble is displayed.

To display the notification you have to call the `.show()` method.

```D
auto n = new Notification("headline/summary", "body", "icon");
n.show()
```

Beside the NotifyNotification abstraction **dnotify** also provides an abstraction for the
[Notification API](http://developer.gnome.org/libnotify/0.7/libnotify-notify.html). It also
takes care of freeing the allocated object from `libnotify`.

[More on how to use libnotify](https://wiki.ubuntu.com/NotificationDevelopmentGuidelines).