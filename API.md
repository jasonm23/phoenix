JavaScript API
==============

This documentation is an overview of the JavaScript API provided by Phoenix. Use this as a guide for writing your window management script. Your script should reside in `~/.phoenix.js`. Phoenix includes [Underscore.js](http://underscorejs.org) (1.8.3) — you can use its features in your configuration. Underscore provides useful helpers for handling JavaScript functions and objects.

## Getting Started

This documentation uses *pseudocode* to outline the API. Many of the classes represent global objects in the script’s context — functions that are marked as static can be accessed through these global objects. All other functions are instance functions. Instance objects can be accessed through the global objects.

For example, to bind a key to a function, you call the `bind`-function for the `Phoenix`-object.

```javascript
Phoenix.bind('q', [ 'ctrl', 'shift' ], function () {});
```

To move the focused window to a new coordinate, you can call the `setTopLeft`-function for a `Window`-instance. To get a `Window`-instance, you can for example get the focused window with the `focusedWindow`-function for the global `Window`-object.

```javascript
Window.focusedWindow().setTopLeft({ x: 0, y: 0 });
```

To combine, bind a key to move the focused window.

```javascript
Phoenix.bind('q', [ 'ctrl', 'shift' ], function () {

    Window.focusedWindow().setTopLeft({ x: 0, y: 0 }); 
});
```

## Loading

Your configuration file is loaded when the app launches. All functions are evaluated (and executed if necessary) when this happens. Phoenix also reloads the configuration when any changes are detected to the file. You may also reload the configuration manually from the status bar or programmatically from your script.

## Valid Keys

All valid keys for binding are as follows:

- Modifiers: `cmd`, `alt`, `ctrl`, `shift` and `pad` (case insensitive)
- Keys: case insensitive character or special key including function keys, arrow keys, etc. as [listed](Phoenix/PHKeyTranslator.m#L17-L58)
- You can bind any key on your keyboard layout, for example an `å`-character if your keyboard has one.

## Require

You can modularise your configuration using the `require`-function. It will load the referenced JavaScript-file and reload it if any changes are detected. If the path is relative, it is resolved relatively to the absolute location of the `.phoenix.js`-file. If this file is a symlink, it will be resolved before resolving the location of the required file.

```javascript
require('path/to/file.js');
```

## Phoenix

Use the `Phoenix`-object for API-level tasks.

```java
class Phoenix
    static void reload()
    static KeyHandler bind(String key, Array<String> modifiers, Function callback)
    static void log(String message)
    static void notify(String message)
end
```

- `reload()` manually reloads the context and any changes in the configuration files
- `bind(String key, Array<String> modifiers, Function callback)` binds the key character with the specified modifiers to a callback function and returns the handler, the callback function receives no arguments, binding overrides any previous handlers for the same key combination
- `log(String message)` logs the message to the Console
- `notify(String message)` delivers the message to the Notification Center

## KeyHandler

Use the `KeyHandler`-object to enable or disable keys. To override a previous handler, bind the key again.

```java
class KeyHandler
    property String key
    property Array<String> modifiers
    property boolean enabled
end
```

- `key` read-only property for the key character
- `modifiers` read-only property for the key modifiers
- `enabled` property for whether the handler is enabled, by default `true`

## Modal

Use the `Modal`-object to display messages as modal windows.

```java
class Modal
    property Point origin
    property double duration
    property String message
    constructor Modal Modal()
    Rectangle frame()
    void show()
    void close()
end
```

- `origin` property for the origin for the modal, the enclosed properties are read-only so you must pass an object for this property, by default `(0, 0)`
- `duration` property for the duration (in seconds) for the modal, if the duration is set to `0` the modal will remain open until closed, by default `0`
- `message` property for the message for the modal, required for the modal to be displayed
- `new Modal()` initialises and returns a new modal
- `frame()` returns the frame for the modal
- `show()` shows the modal
- `close()` closes the modal

## Command

Use the `Command`-object to run UNIX-commands.

```java
class Command
    static boolean run(String path, Array arguments)
end
```

- `run(String path, Array arguments)` executes a UNIX-command in a absolute path with the passed arguments and waits until completion, returns `true` if the execution was successful

## Screen

Use the `Screen`-object to access frame sizes and other screens on a multi-screen setup. Get the current screen for a window through the `Window`-object.

```java
class Screen
    Rectangle frameInRectangle()
    Rectangle visibleFrameInRectangle()
    Screen next()
    Screen previous()
end
```

- `frameInRectangle()` returns the whole frame for the screen
- `visibleFrameInRectangle()` returns the visible frame for the screen subtracting the Dock and Menu from the frame when visible
- `next()` returns the next screen or the first screen when on the last one
- `previous()` returns the previous screen or the last screen when on the first one

## Mouse

Use the `Mouse`-object to control the cursor.

```java
class Mouse
    static Point location()
    static boolean moveTo(Point point)
end
```

- `location()` returns the cursor position
- `moveTo(Point point)` moves the cursor to a given position, returns `true` if successful

## App

Use the `App`-object to control apps.

```java
class App
    static Array<App> runningApps()
    static App launch(String appName)
    int processIdentifier()
    String bundleIdentifier()
    String name()
    boolean isHidden()
    Array<Window> windows()
    Array<Window> visibleWindows()
    boolean activate()
    boolean focus()
    boolean show()
    boolean hide()
    boolean terminate()
    boolean forceTerminate()
end
```

- `runningApps()` returns all running apps
- `launch(String appName)` (launches to the background and) returns the app with the given name, returns `undefined` if unsuccessful
- `processIdentifier()` returns the process identifier (PID) for the app, returns `-1` if the app does not have a PID
- `bundleIdentifier()` returns the bundle identifier for the app
- `name()` returns the name for the app
- `isHidden()` returns `true` if the app is hidden
- `windows()` returns all windows for the app
- `visibleWindows()` returns all visible windows for the app
- `activate()` activates the app and brings its windows forward, returns `true` if successful
- `focus()` activates the app and brings its windows to focus, returns `true` if successful
- `show()` shows the app, returns `true` if successful
- `hide()` hides the app, returns `true` if successful
- `terminate()` terminates the app, returns `true` if successful
- `forceTerminate()` force terminates the app, returns `true` if successful

## Window

Use the `Window`-object to control windows. Every screen (i.e. display) combines to form a large rectangle. Every window lives within this rectangle and their position can be altered by giving coordinates inside this rectangle. To position a window to a specific display, you need to calculate its position within the large rectangle. To figure out the coordinates for a given screen, use the functions in `Screen`.

```java
class Window
    static Window focusedWindow()
    static Array<Window> windows()
    static Array<Window> visibleWindows()
    static Array<Window> visibleWindowsInOrder()
    Array<Window> otherWindowsOnSameScreen()
    Array<Window> otherWindowsOnAllScreens()
    String title()
    boolean isNormal()
    boolean isMinimized()
    App app()
    Screen screen()
    Point topLeft()
    Size size()
    Rectangle frame()
    boolean setTopLeft(Point point)
    boolean setSize(Size size)
    boolean setFrame(Rectangle frame)
    boolean maximize()
    boolean minimize()
    boolean unminimize()
    Array<Window> windowsToWest()
    Array<Window> windowsToEast()
    Array<Window> windowsToNorth()
    Array<Window> windowsToSouth()
    boolean focus()
    boolean focusClosestWindowInWest()
    boolean focusClosestWindowInEast()
    boolean focusClosestWindowInNorth()
    boolean focusClosestWindowInSouth()
end
```

- `focusedWindow()` returns the focused window for the currently active app, can be `undefined` if no window is focused currently
- `windows()` returns all windows in screens
- `visibleWindows()` returns all visible windows in screens, a visible window is a normal and unminimised window that belongs to an unhidden app
- `visibleWindowsInOrder()` returns all visible windows in the order as they appear on the screen (from front to back), essentially returning them in the most-recently-used order
- `otherWindowsOnSameScreen()` returns all other windows on the same screen as the window
- `otherWindowsOnAllScreens()` returns all other windows on all screens
- `title()` returns the title for the window
- `isNormal()` returns `true` if the window is a normal window
- `isMinimized()` returns `true` if the window is minimised
- `app()` returns the app for the window
- `screen()` returns the screen where most or all of the window is currently present
- `topLeft()` returns the top left point for the window
- `size()` returns the size for the window
- `frame()` returns the frame for the window
- `setTopLeft(Point point)` sets the top left point for the window, returns `true` if successful
- `setSize(Size size)` sets the size for the window, returns `true` if successful
- `setFrame(Rectangle frame)` sets the frame for the window, returns `true` if successful
- `maximize()` resizes the window to fit the whole visible frame for the screen, returns `true` if successful
- `minimize()` minimises the window, returns `true` if successful
- `unminimize()` unminimises the window, returns `true` if successful
- `windowsToWest()` returns windows to the west of the window
- `windowsToEast()` returns windows to the east of the window
- `windowsToNorth()` returns windows to the north the window
- `windowsToSouth()` returns windows to the south the window
- `focus()` focuses the window, returns `true` if successful
- `focusClosestWindowInWest()` focuses the closest window to the west of the window, returns `true` if successful
- `focusClosestWindowInEast()` focuses the closest window to the east of the window, returns `true` if successful
- `focusClosestWindowInNorth()` focuses the closest window to the north of the window, returns `true` if successful
- `focusClosestWindowInSouth()` focuses the closest window to the south of the window, returns `true` if successful

## Point

A simple point object for 2D-coordinates.

```java
class Point
    property double x
    property double y
end
```

## Size

A simple 2D-size object.

```java
class Size
    property double width
    property double height
end
```

## Rectangle

A 2D-rectangle representation of a `Point` and `Size`.

```java
class Rectangle
    property double x
    property double y
    property double width
    property double height
end
```