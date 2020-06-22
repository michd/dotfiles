#!/bin/python3

import colorsys
import sys

# Color scheme formula:
# dictionary of all the keys found in the color.conf file, with as value
# a tuple of hue, saturation, and value adjustments

recipe1 = {
    "dmenu color": {
        "c_m_normal_bg": (0, -0.5, -0.7),
        "c_m_normal_fg": (0, -0.8, 0),
        "c_m_selected_bg": (0, -0.3, 1),
        "c_m_selected_fg": (0, -1, -1),
    },

    "window colors": {
        "c_c_focus_active_border": (0, -0.1, -0.1),
        "c_c_focus_active_bg": (0, -0.1, -0.1),
        "c_c_focus_active_text": (0, -1, -1),
        "c_c_focus_active_indic": (0, -1, 0),

        "c_c_focus_inactive_border": (0, -0.4, -0.4),
        "c_c_focus_inactive_bg": (0, -0.5, -0.5),
        "c_c_focus_inactive_text": (0, -0.6, 0),
        "c_c_focus_inactive_indic": (0, -0.559, 0.212),

        "c_c_focused_border": (0, -0.6, -0.6),
        "c_c_focused_bg": (0, -0.7, -0.7),
        "c_c_focused_text": (0, -0.8, -0.4),
        "c_c_focused_indic": (0, -0.5, -0.4),

        "c_c_urgent_border": (-0.5, 0.062, 0.169),
        "c_c_urgent_bg": (-0.5, 0.062, 0.169),
        "c_c_urgent_text": (-0.5, -0.590, 0.639),
        "c_c_urgent_indic": (-0.5, -0.205, 0.412),

        "c_c_placeholder_border": (0, -0.641, -0.361),
        "c_c_placeholder_bg": (0, -0.641, -0.314),
        "c_c_placeholder_text": (0, -0.641, 0.639),
        "c_c_placeholder_indic": (0, -0.641, -0.361),

        "c_c_bg": (0, 0.287, -0.196),
    },

    "bar colors": {
        "c_b_bg": (0, -0.4, -0.9),
        "c_b_status_text": (0, -0.9, 0.8),
        "c_b_separator": (0, -0.5, -0.5),

        "c_b_focused_ws_border": (0, -0.1, -0.1),
        "c_b_focused_ws_bg": (0, -0.1, -0.1),
        "c_b_focused_ws_text": (0, -1, -1),

        "c_b_active_ws_border": (0, -0.5, -0.5),
        "c_b_active_ws_bg": (0, -0.6, -0.6),
        "c_b_active_ws_text": (0, -1, 1),

        "c_b_inactive_ws_border": (0, -0.8, -0.7),
        "c_b_inactive_ws_bg": (0, -0.8, -0.8),
        "c_b_inactive_ws_text": (0, -0.9, -0.3),

        "c_b_urgent_ws_border": (-0.5, 0, 0),
        "c_b_urgent_ws_bg": (-0.5, 0, -0.2),
        "c_b_urgent_ws_text": (-0.5, -0.8, 1),

        "c_b_binding_mode_border": (-0.5, 0, 0),
        "c_b_binding_mode_bg": (-0.5, 0, -0.2),
        "c_b_binding_mode_text": (-0.5, -0.8, 1),
    }
}

def main():
    if len(sys.argv) < 2:
        print("Please provide a hex color to start from.")
        exit(1)

    base_color = sys.argv[1]

    # Trim leading '#'
    if base_color[0] == '#': base_color = base_color[1:]

    try:
        hex_to_rgb(base_color)
    except ValueError:
        print(f"Invalid base hex color #{base_color}")
        exit(1)

    base_color = normalize_color(base_color)

    if len(sys.argv) == 2:
        scheme = generate_scheme(base_color, recipe1)
        for l in scheme: print(l)

    elif sys.argv[2] == "reverse":
        if len(sys.argv) < 4:
            print("Please provide a filename with a colorscheme to reverse")
            exit(1)

        filename = sys.argv[3]
        reverse_scheme = reverse_engineer_scheme(base_color, filename)
        for l in reverse_scheme: print(l)

def get_longest_color_name(recipe):
    longest_name_len = 1
    for r_name, s_recipe in recipe.items():
        local_longest = max([len(n) for n in s_recipe.keys()])
        if local_longest > longest_name_len:
            longest_name_len = local_longest
    return longest_name_len


def generate_scheme(base_hex_color, recipe):
    file_header = "# Colors "
    line_length = 79

    longest_name_len = get_longest_color_name(recipe)

    scheme_lines = [
            f"{file_header:-<{line_length}}"
        ]

    for section_heading, sub_recipe in recipe.items():
        scheme_lines.append(f"# {section_heading}")
        scheme_lines.extend(
                generate_sub_scheme(
                    base_hex_color, sub_recipe, longest_name_len))
        scheme_lines.append("")

    return scheme_lines

def generate_sub_scheme(base_hex_color, sub_recipe, longest_name_len):
    base_hsv = hex_to_hsv(base_hex_color)

    scheme_list = []

    for color_name, adjustments in sub_recipe.items():
        new_color = hsv_to_hex(*adjust_hsv(*base_hsv, *adjustments))
        scheme_list.append(
                "set " \
                f"${color_name: <{longest_name_len}} "
                f"{new_color}")

    return scheme_list

def reverse_engineer_scheme(base_hex_color, filename):
    lines = []
    with open(filename) as f: lines = f.readlines()
    lines = [l.strip() for l in lines]

    base_h, base_s, base_v = hex_to_hsv(base_hex_color)

    named_hex_colors = {}
    adjustments = []

    for l in lines:
        if not l.startswith("set $"): continue
        name = l[5:-6].strip()
        hex_color = l[-6:]
        named_hex_colors[name] = hex_color

    for n, hex_color in named_hex_colors.items():
        h, s, v = hex_to_hsv(hex_color)
        adjustments.append(
                f"\"${n}\": ("
                f"{(h - base_h):.3f}, "
                f"{(s - base_s):.3f}, "
                f"{(v - base_v):.3f}),")
 

    return adjustments

def normalize_color(hex_color):
    h, s, v = hex_to_hsv(hex_color)
    return hsv_to_hex(h, 1.0 if s > 0 else 0, 1.0)


def adjust_hsv(h, s, v, h_adj, s_adj, v_adj):
    h += h_adj
    # If it's over or under, wrap around
    h = h if h >= 0 else 1 - (abs(h) % 1)
    h = h if h <= 1 else h % 1

    s += s_adj
    # Clip to 0..1.0
    s = s if s >= 0 else 0
    s = s if s <= 1.0 else 1.0

    v += v_adj
    # Clip to 0..1.0
    v = v if v >= 0 else 0
    v = v if v <= 1.0 else 1.0

    return h, s, v

def hex_to_rgb(hex_color):
    return int(hex_color[0:2], 16) / 255.0,\
           int(hex_color[2:4], 16) / 255.0,\
           int(hex_color[4:6], 16) / 255.0

def rgb_to_hex(r, g, b):
    return f"{hex(int(r * 255))[2:].upper():0>2}" \
            f"{hex(int(g * 255))[2:].upper():0>2}" \
            f"{hex(int(b * 255))[2:].upper():0>2}"

def hex_to_hsv(hex_color):
    return colorsys.rgb_to_hsv(*hex_to_rgb(hex_color))

def hsv_to_hex(h, s, v):
    return rgb_to_hex(*colorsys.hsv_to_rgb(h, s, v))

main()
