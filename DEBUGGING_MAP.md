# Map Debugging Instructions

## Issue - RESOLVED
The map was showing a high-level view of Morocco instead of zooming into the trip route.

**Root Cause:** `getTracksWithOffset()` returns lightweight `RPTrack` objects without GPS points or detailed coordinates.

**Solution:** Implemented `getTrackWithTrackToken()` to fetch `RPTrackProcessed` with full trip details including points array and coordinates. Map now properly zooms to show the actual route.

## Debug Logging Added
I've added extensive logging to help diagnose the issue. The logs will show:

1. **Trip Points Extraction** (TripsViewController)
   - Whether points array exists
   - How many points are in the track
   - Sample coordinates (first 3 and last point)
   - Total coordinates extracted

2. **Map Configuration** (TripDetailsViewController)
   - Trip ID
   - Whether polyline data exists
   - Number of points in polyline
   - Start/end location coordinates
   - Which configuration method is being used
   - Bounding rect dimensions
   - Final map region and span

## Testing Steps

### 1. Run the App
```bash
# In Xcode, run the app on your device/simulator
# OR use command line:
xcodebuild -workspace DemoSwiftApp.xcworkspace \
  -scheme DemoApp-Swift \
  -configuration Debug \
  -destination 'platform=iOS,name=YOUR_DEVICE_NAME' \
  build
```

### 2. Open a Trip
1. Launch the app
2. Tap on any trip in the list
3. Watch the Xcode console output

### 3. Check Console Output

Look for these debug sections:

#### A. Points Extraction
```
=== EXTRACTING TRIP POINTS ===
Track token: abc123...
Total points in track: 150
Point 0: lat=33.5731, lon=-7.5898
Point 1: lat=33.5732, lon=-7.5899
Point 2: lat=33.5733, lon=-7.5900
...
Point 149: lat=33.5850, lon=-7.6010
Successfully extracted 150 coordinates
==============================
```

**What to check:**
- ✅ Are points being extracted?
- ✅ Do coordinates look valid? (Morocco: lat ~30-35, lon ~-10 to -1)
- ❌ If "No points array found" → Points not in track data
- ❌ If "No valid coordinates extracted" → Points exist but have no lat/lon

#### B. Map Configuration
```
=== MAP CONFIGURATION DEBUG ===
Trip ID: abc123...
Has polyline: true
Polyline count: 150
Start location: 33.5731, -7.5898
End location: 33.5850, -7.6010
Using polyline with 150 points
First point: 33.5731, -7.5898
Last point: 33.5850, -7.6010
===============================
```

**What to check:**
- ✅ Does it say "Using polyline"?
- ✅ Are coordinates valid?
- ❌ If "Using start/end fallback" → No polyline data
- ❌ If "No location data available!" → No coordinates at all

#### C. Polyline Configuration
```
Configuring map with polyline...
Added start marker at: 33.5731, -7.5898
Added end marker at: 33.5850, -7.6010
Added polyline overlay
Bounding rect - origin: X, Y, size: W x H
Set visible map rect with padding
Final map region - center: 33.5790, -7.5954
Final map span - lat: 0.015, lon: 0.015
```

**What to check:**
- ✅ Bounding rect should have non-zero size
- ✅ Final span should be small (0.01-0.1 for city-level zoom)
- ❌ If span is large (>1.0) → Map not zooming in
- ❌ If rect is zero/invalid → Polyline issue

## Likely Issues & Solutions

### Issue 1: Points Array Not Extracted
**Symptom:** "No points array found in track data"

**Cause:** SDK might return tracks without points by default

**Solution:** Need to fetch detailed track data
```swift
// In TripsViewController, try fetching track details:
RPEntry.instance.api.getTrackDetailedByToken(trackToken) { detailedTrack, error in
    // This might have the points
}
```

### Issue 2: Points Exist But Map Doesn't Zoom
**Symptom:** Points extracted, but map shows country-level view

**Possible causes:**
1. Map configuration running before view layout complete
2. Constraints interfering with map sizing
3. Map region being reset somewhere else

**Try:** Move map configuration to `viewDidLayoutSubviews`
```swift
override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    if !mapConfigured {
        configureMap()
        mapConfigured = true
    }
}
```

### Issue 3: Coordinates Are Invalid
**Symptom:** Coordinates all zeros or outside Morocco

**Solution:** Check coordinate property names in RPTrackPointProcessed

## Next Steps After Testing

1. **Run the app**
2. **Tap a trip**
3. **Copy the ENTIRE console output** from the debug sections
4. **Share the output** so I can see exactly what's happening

The debug logs will tell us:
- ✅ Are we getting points?
- ✅ Are coordinates valid?
- ✅ Is the map being configured correctly?
- ✅ What's the final map region?

Then we can fix the exact issue!

## Quick Test Commands

### View Console in Real-Time
```bash
# If running via Xcode, just check the console
# If running via command line:
xcrun simctl spawn booted log stream --predicate 'processImagePath contains "DemoSwiftApp"' --level debug
```

### Check for Trip Data
Look in Xcode console for any lines containing:
- "EXTRACTING TRIP POINTS"
- "MAP CONFIGURATION"
- "polyline"
- "coordinates"
