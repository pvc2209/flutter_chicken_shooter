import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:fruit_catcher_oz/components/ball.dart';

import '../game.dart';
import '../widgets/top_panel.dart';
import 'explode.dart';

class Bullet extends SpriteComponent
    with CollisionCallbacks, HasGameRef<ChickenShooteGame> {
  Vector2 velocity = Vector2.all(0);
  Vector2 bullectDirection = Vector2.all(1);

  final double bulletSpeed = 320.0;
  bool visible = true;

  @override
  Future<void>? onLoad() {
    add(RectangleHitbox());
    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (visible) {
      super.update(dt);

      if (x > gameRef.size.x || x < 0 || y > gameRef.size.y || y < 0) {
        if (gameRef.contains(this)) {
          removeFromParent();
        }
      }

      velocity.x = bullectDirection.x * bulletSpeed;
      velocity.y = bullectDirection.y * bulletSpeed;

      position += velocity * dt;
    }
  }

  @override
  void render(Canvas canvas) {
    if (visible) {
      super.render(canvas);
    }
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);

    if (this.visible == true && other is Ball && other.visible == true) {
      this.visible = false;

      other.visible = false;

      final SpriteAnimation explodeAnimation = gameRef.explodeSpriteSheet
          .createAnimation(row: 0, stepTime: 0.1, to: 9);

      Explode explode = Explode()
        ..animation = explodeAnimation
        ..position =
            Vector2(other.x + other.width / 2, other.y + other.height / 2)
        ..size = Vector2.all(180)
        ..anchor = Anchor.center;

      gameRef.add(explode);

      Future.delayed(const Duration(milliseconds: 890), () {
        if (gameRef.contains(explode)) {
          explode.removeFromParent();
        }

        // Đoạn remove này phải xử lý khéo 1 tý
        // vì nếu remove bullet from parent thì gameRef sẽ không truy cập được nữa.
        if (gameRef.contains(this)) {
          this.removeFromParent();
        }
      });

      gameRef.score += 1;

      gameRef.overlays.remove(TopPanelWidget.id);
      gameRef.overlays.add(TopPanelWidget.id);
    }
  }
}
