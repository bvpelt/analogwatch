# Analogwatch

Watch implementation

# Publishing

- change debug level to Warning in the resources/properties/properties.xml and save this file
  > > <property id="MinimalDebugLevel" type="number">3</property>
- build an export
  > > `make clean-storage export &> release.log`
- publish the new app using https://apps.garmin.com/en-US/developer/upload and/or https://apps.garmin.com/apps/820dfa7e-7b9e-4e35-8e14-feb072e74d57
- publish a revised app using https://apps.garmin.com/en-US/developer/dashboard

# Navigation

| Input type       | Action           |
| ---------------- | ---------------- |
| Swipe left/right | Switch views     |
| Back button      | Switch backwards |
| Select short     | Add message      |
| Select long      | Switch forward   |

**key mapping**
| Simulator / Watch Button | Delegate Method |
|--------------------------|-----------------|
| Click / Tap / Space | onSelect() |
| Start / Enter | onSelect() |
| Long Start | onSelectHold() |
| ESC / Back | onBack() |
| Long ESC | onBackHold() |
| Swipe | onSwipe() |

# Events

```text
User Input (Key/Swipe/Touch)
         ↓
   [Operating System]
         ↓
   [Connect IQ Runtime]
         ↓
   [Your App - MessengerApp]
         ↓
   [Active View Stack]
         ↓
   [Current InputDelegate]
         ↓
   [Event Handler Methods]
```

## View stack

```text
View Stack (top to bottom):
┌─────────────────────────┐
│  ClockView              │ ← Inactive (no events)
│  ClockViewDelegate      │
├─────────────────────────┤
│  AnalogView             │ ← Inactive (no events)
│  AnalogViewDelegate     │
└─────────────────────────┘
```

## Events

Input Event Types

**Physical Inputs**

- Keys: UP, DOWN, ENTER, ESC, START, LAP, etc.
- Touch: Swipe (UP, DOWN, LEFT, RIGHT), Tap, Long Press
- Rotation: Digital crown (on some devices)

**Event Types**

- PRESS_TYPE_DOWN - Button pressed down
- PRESS_TYPE_UP - Button released
- PRESS_TYPE_ACTION - Complete press (down + up)

## Event Routing

Event Routing Order

When an event occurs, the framework calls handler methods in priority order on the active delegate:

```text
User presses UP button
         ↓
Framework checks delegate methods in order:
         ↓
1. onKeyPressed()      ← If returns true, STOP
   ↓ (returns false)
2. onKey()             ← If returns true, STOP
   ↓ (returns false)
3. onPreviousPage()    ← If returns true, STOP
   ↓ (returns false)
4. Default behavior    ← Framework's fallback
```

## Event handler priority

**Button events**

```text
// Priority 1: Specific key press/release
function onKeyPressed(keyEvent) → true/false

function onKeyReleased(keyEvent) → true/false

// Priority 2: General key handler
function onKey(keyEvent) → true/false

// Priority 3: Specialized handlers (mapped to specific keys)
function onNextPage()         // UP button
function onPreviousPage()     // DOWN button
function onSelect()           // ENTER/START button
function onBack()             // BACK/ESC button
function onMenu()             // MENU button (some devices)
```

**Touch events**

```
// Priority 1: Touch events
function onTap(clickEvent) → true/false

function onSwipe(swipeEvent) → true/false

function onDrag(dragEvent) → true/false

function onFlick(flickEvent) → true/false

function onHold(clickEvent) → true/false

function onRelease(clickEvent) → true/false
```

**Event Flow Example**

**Scenario: User swipes left on ClockView**

```
User swipes left
    ↓
┌─────────────────────────────────────┐
│ Connect IQ Framework                │
│ Detects swipe gesture               │
│ Direction: SWIPE_LEFT               │
└──────────────┬──────────────────────┘
               ↓
┌─────────────────────────────────────┐
│ Current View Stack                  │
│ Top: ClockView                   │
│      ClockViewDelegate           │ ← Active
└──────────────┬──────────────────────┘
               ↓
┌─────────────────────────────────────┐
│ ClockViewDelegate                │
│ onSwipe(swipeEvent) called          │
│   direction = SWIPE_LEFT            │
└──────────────┬──────────────────────┘
               ↓
┌─────────────────────────────────────┐
│ Your Code in onSwipe()              │
│ if (direction == SWIPE_LEFT) {      │
│   WatchUi.switchToView(             │
│     new AnalogView(),               │
│     new AnalogViewDelegate()        │
│   );                                │
│   return true; ← Event handled!     │
│ }                                   │
└──────────────┬──────────────────────┘
               ↓
┌─────────────────────────────────────┐
│ WatchUi.switchToView()              │
│ 1. Remove ClockView from stack   │
│ 2. Add AnalogView to stack          │
│ 3. AnalogView becomes active        │
└──────────────┬──────────────────────┘
               ↓
New View Stack:
┌─────────────────────────────────────┐
│ AnalogView           ← Now active   │
│ AnalogViewDelegate                  │
└─────────────────────────────────────┘
```

# Return Values Matter

Returning true:

"I handled this event"
Framework stops processing
Other handlers not called

Returning false:

"I didn't handle this event"
Framework continues to next handler
May trigger default behavior

# Current implementation

```text
MessengerApp
    ├── ClockView + ClockViewDelegate
    │   ├── onSwipe()         → Navigate views
    │   ├── onSelect()        → Go to MessagesView
    │   └── onBack()          → Go to AnalogView
    │
    └── AnalogView + AnalogViewDelegate
        ├── onSwipe()         → Navigate views
        ├── onSelect()        → Go to ClockView
        └── onBack()          → Go to MessagesView
```

# Examples

- https://github.com/CodyJung/connectiq-apps

# Fonts

To use specific symbols one can use symbols from free fonts. The steps to take are:
- generate font based on .svg files https://icomoon.io/ (online tool)
- convert font for garmin https://angelcode.com/products/bmfont/ (only works on windows or for linux users in wine)

This is the part most developers find tricky. You don't "write" these files; you generate them:
Find an SVG: Download a Bluetooth SVG (e.g., from FontAwesome or Google Material Icons).
Use a Web Tool: Go to IcoMoon.io.
Upload your SVG.

Click Generate Font.
Under "Preferences," ensure the "Class Prefix" is simple.
Convert for Garmin: Use the BMFont (AngelCode) tool to export the font as a .fnt file and a single-bit (White on Transparent) .png.
Crucial: Connect IQ fonts must be white on a transparent/black background in the PNG; the dc.setColor command replaces the white pixels with your chosen color.
The Resource File (resources/fonts/fonts.xml)
First, you must define the font in your resources. You will need a .fnt (mapping file) and a .png (the actual glyphs) created by a tool like BMFont or FontAssetCreator.

The generated font file is [here](./resources/fonts/icons.fnt) with the [bitmaps](./resources/fonts/icons_0.png). The character id is used to identify the symbol in this font. The x and y are the position of the symbol in the bitmap.

```xml
<resources>
    <font id="IconFont" filename="fonts/icons.fnt" antialias="true" />
</resources>
```
## Font converting
1. Initial Setup
      - Download BMFont: Get it from the AngelCode website.
      - Install your Icon Font: If you downloaded a font (like FontAwesome) or created one via IcoMoon, install the .ttf or .otf file onto your Windows system so BMFont can see it.

2. Font Settings
      - Open BMFont and go to Options > Font Settings.
      - Font: Select your installed icon font (e.g., "IcoMoon" or "FontAwesome").
      - Charset: Set to Unicode.
      - Size (px): Set this to the height you want the icon to be on your Forerunner 165 (e.g., 24 or 32).
      - Height %: 100%.
      - Font Smoothing: Check this if you want anti-aliasing.

3. Export Settings (The "Garmin" Critical Step)
This is where most developers fail. Go to Options > Export Settings.

      - Padding: Set all to 0.
      - Spacing: 1 for both horiz and vert.
      - Bit Depth: 8.
      - Presets: Select White text with alpha.
      - Font Descriptor: Select Text. (Garmin cannot read the binary format).
      - Textures: Select png.
      - Width/Height: Start with 256 x 256. You want your entire icon set to fit on one single image file.

# Symbolen

De volgende symbolen opgenomen
- active U+F013 ![active](./extern/active.svg)
- active html <img src="./extern/active.svg" alt="active" width="32"/>
- path distance U+F012 ![path distance](./extern/path-distance.svg)
- line distance U+F011 ![line distance](./extern/line-distance.svg)
- hart beat U+F010 ![hart beat](./extern/heart-beat.svg)
- hart U+F00F ![hart](./extern/hart.svg)
- stairs U+F00E ![stairs](./extern/stairs-32x32.svg)
- battery U+F00D ![battery empty](./extern/battery0-4-32x32.svg)
- battery U+F00C ![battery 1/4](./extern/battery-1-4-32x32.svg)
- battery U+F00B ![battery 2/4](./extern/battery-2-4-32x32.svg)
- battery U+F00A ![battery 3/4](./extern/battery-3-4-32x32.svg)
- battery U+F009 ![battery 4/4](./extern/battery-4-4-32x32.svg)
- calories U+F008 ![calories](./extern/burn-32x32.svg)

- email U+F007 ![calories](./extern/email-32x32.svg)
- steps U+F006 ![calories](./extern/foot-32x32.svg)
- search U+F005 ![calories](./extern/search-32x32.svg)
- wait U+F004 ![wait 1](./extern/wait-1-32x32.svg)
- wait U+F003 ![wait](./extern/wait-32x32.svg)
- documents U+F002 ![documents](./extern/documents-32x32.svg)
- file U+F001 ![file](./extern/file-32x32.svg)
- bluetooth U+F000 ![bluetooth](./extern/bluetooth-32x32.svg)

# Colors


## Neutrals
- `#000000` **black**
- `#253237` **jet black**

## Red / Warm Group
- `#2d080a` **rich mahogany**
- `#960200` **oxblood**
- `#b20a1b` **mahogany red**
- `#7c3626` **chestnut**
- `#ca3c25` **burnt tangerine**
- `#ff0022` **racing red**
- `#ff0000` **red**
- `#ff3333` **cinnabar**
- `#f6511d` **crimson carrot**
- `#ce6c47` **burnt peach**
- `#f5853f` **pumpkin spice**
- `#ffb400` **amber flame**
- `#ffd046` **golden pollen**
- `#ffbfb7` **powder blush**

## Green Group
- `#162615` **forest night**
- `#1a3a22` **deep spruce**
- `#206f28` **turf green**
- `#355e3b` **hunter green**
- `#26a924` **green**
- `#32965d` **jade empire**
- `#43b581` **amazonite**
- `#7fb800` **lime moss**
- `#90ee90` **apple tart**
- `#93c572` **pistachio**
- `#b2ec5d` **spring leaf**
- `#b4f8c8` **menthe**
- `#d0f0c0` **pale neon**
- `#e2f3e4` **dewdrop**

## Blue Group
- `#061a40` **prussian blue**
- `#0d2c54` **oxford navy**
- `#241e4e` **dark amethyst**
- `#07354b` **deep space blue**
- `#090c9b` **navy electric**
- `#1c5373` **yale blue**
- `#0353a4` **sapphire**
- `#006daa` **cornflower ocean**
- `#3066be` **smart blue**
- `#00a6ed` **fresh sky**
- `#9db4c0` **cool steel**
- `#b4c5e4` **powder blue**
- `#b9d6f2` **pale sky**
- `#e0fbfc` **light cyan**

## Light Neutrals
- `#c0c0c0` **silver**
- `#eeebd0` **beige**
- `#fbfff1` **ivory**
- `#ffffff` **white**

**Option 2**

## Color Palette

### Neutrals
![#000000](https://via.placeholder.com/600x30/000000/ffffff?text=black)
![#253237](https://via.placeholder.com/600x30/253237/ffffff?text=jet+black)

### Red / Warm Group
![#2d080a](https://via.placeholder.com/600x30/2d080a/ffffff?text=rich+mahogany)
![#960200](https://via.placeholder.com/600x30/960200/ffffff?text=oxblood)
![#b20a1b](https://via.placeholder.com/600x30/b20a1b/ffffff?text=mahogany+red)
![#7c3626](https://via.placeholder.com/600x30/7c3626/ffffff?text=chestnut)
![#ca3c25](https://via.placeholder.com/600x30/ca3c25/ffffff?text=burnt+tangerine)
![#ff0022](https://via.placeholder.com/600x30/ff0022/ffffff?text=racing+red)
![#ff0000](https://via.placeholder.com/600x30/ff0000/ffffff?text=red)
![#ff3333](https://via.placeholder.com/600x30/ff3333/ffffff?text=cinnabar)
![#f6511d](https://via.placeholder.com/600x30/f6511d/ffffff?text=crimson+carrot)
![#ce6c47](https://via.placeholder.com/600x30/ce6c47/ffffff?text=burnt+peach)
![#f5853f](https://via.placeholder.com/600x30/f5853f/000000?text=pumpkin+spice)
![#ffb400](https://via.placeholder.com/600x30/ffb400/000000?text=amber+flame)
![#ffd046](https://via.placeholder.com/600x30/ffd046/000000?text=golden+pollen)
![#ffbfb7](https://via.placeholder.com/600x30/ffbfb7/000000?text=powder+blush)

### Green Group
![#162615](https://via.placeholder.com/600x30/162615/ffffff?text=forest+night)
![#1a3a22](https://via.placeholder.com/600x30/1a3a22/ffffff?text=deep+spruce)
![#206f28](https://via.placeholder.com/600x30/206f28/ffffff?text=turf+green)
![#355e3b](https://via.placeholder.com/600x30/355e3b/ffffff?text=hunter+green)
![#26a924](https://via.placeholder.com/600x30/26a924/ffffff?text=green)
![#32965d](https://via.placeholder.com/600x30/32965d/ffffff?text=jade+empire)
![#43b581](https://via.placeholder.com/600x30/43b581/ffffff?text=amazonite)
![#7fb800](https://via.placeholder.com/600x30/7fb800/ffffff?text=lime+moss)
![#90ee90](https://via.placeholder.com/600x30/90ee90/000000?text=apple+tart)
![#93c572](https://via.placeholder.com/600x30/93c572/000000?text=pistachio)
![#b2ec5d](https://via.placeholder.com/600x30/b2ec5d/000000?text=spring+leaf)
![#b4f8c8](https://via.placeholder.com/600x30/b4f8c8/000000?text=menthe)
![#d0f0c0](https://via.placeholder.com/600x30/d0f0c0/000000?text=pale+neon)
![#e2f3e4](https://via.placeholder.com/600x30/e2f3e4/000000?text=dewdrop)

### Blue Group
![#061a40](https://via.placeholder.com/600x30/061a40/ffffff?text=prussian+blue)
![#0d2c54](https://via.placeholder.com/600x30/0d2c54/ffffff?text=oxford+navy)
![#241e4e](https://via.placeholder.com/600x30/241e4e/ffffff?text=dark+amethyst)
![#07354b](https://via.placeholder.com/600x30/07354b/ffffff?text=deep+space+blue)
![#090c9b](https://via.placeholder.com/600x30/090c9b/ffffff?text=navy+electric)
![#1c5373](https://via.placeholder.com/600x30/1c5373/ffffff?text=yale+blue)
![#0353a4](https://via.placeholder.com/600x30/0353a4/ffffff?text=sapphire)
![#006daa](https://via.placeholder.com/600x30/006daa/ffffff?text=cornflower+ocean)
![#3066be](https://via.placeholder.com/600x30/3066be/ffffff?text=smart+blue)
![#00a6ed](https://via.placeholder.com/600x30/00a6ed/ffffff?text=fresh+sky)
![#9db4c0](https://via.placeholder.com/600x30/9db4c0/000000?text=cool+steel)
![#b4c5e4](https://via.placeholder.com/600x30/b4c5e4/000000?text=powder+blue)
![#b9d6f2](https://via.placeholder.com/600x30/b9d6f2/000000?text=pale+sky)
![#e0fbfc](https://via.placeholder.com/600x30/e0fbfc/000000?text=light+cyan)

### Light Neutrals
![#c0c0c0](https://via.placeholder.com/600x30/c0c0c0/000000?text=silver)
![#eeebd0](https://via.placeholder.com/600x30/eeebd0/000000?text=beige)
![#fbfff1](https://via.placeholder.com/600x30/fbfff1/000000?text=ivory)
![#ffffff](https://via.placeholder.com/600x30/ffffff/000000?text=white)

**Option 3**

| Color | Hex | Name |
|-------|-----|------|
| ![#000000](https://via.placeholder.com/50x30/000000/000000?text=+) | `#000000` | black |
| ![#253237](https://via.placeholder.com/50x30/253237/253237?text=+) | `#253237` | jet black |
| ![#2d080a](https://via.placeholder.com/50x30/2d080a/2d080a?text=+) | `#2d080a` | rich mahogany |
| ![#960200](https://via.placeholder.com/50x30/960200/960200?text=+) | `#960200` | oxblood |
| ![#b20a1b](https://via.placeholder.com/50x30/b20a1b/b20a1b?text=+) | `#b20a1b` | mahogany red |

**Option 4**

<svg width="600" height="30">
  <rect width="600" height="30" fill="#000000"/>
  <text x="10" y="20" fill="white" font-family="Arial" font-size="14">black - #000000</text>
</svg>

<svg width="600" height="30">
  <rect width="600" height="30" fill="#253237"/>
  <text x="10" y="20" fill="white" font-family="Arial" font-size="14">jet black - #253237</text>
</svg>