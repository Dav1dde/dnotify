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
**dnotify** takes care of calling the `libnotify` initializer and finalizer. The application name
is by default `"dnotify.d"`, to change this, call `set_app_name(in char[] name)`.

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

Possible errors in `.show`, `.close` and `.set_image` are translated into D exceptions and will
throw a `NotificationError` exception.

Beside the NotifyNotification abstraction **dnotify** also provides an abstraction for the
[Notification API](http://developer.gnome.org/libnotify/0.7/libnotify-notify.html). It also
takes care of freeing the allocated objects from `libnotify`.

[More on how to use libnotify](https://wiki.ubuntu.com/NotificationDevelopmentGuidelines).

## Warning ##
`Notification.set_image` currently results in a segmentation fault.