// Screens for wezterm window tiling, one line per screen:
//   <frame x> <frame y> <scale> <visible x> <visible y> <visible w> <visible h>
// frame origin is Cocoa's bottom-left, matching wezterm.gui.screens() once scaled.
// visible area excludes menu bar and dock, flipped to top-left origin, in points.
// run with: osascript -l JavaScript screens.js

ObjC.import("AppKit");
var a = $.NSScreen.screens,
  h0 = a.objectAtIndex(0).frame.size.height,
  o = [];
for (var i = 0; i < a.count; i++) {
  var s = a.objectAtIndex(i),
    f = s.frame,
    v = s.visibleFrame;
  o.push(
    [
      f.origin.x,
      f.origin.y,
      s.backingScaleFactor,
      v.origin.x,
      h0 - v.origin.y - v.size.height,
      v.size.width,
      v.size.height,
    ].join(" "),
  );
}
o.join("\n");
