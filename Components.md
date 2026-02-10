# Components
This document describes the overall Garmin architecture.

## The Component Hierarchy
### Application (AppBase)
The entry point of your program. Every CIQ project has exactly one Application class.

Use: It manages the app's lifecycle (startup, shutdown) and storage.

Best Practice: Keep this class "thin." Its main job is to return the initial View. Use onStart() and onStop() only for necessary data saving/loading to save battery.

### WatchUI
This is the overarching module that handles the user interface. It acts as the manager for Views, Inputs, and Menus.

- **View** (WatchFace, View, SimpleDataField)
A View is a single "screen."

    - **WatchFace** A specialized view that is always on. It has strict memory limits and restricted access to certain features (like GPS or sensors) to save battery.

    - **View** Used in "Watch Apps." It supports complex animations and full interaction.

    - **DataField** A tiny view that lives inside a Garmin activity (like a small box inside the "Run" app). It only displays one or two specific metrics.

- **Delegate** (InputDelegate)
In Garmin's architecture, Views handle drawing, while Delegates handle user input (button presses, screen swipes).

Best Practice: Separate your logic. If a user presses a button, the Delegate should catch the event and tell the View to update.

## Architecture Comparison Table

| Component     | Lifespan             | Interaction          | Main Constraint                      |
|---------------|----------------------|----------------------|--------------------------------------|
| Watch App     | Active Session       | Full (touch/buttons) | Highest memory/feature access.       |
| Widget/Glance | Quick look-up        | Minimal              | Must load and exit very fast.        |
| Watchface     | Constant (always on) | None (passive)       | Strict power/memory limits.          |
| Data Field    | During an Activity   | None                 | High-speed updates; very low memory. |

## The Drawing Cycle (The onUpdate loop)
Garmin uses a "Retained UI" model but requires manual redrawing.

- **onLayout()** Called once at start. Use this to load your IconFont or Bitmaps.
- **onShow()** Called when the view becomes visible.
- **onUpdate(dc)** The heart of your app. This is called every minute (WatchFace) or every second (Apps). This is where you use the dc (Device Context) to draw text, lines, and shapes.


## Garmin Best Practices

### Memory Management (The 100KB Wall)

Most older devices (and even some newer ones) have very limited RAM (often 64KB to 120KB for Watchfaces).

- Practice: Do not create objects inside onUpdate. If you create a new Array() inside a loop that runs every second, you will trigger the Garbage Collector frequently, which drains the battery. Initialize objects in initialize() or onLayout().

### Power Budget

- Watchfaces: You have two modes: High Power (when the user raises their wrist, 1-second updates) and Low Power (most of the time, 1-minute updates).

- Practice: Minimize the area of the screen you update during Low Power mode.

### Resource Handling

- Practice: Use the Rez system for strings and fonts. Hardcoding strings in code consumes "Code Space" RAM, while using Rez.Strings.myString allows the system to load them from disk only when needed.

### Device Independence

- Practice: Never use hardcoded coordinates like dc.drawText(120, 120, ...). Use percentages of dc.getWidth() and dc.getHeight(). The screen on your Forerunner 165 is different from an Enduro 3.