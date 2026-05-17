import 'dart:io';

import 'package:image/image.dart';

/// Meditation app icon — seated person in lotus pose (B&W Dhyan theme).
void main() {
  const size = 1024;
  final dir = Directory('assets/icon');
  if (!dir.existsSync()) dir.createSync(recursive: true);

  final full = _renderFull(size);
  File('assets/icon/app_icon.png').writeAsBytesSync(encodePng(full));

  final fg = _renderForeground(size);
  File('assets/icon/app_icon_foreground.png').writeAsBytesSync(encodePng(fg));

  stdout.writeln('Wrote assets/icon/app_icon.png');
  stdout.writeln('Wrote assets/icon/app_icon_foreground.png');
}

Image _renderFull(int size) {
  final img = Image(width: size, height: size);
  fill(img, color: ColorRgb8(10, 10, 10));
  _drawMeditatingPerson(img, size, symbolOnly: false);
  return img;
}

Image _renderForeground(int size) {
  final img = Image(width: size, height: size, numChannels: 4);
  fill(img, color: ColorRgba8(0, 0, 0, 0));
  _drawMeditatingPerson(img, size, symbolOnly: true);
  return img;
}

Color _cut({required bool symbolOnly}) =>
    symbolOnly ? ColorRgba8(0, 0, 0, 0) : ColorRgb8(10, 10, 10);

void _drawMeditatingPerson(Image img, int size, {required bool symbolOnly}) {
  final cx = size ~/ 2;
  final cy = size ~/ 2 + 36;
  const white = ColorRgb8(255, 255, 255);
  final cut = _cut(symbolOnly: symbolOnly);

  // Soft halo
  fillCircle(img, x: cx, y: cy - 20, radius: 340, color: ColorRgb8(28, 28, 28));

  // Crossed legs (lotus base)
  fillCircle(img, x: cx - 118, y: cy + 168, radius: 88, color: white);
  fillCircle(img, x: cx + 118, y: cy + 168, radius: 88, color: white);
  fillCircle(img, x: cx, y: cy + 188, radius: 72, color: white);

  // Torso / hips
  fillCircle(img, x: cx, y: cy + 52, radius: 132, color: white);

  // Leg gap (seated triangle between legs)
  fillCircle(img, x: cx, y: cy + 118, radius: 58, color: cut);
  fillCircle(img, x: cx, y: cy + 52, radius: 52, color: cut);

  // Arms resting on knees
  fillCircle(img, x: cx - 168, y: cy + 72, radius: 44, color: white);
  fillCircle(img, x: cx + 168, y: cy + 72, radius: 44, color: white);
  fillCircle(img, x: cx - 138, y: cy + 28, radius: 38, color: white);
  fillCircle(img, x: cx + 138, y: cy + 28, radius: 38, color: white);

  // Shoulders
  fillCircle(img, x: cx, y: cy - 48, radius: 118, color: white);

  // Neck space
  fillCircle(img, x: cx, y: cy - 8, radius: 42, color: cut);

  // Head
  fillCircle(img, x: cx, y: cy - 132, radius: 72, color: white);

  // Calm face hint — minimal (closed eyes / peace)
  fillCircle(img, x: cx - 26, y: cy - 138, radius: 8, color: cut);
  fillCircle(img, x: cx + 26, y: cy - 138, radius: 8, color: cut);

  // Hands together optional — mudra dot at center chest
  fillCircle(img, x: cx, y: cy + 8, radius: 22, color: white);
  fillCircle(img, x: cx, y: cy + 8, radius: 12, color: cut);
}
