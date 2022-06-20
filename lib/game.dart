import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';
import 'package:fruit_catcher_oz/components/bullet.dart';
import 'package:fruit_catcher_oz/components/cannon.dart';

import 'components/ball.dart';
import 'spref/spref.dart';
import 'widgets/game_over.dart';
import 'widgets/top_panel.dart';

class ChickenShooteGame extends FlameGame
    with HasTappableComponents, HasCollisionDetection {
  late final Cannon cannon;

  final List<Ball> balls = [];

  late Ball lastBall; // ball have lowest y

  bool gameOver = false;

  int numberOfBalls = 10;
  int score = 0;
  // int life = 10;
  bool canSpeedUp = true;

  List<Vector2> initRandomBallPositions = [];

  static int distanceBetweenBalls = 120;

  late SpriteSheet explodeSpriteSheet;

  late Sprite bulletSprite;

  @override
  Future<void>? onLoad() async {
    bulletSprite = await loadSprite("bullet.png");

    cannon = Cannon()
      ..sprite = await loadSprite("cannon.png")
      ..size = Vector2(101, 138)
      ..position = Vector2(size.x / 2, size.y - 138 / 2)
      // ..debugMode = true
      ..anchor = Anchor.center;

    add(cannon);

    explodeSpriteSheet = SpriteSheet(
        image: await images.load('spritesheet.png'), srcSize: Vector2.all(192));

    // Random ball positions
    initRandomBallPositions
        .add(Vector2(Random().nextInt(size.x.toInt() - 80).toDouble(), -100));

    for (int i = 1; i < numberOfBalls; i++) {
      Vector2 position = Vector2(
        Random().nextInt(size.x.toInt() - 80).toDouble(),
        initRandomBallPositions[i - 1].y - distanceBetweenBalls,
      );

      initRandomBallPositions.add(position);
    }

    for (int i = 0; i < initRandomBallPositions.length; ++i) {
      balls.add(
        Ball()
          ..sprite = await loadSprite("ball$i.png")
          ..size = Vector2(80, 80)
          ..x = initRandomBallPositions[i].x
          ..y = initRandomBallPositions[i].y
          // ..debugMode = true
          ..anchor = Anchor.topLeft,
      );
    }

    for (final fruit in balls) {
      add(fruit);
    }

    lastBall = balls.last;

    return super.onLoad();
  }

  void endGame() {
    gameOver = true;
    overlays.add(GameOver.id);

    saveHighScore();
  }

  void saveHighScore() async {
    int top1 = await SPref.instance.getInt("top1") ?? 0;
    int top2 = await SPref.instance.getInt("top2") ?? 0;
    int top3 = await SPref.instance.getInt("top3") ?? 0;

    if (score > top1) {
      SPref.instance.setInt("top1", score);
      SPref.instance.setInt("top2", top1);
      SPref.instance.setInt("top3", top2);
    } else if (score > top2) {
      SPref.instance.setInt("top2", score);
      SPref.instance.setInt("top3", top2);
    } else if (score > top3) {
      SPref.instance.setInt("top3", score);
    }
  }

  @override
  void update(double dt) {
    if (!gameOver) {
      super.update(dt);

      // Update the fruit's position
      for (int i = 0; i < balls.length; ++i) {
        if (balls[i].y > size.y) {
          // life--;
          overlays.remove(TopPanelWidget.id);
          overlays.add(TopPanelWidget.id);

          // if (life <= 0) {
          //   gameOver = true;
          //   overlays.add(GameOver.id);
          // }
        }

        if (balls[i].y > size.y) {
          balls[i].x = Random().nextInt(size.x.toInt() - 80).toDouble();

          balls[i].y = lastBall.y - distanceBetweenBalls;

          lastBall = balls[i];

          balls[i].visible = true;
        } else {
          balls[i].position += balls[i].velocity * dt;
        }
      }

      // update fruit y speed
      if (score > 0 && score % 10 == 0) {
        if (canSpeedUp) {
          // life++;
          for (final fruit in balls) {
            if (fruit.velocity.y <= 220) {
              fruit.velocity.y += 10;
            } else {
              fruit.velocity.y += 5;
            }
          }

          canSpeedUp = false;
        }
      } else {
        canSpeedUp = true;
      }
    }
  }

  late Vector2 bulletDirection;
  late double newAngle;

  @override
  void onTapDown(TapDownEvent event) async {
    Vector2 tapPosition = event.canvasPosition;

    // print("tapPosition $tapPosition");

    Vector2 diff = tapPosition - cannon.position;

    newAngle = diff.screenAngle();

    cannon.oldAngle = cannon.angle;
    cannon.newAngle = newAngle;

    bulletDirection =
        Vector2(diff.x / diff.normalize(), diff.y / diff.normalize());

    // print("bulletDirection $bulletDirection");

    // add(Bullet()
    //   ..sprite = await loadSprite("cannon.png")
    //   ..bullectDirection = bulletDirection
    //   ..size = Vector2(51 / 2, 101 / 2)
    //   ..angle = newAngle
    //   ..anchor = Anchor.center
    //   ..position = cannon.position + bulletDirection * 80);

    cannon.allowFire = true;

    super.onTapDown(event);
  }

  void addBullet() {
    add(Bullet()
      ..sprite = bulletSprite
      ..bullectDirection = bulletDirection
      ..size = Vector2(51 / 2, 101 / 2)
      ..angle = newAngle
      ..anchor = Anchor.center
      ..position = cannon.position + bulletDirection * 80);
  }
}
