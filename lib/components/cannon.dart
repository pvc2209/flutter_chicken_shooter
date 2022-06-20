import 'dart:math';

import 'package:flame/components.dart';

import '../game.dart';

class Cannon extends SpriteComponent with HasGameRef<ChickenShooteGame> {
  late double oldAngle;
  late double newAngle;

  bool allowFire = false;

  @override
  Future<void>? onLoad() {
    oldAngle = angle;
    newAngle = angle;

    // print("base angle: $angle"); // 0.0

    return super.onLoad();
  }

  @override
  void update(double dt) {
    bool rotateDone = false;

    // Limit angle
    if (newAngle < -0.4 * pi) {
      newAngle = -0.4 * pi;
    }

    if (newAngle > 0.4 * pi) {
      newAngle = 0.4 * pi;
    }

    double diff = (newAngle - oldAngle).abs();

    if (diff < 0.02) {
      // diff có thể rất nhỏ dù có bấm liên tiếp vào 1 điểm, do đó ta có thể coi
      // nếu diff < 0.02 thì cannon đã xoay xong
      rotateDone = true;
    } else if (newAngle < oldAngle) {
      if (angle > newAngle) {
        angle -= diff * dt * 5;
      } else {
        oldAngle = newAngle;
        rotateDone = true;
      }
    } else if (newAngle > oldAngle) {
      if (angle < newAngle) {
        angle += diff * dt * 5;
      } else {
        oldAngle = newAngle;
        rotateDone = true;
      }
    }

    if (rotateDone && allowFire) {
      gameRef.addBullet();

      rotateDone = false;
      allowFire = false;
    }

    super.update(dt);
  }
}
