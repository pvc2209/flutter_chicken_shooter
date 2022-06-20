import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../game.dart';

class Ball extends SpriteComponent with HasGameRef<ChickenShooteGame> {
  bool visible = true;
  Vector2 velocity = Vector2(0, 180);

  @override
  Future<void>? onLoad() {
    add(RectangleHitbox());
    return super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    if (visible) {
      super.render(canvas);
    }
  }

//   @override
//   void onTapDown(TapDownEvent event) {
//     if (visible) {
// // add explode animation
//       final SpriteAnimation explodeAnimation = gameRef.explodeSpriteSheet
//           .createAnimation(row: 0, stepTime: 0.05, to: 30);

//       Explode explode = Explode()
//         ..animation = explodeAnimation
//         ..position = Vector2(x + width / 2, y + height / 2)
//         ..size = Vector2.all(180)
//         ..anchor = Anchor.center;

//       gameRef.add(explode);

//       Future.delayed(const Duration(milliseconds: 1500), () {
//         gameRef.remove(explode);
//       });
//     }

//     visible = false;

//     gameRef.score += 1;

//     gameRef.overlays.remove(TopPanelWidget.id);
//     gameRef.overlays.add(TopPanelWidget.id);

//     super.onTapDown(event);
//   }
}
