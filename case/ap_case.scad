// OpenEPaperLink "minimal spaghetti" AP case -- revised for a 28 mm-wide ESP32-S3.
//
// Based on hillstub/OpenEPaperLink-Minimal-Spaghetti-AP, 3D_files/openepaperlink_case.scad.
//
// Changes from the original:
//   - The S3 sits behind the USB cutout and the C6 beside it, the reverse of the
//     original, so the S3's native USB-C is the exposed port.
//   - The S3 is a 28 mm board with 25.4 mm row spacing, 22 pins a row, its first
//     pin 1.85 mm from the USB edge, and a WROOM module overhanging 6.3 mm.
//   - Rails are computed from pin numbers, so the gaps fall exactly under the wired
//     pins. The wiring is the upstream Yellow AP mapping (8 wires, 3V3 power) in
//     docs/build-an-ap.md of oepl-starter -- NOT the 5-wire table in
//     hillstub's README, which an earlier revision of this file followed:
//         S3 17 -> C6 2      S3 18 -> C6 3      S3 19 -> C6 TX     S3 20 -> C6 RX
//         S3 21 -> C6 9      S3 47 -> C6 RST    S3 3V3 -> C6 3V3   S3 GND -> C6 G
//     The 5V pins on both boards are left free as well, so power can be wired
//     5V -> 5V instead of 3V3 -> 3V3 (each board then makes its own 3.3 V).
//   - The USB-end support block sits between the S3's pin rows instead of across
//     them, because the S3's end pins land where the old block was.
//
// Orientation: model +Y is the USB end. Seen from above with the USB wall toward
// you, model +X runs to your LEFT -- so board A (low x) is on your right.
//
// How the boards are held: each devkit sits pins-down, its header pins pushed into
// 0.6 mm slots along the top of "rails". The rails deliberately stop short at the
// pins that get a Dupont jumper from below -- those gaps are what the rail segment
// lists below encode.

include <BOSL2/std.scad>

$fn = 50;

// ---------------------------------------------------------------------------
// General
// ---------------------------------------------------------------------------
wall = 2;
pin_spacing = 2.54;

gap_between_boards = 3;
side_padding = 4.54;

y_size = 76.2;                 // inner length of the box
z_size = 32;                   // outer height of the base

// Rails (header holders)
header_holder_width = 3.2;     // leaves a flat top either side of the funnel for
                               // the header plastic to sit on
header_holder_slid  = 0.6;     // slot the header pins drop into: 0.6 for 0.64 mm
                               // pins, a light press fit that holds the boards
slot_mouth          = 2.0;     // 45-degree funnel at the top of the slot (0.7 mm
                               // deep), so a pin that lands near its slot is
                               // guided into it
rail_height = 18;
rail_slot_depth = 7.5;

// ---------------------------------------------------------------------------
// BOARDS
//
// Positions are in mm. For each board:
//   width        PCB width, used for layout and the support block
//   row_spacing  centre-to-centre distance between the two pin rows
//   y0           where the board's rail coordinates start, from the inner wall
//   rails        list of [side, y_start, length, close_end_one, close_end_two]
//                side 0 = left row, 1 = right row; y_start and length in mm
//                (multiples of pin_spacing are the natural unit)
// ---------------------------------------------------------------------------
p = pin_spacing;

// Board A: ESP32-C6-DevKitC-1 v1.2 (your right). Same pin positions as the original
// design's C6, rebuilt on the same rule as the S3 below. The original's GPIO 9 gap
// was exactly one pitch (2.54 mm) for a 2.54 mm Dupont housing -- a press fit at
// best -- and nothing stopped the board drifting along the rails into it.
rail_end      = 0.75;          // a rail runs this far past its end pins
a_width       = 25.4;
a_row_spacing = 22.9;          // as the original case used. Was written as a_width -
                               // header_holder_width, which moved the rows when the
                               // rails were widened -- a fixed number on purpose.
a_y0          = 0;                                  // rails in cavity coordinates
a_pin0        = 2 + 22 + 0.5;  // where the original held pin 0, cavity y
function a_pin(k) = a_pin0 + k * p;                 // k = 0 at the module end

// Counted from the module end (k = 0) toward the USB end (k = 15). Wired pins are
// in [brackets]; a rail stops ~0.5 mm short of each one's Dupont housing.
//   outer: G [TX] [RX] 15 23 22 21 20 19 18 [9] G 13 12 G NC
//   inner: [3V3] [RST] 4 5 6 7 0 1 8 10 11 [2] [3] [5V] [G] NC   (3V3 or 5V)
// No end walls or locating features: every rail is open at both ends, so no pin
// has to land precisely. Nothing pushes on the C6 (its USB is not exposed), and
// once wired, the Dupont housings sitting in the rail gaps keep it within about
// +-0.5 mm along Y.
a_rails = [
    [0, a_pin(3)  - rail_end,  6*p + 2*rail_end, false, false],   // outer k 3..9
    [0, a_pin(11) - rail_end,  4*p + 2*rail_end, false, false],   // outer k 11..15
    [1, a_pin(2)  - rail_end,  8*p + 2*rail_end, false, false],   // inner k 2..10
];

// Board B: 28 mm ESP32-S3 (your left), USB end against the cutout wall.
b_width       = 28;
b_row_spacing = 25.4;
b_pins        = 22;            // per row
b_first_pin   = 1.85;          // USB edge of the PCB to the centre of the nearest pin
b_length      = 57;            // PCB only; the WROOM module overhangs another 6.3 mm
b_wall_gap    = 0.5;           // PCB USB edge to the inside of the end wall; the
                               // USB-C shells overhang the PCB by 0.3 (calipers)
b_y0          = 0;             // rails below are given in cavity coordinates

b_pcb_end = y_size - b_wall_gap;
function b_pin(k) = b_pcb_end - b_first_pin - (b_pins - 1 - k) * p;   // k = 0 at the module end

// Row 0 is the inner row (facing the C6), row 1 the outer row, counted from the
// module end (k = 0) toward the USB end (k = 21). Wired pins in [brackets]:
//   inner: G TX RX 1 2 42 41 40 39 38 37 36 35 0 45 48 [47] [21] [20] [19] [G] G
//   outer: [3V3] 3V3 RST 4 5 6 7 15 16 [17] [18] 8 3 46 9 10 11 12 13 14 [5V] G   (3V3 or 5V)
// The inner rail also leaves k 8..11 open (none of them wired) as a window for the
// 17 and 18 wires to cross straight under the S3 to the C6, rather than detour
// round an end of the rail. The rails are open at both ends; the S3 is held along
// Y by its PCB edges instead -- the USB wall at one end, and a stop block just
// behind the module-end edge at the other, which takes the push of a USB plug.
b_rails = [
    [0, b_pin(0)  - rail_end,  7*p + 2*rail_end, false, false],   // inner k 0..7
    [0, b_pin(12) - rail_end,  3*p + 2*rail_end, false, false],   // inner k 12..15
    [1, b_pin(1)  - rail_end,  7*p + 2*rail_end, false, false],   // outer k 1..8
    [1, b_pin(11) - rail_end,  8*p + 2*rail_end, false, false],   // outer k 11..19; 5V, G free
];

// Stop behind the S3's module-end PCB edge (calipers: 57 mm board, first pin
// 1.85 mm from the USB edge, so the far edge is 1.81 mm past the last pin). It
// touches only the edge of the PCB, and stays below the WROOM module, which
// overhangs this edge by 6.3 mm.
b_stop_gap = 0.4;              // clearance to the PCB edge
b_stop_w   = 10;
b_stop_d   = 3;
b_stop_top = 2 + 18 + 2.5 + 1.1;   // PCB underside + 1.1 mm of edge contact

// Support under the S3's USB end. Two ribs rather than one block: each USB-C shell
// is soldered through the board with four tabs, in rows 2.5 and 6.8 mm from the USB
// edge, and their solder sticks out underneath. Measured from the bottom-view photo,
// the tab columns sit 3.7, 12.5, 15.7 and 24.3 mm from the S3's inner edge. The ribs
// fill the spaces between them, one directly under each port, and stay clear of the
// Dupont housings on both pin rows.
b_support_y_size = 4;
b_support_height = 18 + 2.5;   // up to the underside of the PCB
b_support_ribs = [ [5.4, 10.7],      // under the COM port
                   [17.4, 22.5] ];   // under the native USB port -- takes the plug force

// USB-C cutout, centred on the S3's native "USB" port, measured from the S3's low-x
// edge (the edge nearest the C6). Two photos agree to within 0.4 mm.
usb_center   = 19.85;          // calipers: 19.8-19.9 (photos had said 20.0-20.1)
usb_z        = 21.9;           // above the inside of the floor
usb_w        = 11;             // 8.94 mm connector, with room for measurement error
usb_h        = 4;
usb_indent_margin_z = 2;       // recess for the plug's overmould, outside face
usb_indent_w = 13;
usb_indent_h = 8;


// ---------------------------------------------------------------------------
// Sliding lid: printed closure, no hardware
//
// The lid slides in from the back (-Y) along dovetail grooves in the two side
// walls and stops against the USB wall. A tongue cut into its back edge carries a
// rounded ridge underneath that clicks into a groove across the top of the back
// wall. Pull the lid back by its grip grooves to open: the tongue flexes and the
// ridge climbs out.
// ---------------------------------------------------------------------------
side_extra = 1;            // side walls are wall + side_extra = 3 mm, for the grooves
back_extra = 1;            // back wall likewise 3 mm, to hold the detent groove
                           // (the USB wall stays at 2 mm so the plug reaches)
lid_t      = 2;            // lid thickness
lid_z0     = 28.5;         // underside of the lid, from the bottom of the box. The
                           // tallest parts (USB-C shells) top out at ~27.4.
flange     = 0.95;         // how far the lid's edge reaches into each side wall
lid_c      = 0.15;         // sliding clearance, all round. 0.25 printed too loose.
lid_flush  = true;         // true: the lid's middle is raised to the box rim, so the
                           // closed top is one flat surface. false: a 2 mm plate set
                           // 1.5 mm below the rim (the first printed version).
tongue_w   = 10;           // detent tongue, in the middle of the back edge
// A flush lid's tongue is 3.5 mm thick instead of 2. Stiffness goes as thickness^3
// over length^3, so lengthening it in proportion (20 -> 35 mm) keeps the same click
// force, and the bend for the same 0.65 mm lift is gentler (0.28% strain vs 0.41%).
tongue_len = lid_flush ? 35 : 20;
tongue_gap = 1.2;          // slots either side of it
ridge_r    = 1.2;          // ridge under the tongue's tip
ridge_h    = 0.8;          // how far it stands proud of the lid's underside
ridge_play = 0.15;         // extra radius on the groove that receives it
// Detent position across the back wall. Centred, the groove left ~0.2 mm lips that
// sheared off in print; 1 mm inboard gives the outer lip ~1.2 mm and drops the
// inner lip, which did nothing.
ridge_inset = 1;
ridge_y    = -back_extra + (back_extra + wall)/2 + ridge_inset;

// ---------------------------------------------------------------------------
// Derived layout
// ---------------------------------------------------------------------------
x_size = side_padding + a_width + gap_between_boards + b_width + side_padding;
a_x = side_padding;                                   // board origins, from inner wall
b_x = side_padding + a_width + gap_between_boards;

// ---------------------------------------------------------------------------
// Modules
// ---------------------------------------------------------------------------
// A rail, with its pin slot along the top and a funnel into the slot.
module header_holder(length, height=rail_height, close_end_one=false, close_end_two=false){
    sx = (header_holder_width - header_holder_slid)/2;      // slot's left edge
    fd = (slot_mouth - header_holder_slid)/2;               // funnel depth (45 degrees)
    if(close_end_one){
        translate([0,-2,0]) cube([header_holder_width, 2, height]);
    }
    difference(){
        cube([header_holder_width, length, height]);
        translate([sx, -0.01, height-rail_slot_depth])
            cube([header_holder_slid, length+0.02, rail_slot_depth+0.01]);
        // funnel: a 45-degree V from the slot mouth down into the slot
        translate([0, -0.01, 0]) rotate([-90, 0, 0])
            linear_extrude(height = length + 0.02)
                polygon([[sx - fd, -height - 0.01], [sx + header_holder_slid + fd, -height - 0.01],
                         [sx + header_holder_slid, -height + fd], [sx, -height + fd]]);
    }
    if(close_end_two){
        translate([0, length, 0]) cube([header_holder_width, 2, height]);
    }
}

// Rails for one board. The first row's slot is centred (width - row_spacing)/2 in
// from the board's left edge, the second row_spacing further on.
module board_rails(width, row_spacing, rails){
    left_x = (width - row_spacing)/2 - header_holder_width/2;
    for (r = rails)
        translate([left_x + r[0]*row_spacing, r[1], 0])
            header_holder(length=r[2], close_end_one=r[3], close_end_two=r[4]);
}

module base(){
    difference(){
        translate([-side_extra, -back_extra, 0])
            cuboid([x_size + 2*wall + 2*side_extra, y_size + 2*wall + back_extra, z_size],
                   rounding=4, edges="Z", anchor=BOTTOM+FRONT+LEFT);

        // USB-C port
        translate([wall + b_x + usb_center - usb_w/2, y_size + wall, wall + usb_z])
            cuboid([usb_w, wall + 0.2, usb_h], rounding=1, edges="Y", anchor=BOTTOM+FRONT+LEFT);

        // Recess for the plug
        translate([wall + b_x + usb_center - usb_indent_w/2, y_size + wall + 1,
                   wall + usb_z - usb_indent_margin_z])
            cuboid([usb_indent_w, 1, usb_indent_h], rounding=4, edges="Y", anchor=BOTTOM+FRONT+LEFT);

        // Core hollow
        translate([wall, wall, wall]) cuboid([x_size, y_size, z_size], rounding=3, edges="Z", anchor=BOTTOM+FRONT+LEFT);

        // The lid's path: dovetail grooves in the side walls, open out the back
        lid_slot();

        // Back wall cut down to just under the lid, so the lid can slide in over it
        translate([wall - flange - lid_c - 0.01, -back_extra - 0.1, lid_z0 - lid_c])
            cube([x_size + 2*(flange + lid_c) + 0.02, back_extra + wall + 0.2, z_size]);

        // Square off the top of the opening above the lid grooves. The cavity's
        // corners are rounded (3 mm), and a flush lid's raised middle is a
        // rectangle that slides the whole length: it would hit the back corners on
        // the way in and the front corners when closed. Only removes material, so
        // the base still takes the inset lid too.
        translate([wall, -back_extra - 0.1, lid_z0 + lid_t - lid_c])
            cube([x_size, y_size + wall + back_extra + 0.1, z_size]);

        // Detent groove across the top of the back wall
        translate([wall + x_size/2 - tongue_w/2, ridge_y,
                   lid_z0 + (ridge_r - ridge_h)])
            rotate([0, 90, 0]) cylinder(r=ridge_r + ridge_play, h=tongue_w);
    }

    // Stop behind the S3's module-end edge
    translate([wall + b_x + b_width/2 - b_stop_w/2,
               wall + b_pcb_end - b_length - b_stop_gap - b_stop_d, wall - 0.5])
        cube([b_stop_w, b_stop_d, b_stop_top - (wall - 0.5)]);

    // Support ribs under the S3's USB end
    // (sunk 0.5 mm into the end wall and floor: faces that merely touch leave a
    // non-manifold mesh)
    for (r = b_support_ribs)
        translate([wall + b_x + r[0], y_size + wall - b_support_y_size, wall - 0.5])
            cube([r[1] - r[0], b_support_y_size + 0.5, b_support_height + 0.5]);

    translate([wall + a_x, wall + a_y0, wall]) board_rails(a_width, a_row_spacing, a_rails);
    translate([wall + b_x, wall + b_y0, wall]) board_rails(b_width, b_row_spacing, b_rails);
}

// Lid cross-section in X-Z, cavity-relative x, z from the lid's underside. The edge
// reaches `flange` into each side wall at the bottom and bevels at 45 degrees back
// to the cavity face at the top, so it can't lift out and the groove above it
// prints without supports. Grow by `o` to get the groove that receives it.
module lid_profile(o=0){
    offset(delta=o) polygon([
        [-flange, 0], [x_size + flange, 0],
        [x_size + flange, lid_t - flange], [x_size, lid_t],
        [0, lid_t], [-flange, lid_t - flange]]);
}

module lid_slot(){
    // runs from out past the back face to the inside of the USB wall
    translate([wall, wall + y_size, lid_z0]) rotate([90, 0, 0])
        linear_extrude(height = y_size + wall + back_extra + 0.2) lid_profile(lid_c);
}

lid_top = lid_flush ? z_size : lid_z0 + lid_t;     // top face of the closed lid

// Channel under a flush lid for the C6's J5 jumper (a right-angle header with the
// cap lying flat, ~4-5 mm above the PCB; the 4.4 mm under the lid knocked it off).
// The lid slides in from the back, so the jumper passes under everything from its
// closed position forward: the channel runs from there to the lid's front edge.
// Position from the top-view photo, against the C6's pin rows: 2.3-7.6 mm in from
// the inner row toward the outer row, and from pin 7.5 to pin 10.3 along the board.
j5_from_inner = [2.25, 7.6];
j5_pins       = [7.46, 10.29];
j5_margin     = 1.5;
j5_depth      = 2.0;           // 6.4 mm clear above the PCB; leaves 1.5 mm of lid on top

module lid_body(with_ridge=true){
    len = y_size + wall + back_extra - lid_c;     // back face flush; front stops at the USB wall
    difference(){
        union(){
            translate([wall, wall + y_size - lid_c, lid_z0]) rotate([90, 0, 0])
                linear_extrude(height = len) lid_profile(0);
            if (lid_flush) {
                // raised middle, filling the opening up to the rim
                translate([wall + lid_c, -back_extra, lid_z0 + lid_t - 0.01])
                    cube([x_size - 2*lid_c, len, lid_top - (lid_z0 + lid_t) + 0.01]);
                // full-width block over the back wall, filling the corner notches
                // where the grooves exit. It only ever travels behind the box.
                translate([wall - flange, -back_extra, lid_z0])
                    cube([x_size + 2*flange, back_extra + wall - lid_c, lid_top - lid_z0]);
            }
        }

        // slots either side of the tongue, the full height of the lid
        for (sx = [-1, 1])
            translate([wall + x_size/2 + sx*(tongue_w/2 + tongue_gap/2) - tongue_gap/2,
                       -back_extra - 0.1, lid_z0 - 1])
                cube([tongue_gap, tongue_len + 0.1, lid_top - lid_z0 + 2]);

        // J5 channel (flush lid only)
        if (lid_flush) {
            inner_row_x = wall + a_x + (a_width - a_row_spacing)/2 + a_row_spacing;
            x0 = inner_row_x - j5_from_inner[1] - j5_margin;
            x1 = inner_row_x - j5_from_inner[0] + j5_margin;
            y0 = wall + a_y0 + a_pin(j5_pins[0]) - j5_margin;
            translate([x0, y0, lid_z0 - 0.01])
                cube([x1 - x0, wall + y_size - y0 + 0.1, j5_depth + 0.01]);
        }

        // grip grooves on top, either side of the tongue
        for (i = [0:3], sx = [-1, 1])
            translate([wall + x_size/2 + sx*(tongue_w/2 + tongue_gap + 2) - (sx < 0 ? 16 : 0),
                       -back_extra + 4 + i*3.2, lid_top - 0.5])
                cube([16, 1.2, 1]);
    }
    // ridge under the tongue's tip, over the middle of the back wall
    if (with_ridge) translate([wall + x_size/2 - tongue_w/2 + 0.5, ridge_y,
               lid_z0 + (ridge_r - ridge_h)])
        rotate([0, 90, 0]) cylinder(r=ridge_r, h=tongue_w - 1);
}

// "lid" exports in print orientation: flipped, top face on the bed, so the bevels
// are 45-degree overhangs and the ridge points up.
module lid(){
    if (part == "lid")
        // rotate, not mirror: a mirror prints the lid's chiral features (J5 channel)
        // on the wrong side
        translate([0, 0, lid_top]) rotate([0, 180, 0]) translate([-(x_size + 2*wall), 0, 0]) lid_body();
    else
        lid_body();
}

part = "both";   // "base", "lid" (print orientation) or "both" (assembled)
if (part == "base" || part == "both") base();
if (part == "lid"  || part == "both") lid();
