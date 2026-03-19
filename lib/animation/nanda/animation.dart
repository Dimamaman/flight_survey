import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

void main() {
  runApp(
    const MaterialApp(
      home: Scaffold(body: SafeArea(child: SimpleOpacityTweenExample())),
    ),
  );
}

class FrameScheduledOpacityWidget extends StatefulWidget {
  const FrameScheduledOpacityWidget({super.key});

  @override
  State<FrameScheduledOpacityWidget> createState() =>
      _FrameScheduledOpacityWidgetState();
}

class _FrameScheduledOpacityWidgetState
    extends State<FrameScheduledOpacityWidget>
    with SingleTickerProviderStateMixin {
  double _opacity = 0.5;
  bool _isSchedulerRunning = false;
  Duration _lastFrameTime = Duration.zero;
  int _frameCount = 0;

  // Constants for animation
  final double _startOpacity = 0.5;
  final double _endOpacity = 1.0;
  final Duration _totalDuration = const Duration(seconds: 6);

  void _startFrameScheduler() {
    if (_isSchedulerRunning) return;

    _isSchedulerRunning = true;
    _lastFrameTime = Duration.zero;
    _frameCount = 0;
    _opacity = _startOpacity;

    SchedulerBinding.instance.scheduleFrameCallback(_onFrame);
    setState(() {}); // Update button text
  }

  void _onFrame(Duration timeStamp) {
    if (!_isSchedulerRunning) return;

    _frameCount++;
    if (_lastFrameTime == Duration.zero) {
      _lastFrameTime = timeStamp;
      SchedulerBinding.instance.scheduleFrameCallback(_onFrame);
      return;
    }

    final elapsed = timeStamp - _lastFrameTime;

    final progress = elapsed.inMicroseconds / _totalDuration.inMicroseconds;

    setState(() {
      _opacity = _startOpacity + (_endOpacity - _startOpacity) * progress;

      if (progress >= 1.0 || _opacity >= _endOpacity) {
        _opacity = _endOpacity;
        _isSchedulerRunning = false;
        return;
      }
    });

    SchedulerBinding.instance.scheduleFrameCallback(_onFrame);
  }

  @override
  void dispose() {
    _isSchedulerRunning = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final elapsedSeconds = _lastFrameTime == Duration.zero
        ? 0.0
        : (_opacity - _startOpacity) /
              (_endOpacity - _startOpacity) *
              _totalDuration.inMilliseconds /
              1000;

    return Column(
      children: [
        Opacity(
          opacity: _opacity,
          child: Container(
            width: 300,
            height: 300,
            alignment: Alignment.center,
            color: Colors.blueAccent,
            child: Text(
              "Container opacity: ${_opacity.toStringAsFixed(2)}\nFrame Count: $_frameCount\nElapsed: ${elapsedSeconds.toStringAsFixed(1)}s",
              style: const TextStyle(color: Colors.white, fontSize: 24),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: _startFrameScheduler,
          child: Text(
            _isSchedulerRunning
                ? "Frame Scheduler Running!"
                : "Start Frame Scheduler",
            style: const TextStyle(color: Colors.black, fontSize: 23),
          ),
        ),
      ],
    );
  }
}

class TickerScheduledOpacityWidget extends StatefulWidget {
  const TickerScheduledOpacityWidget({super.key});

  @override
  State<TickerScheduledOpacityWidget> createState() =>
      _TickerScheduledOpacityWidgetState();
}

class _TickerScheduledOpacityWidgetState
    extends State<TickerScheduledOpacityWidget>
    with SingleTickerProviderStateMixin {
  double _opacity = 0.5;
  bool _isSchedulerRunning = false;
  late final Ticker _ticker;
  int _tickCount = 0;
  Duration _elapsedDuration = Duration.zero;

  // Constants for animation
  final double _startOpacity = 0.5;
  final double _endOpacity = 1.0;
  final Duration _totalDuration = const Duration(seconds: 6);

  @override
  void initState() {
    super.initState();
    _ticker = createTicker((elapsed) {
      log("JJJJJJJJJ $elapsed");
      _tickCount++;
      _elapsedDuration = elapsed;

      // Calculate progress (0.0 to 1.0) based on elapsed time
      final progress = elapsed.inMicroseconds / _totalDuration.inMicroseconds;

      setState(() {
        // Interpolate opacity between start and end values
        _opacity = _startOpacity + (_endOpacity - _startOpacity) * progress;

        if (progress >= 1.0 || _opacity >= _endOpacity) {
          _opacity = _endOpacity;
          _ticker.stop();
          _isSchedulerRunning = false;
        }
      });
    });
  }

  void _startTickerScheduler() {
    if (_isSchedulerRunning) return;

    setState(() {
      _isSchedulerRunning = true;
      _opacity = _startOpacity;
      _tickCount = 0;
      _elapsedDuration = Duration.zero;
      _ticker.start();
    });
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Calculate progress as a percentage of total duration
    final elapsedSeconds = _elapsedDuration.inMilliseconds;

    return Column(
      children: [
        Opacity(
          opacity: _opacity,
          child: Container(
            width: 300,
            height: 300,
            alignment: Alignment.center,
            color: Colors.blueAccent,
            child: Text(
              "Container opacity: ${_opacity.toStringAsFixed(3)}\n"
              "Tick Count: $_tickCount\n"
              "Elapsed: ${(elapsedSeconds / 1000).toStringAsFixed(1)}s",
              style: const TextStyle(color: Colors.white, fontSize: 24),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: _startTickerScheduler,
          child: Text(
            _isSchedulerRunning ? "Ticker Running!" : "Start Ticker",
            style: const TextStyle(color: Colors.black, fontSize: 23),
          ),
        ),
      ],
    );
  }
}

class ManualAnimationControllerExampleApp extends StatefulWidget {
  const ManualAnimationControllerExampleApp({super.key});

  @override
  State<ManualAnimationControllerExampleApp> createState() =>
      _ManualAnimationControllerExampleAppState();
}

class _ManualAnimationControllerExampleAppState
    extends State<ManualAnimationControllerExampleApp>
    with SingleTickerProviderStateMixin {
  double _opacity = 0.5;
  late AnimationController _animationController;
  late Animation<double> _animation;
  Duration _elapsedDuration = Duration.zero;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 6),
      vsync: this,
    );

    _animation = Tween<double>(
      begin: 0.5,
      end: 1,
    ).animate(_animationController);

    _animation.addListener(() {
      setState(() {
        _opacity = _animation.value;
        if (_animationController.isAnimating) {
          if (_animationController.status == AnimationStatus.forward) {
            _elapsedDuration =
                _animationController.lastElapsedDuration ?? Duration.zero;
          } else if (_animationController.status == AnimationStatus.reverse) {
            _elapsedDuration =
                _animationController.duration! -
                (_animationController.lastElapsedDuration ?? Duration.zero);
          }
        }
      });
    });

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _elapsedDuration = _animationController.duration!;
      } else if (status == AnimationStatus.dismissed) {
        _elapsedDuration = Duration.zero;
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Manual Animation Controller Example'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Opacity(
                opacity: _opacity,
                child: Container(
                  width: 400,
                  height: 400,
                  alignment: Alignment.center,
                  color: Colors.blueAccent,
                  child: Text(
                    "AnimatedController container\n"
                    "Opacity: ${_opacity.toStringAsFixed(2)}\n"
                    "Elapsed: ${(_elapsedDuration.inMilliseconds / 1000).toStringAsFixed(1)}s\n"
                    "Status: ${_animationController.status.toString()}",
                    style: const TextStyle(color: Colors.white, fontSize: 24),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _animationController.forward();
                },
                child: const Text('Start Animation'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  _animationController.reverse();
                },
                child: const Text('Reverse Animation'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _elapsedDuration = Duration.zero;
                    _animationController.reset();
                  });
                },
                child: const Text('Reset Animation'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  _animationController.stop();
                  _animationController.dispose();
                },
                child: const Text('Dispose Animation'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// AnimatedWidget approach for opacity animation
//
// Key differences from manual AnimationController usage:
// 1. No need for manual setState() calls when animation value changes
// 2. Animation logic is encapsulated in a reusable widget
// 3. Widget rebuilds automatically when animation ticks
// 4. Cleaner separation between animation setup and UI updates
/*class SimpleAnimatedWidgetOpacity extends StatefulWidget {
  const SimpleAnimatedWidgetOpacity({super.key});

  @override
  State<SimpleAnimatedWidgetOpacity> createState() =>
      _SimpleAnimatedWidgetOpacityState();
}

class _SimpleAnimatedWidgetOpacityState
    extends State<SimpleAnimatedWidgetOpacity>
    with SingleTickerProviderStateMixin {
  // AnimationController is still needed to drive the animation
  // This is common between both approaches
  late final AnimationController _controller;

  // Animation<double> defines how the value changes over time
  // In manual approach, we would need to listen to this directly
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    // Controller setup is same as manual approach
    _controller = AnimationController(
      duration: const Duration(seconds: 6),
      vsync: this,
    );

    // Animation setup is same as manual approach
    // The difference is we won't need to manually listen to value changes
    _animation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Simple AnimatedWidget Example')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Instead of manually listening to animation changes and calling setState,
              // we pass the animation to AnimatedWidget which handles updates automatically
              SimpleOpacityWidget(animation: _animation),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Controller methods remain the same as manual approach
                  ElevatedButton(
                    onPressed: () => _controller.forward(),
                    child: const Text('Fade In'),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () => _controller.reverse(),
                    child: const Text('Fade Out'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}*/

// Key advantages over AnimatedWidget:
// 1. No need to create a separate widget class - everything in one place
// 2. Child widget optimization - static child is not rebuilt on every animation tick
// 3. More flexible - can animate multiple properties in a single builder
// 4. Easier composition - can wrap any existing widget without subclassing
// 5. Better separation - animation logic stays with the parent widget
class SimpleAnimatedBuilderOpacity extends StatefulWidget {
  const SimpleAnimatedBuilderOpacity({super.key});

  @override
  State<SimpleAnimatedBuilderOpacity> createState() =>
      _SimpleAnimatedBuilderOpacityState();
}

class _SimpleAnimatedBuilderOpacityState
    extends State<SimpleAnimatedBuilderOpacity>
    with SingleTickerProviderStateMixin {
  // Animation setup is identical to AnimatedWidget
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    // Controller setup same as AnimatedWidget
    _controller = AnimationController(
      duration: const Duration(seconds: 6),
      vsync: this,
    );

    // Animation configuration identical to AnimatedWidget
    _animation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Simple AnimatedBuilder Example')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Instead of creating a separate AnimatedWidget class,
              // we directly use AnimatedBuilder here
              AnimatedBuilder(
                animation: _animation,
                // Performance optimization: static child won't rebuild
                // In AnimatedWidget, the entire widget tree would rebuild
                child: Container(
                  width: 200,
                  height: 200,
                  color: Colors.blue,
                  child: const Center(
                    child: Text(
                      'Animated Opacity',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),
                // Only the builder function is called on animation ticks
                // More efficient than AnimatedWidget which rebuilds everything
                builder: (context, child) =>
                    Opacity(opacity: _animation.value, child: child),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Animation control identical to AnimatedWidget
                  ElevatedButton(
                    onPressed: () => _controller.forward(),
                    child: const Text('Fade In'),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () => _controller.reverse(),
                    child: const Text('Fade Out'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Custom AnimatedWidget that handles the opacity animation
//
// Benefits over manual AnimationController approach:
// 1. No need to add animation listeners manually
// 2. No need to call setState() when animation value changes
// 3. Animation value updates are handled automatically
// 4. Widget code focuses purely on building UI with current value
// 5. No need to have StatefulWidget along with State defined for this.
// class SimpleOpacityWidget extends AnimatedWidget {
//   // Animation is passed to super as listenable
//   // In manual approach, we would need to add listeners to this animation
//   const SimpleOpacityWidget({super.key, required Animation<double> animation})
//     : super(listenable: animation);
//
//   @override
//   Widget build(BuildContext context) {
//     // Get current animation value - no listener needed
//     // In manual approach, we would need an animation listener
//     // to trigger setState when this value changes
//     final animation = listenable as Animation<double>;
//
//     // Build UI with current animation value
//     // This method is called automatically when animation ticks
//
//     log("JJJJJJJ ${animation.value}");
//
//     return Opacity(
//       opacity: animation.value,
//       child: Container(
//         width: 200,
//         height: 200,
//         color: Colors.blue,
//         child: Center(
//           child: Text(
//             'Opacity: ${animation.value.toStringAsFixed(2)}',
//             style: const TextStyle(color: Colors.white, fontSize: 20),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class SimpleAnimatedWidgetOpacity extends StatefulWidget {
//   const SimpleAnimatedWidgetOpacity({super.key});
//
//   @override
//   State<SimpleAnimatedWidgetOpacity> createState() =>
//       _SimpleAnimatedWidgetOpacityState();
// }

// class _SimpleAnimatedWidgetOpacityState extends State<SimpleAnimatedWidgetOpacity>
//     with SingleTickerProviderStateMixin {
//   // AnimationController is still needed to drive the animation
//   // This is common between both approaches
//   late final AnimationController _controller;
//
//   // Animation<double> defines how the value changes over time
//   // In manual approach, we would need to listen to this directly
//   late final Animation<double> _animation;
//
//   @override
//   void initState() {
//     super.initState();
//     // Controller setup is same as manual approach
//     _controller = AnimationController(
//       duration: const Duration(seconds: 6),
//       vsync: this,
//     );
//
//     // Animation setup is same as manual approach
//     // The difference is we won't need to manually listen to value changes
//     _animation = Tween<double>(begin: 0.5, end: 1.0).animate(
//       CurvedAnimation(
//         parent: _controller,
//         curve: Curves.easeInOut,
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('Simple AnimatedWidget Example'),
//         ),
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               // Instead of manually listening to animation changes and calling setState,
//               // we pass the animation to AnimatedWidget which handles updates automatically
//               SimpleOpacityWidget(animation: _animation),
//               const SizedBox(height: 20),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   // Controller methods remain the same as manual approach
//                   ElevatedButton(
//                     onPressed: () => _controller.forward(),
//                     child: const Text('Fade In'),
//                   ),
//                   const SizedBox(width: 20),
//                   ElevatedButton(
//                     onPressed: () => _controller.reverse(),
//                     child: const Text('Fade Out'),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// Custom AnimatedWidget that handles the opacity animation
//
// Benefits over manual AnimationController approach:
// 1. No need to add animation listeners manually
// 2. No need to call setState() when animation value changes
// 3. Animation value updates are handled automatically
// 4. Widget code focuses purely on building UI with current value
// 5. No need to have StatefulWidget along with State defined for this.
class SimpleOpacityWidget extends AnimatedWidget {
  // Animation is passed to super as listenable
  // In manual approach, we would need to add listeners to this animation
  const SimpleOpacityWidget({super.key, required Animation<double> animation})
    : super(listenable: animation);

  @override
  Widget build(BuildContext context) {
    // Get current animation value - no listener needed
    // In manual approach, we would need an animation listener
    // to trigger setState when this value changes
    final animation = listenable as Animation<double>;

    // Build UI with current animation value
    // This method is called automatically when animation ticks
    return Opacity(
      opacity: animation.value,
      child: Container(
        width: 200,
        height: 200,
        color: Colors.blue,
        child: Center(
          child: Text(
            'Opacity: ${animation.value.toStringAsFixed(2)}',
            style: const TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ),
    );
  }
}

// Custom ImplicitlyAnimatedWidget for opacity animation
//
// Benefits of ImplicitlyAnimatedWidget:
// 1. Handles animation lifecycle automatically
// 2. No need to manage AnimationController
// 3. Need to configurate duration and curve, and pass it to super constructor
// 4. Need to create state to manage value ranges
// 5. Great for state-driven animations where you just care about start/end states
class CustomImplicitlyAnimatedOpacity extends ImplicitlyAnimatedWidget {
  // The target opacity value we want to animate to
  final double opacity;

  const CustomImplicitlyAnimatedOpacity({
    super.key,
    required this.opacity,
    required Duration duration,
    Curve curve = Curves.easeInOut,
  }) : super(duration: duration, curve: curve);

  @override
  ImplicitlyAnimatedWidgetState<CustomImplicitlyAnimatedOpacity>
  createState() => _CustomImplicitlyAnimatedOpacityState();
}

class _CustomImplicitlyAnimatedOpacityState
    extends ImplicitlyAnimatedWidgetState<CustomImplicitlyAnimatedOpacity> {
  // Tween to manage the opacity animation
  Tween<double>? _opacityTween;
  late Animation<double> _opacityAnimation;

  // Called when the target opacity value changes, during setState()
  // Core of ImplicitlyAnimatedWidget
  // Needs to create/update the value range using tween
  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _opacityTween =
        visitor(
              _opacityTween,
              widget.opacity,
              (dynamic value) => Tween<double>(begin: value as double),
            )
            as Tween<double>?;
  }

  // Called when the tween is created, during setState(), after forEachTween()
  // Built animation can be be used as `Animation` object in AnimatedBuilder/AnimatedWidget
  @override
  void didUpdateTweens() {
    _opacityAnimation = animation.drive(_opacityTween!);
  }

  // Build method uses the animated value from the tween
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _opacityAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _opacityAnimation.value,
          child: Container(
            width: 200,
            height: 200,
            color: Colors.blue,
            child: Center(
              child: Column(
                spacing: 20,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Implicitly Animated',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  Text(
                    'Target Opacity: ${widget.opacity.toStringAsFixed(2)}',
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  Text(
                    'Opacity: ${(_opacityAnimation.value).toStringAsFixed(2)}',
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class SimpleImplicitOpacityExample extends StatefulWidget {
  const SimpleImplicitOpacityExample({super.key});

  @override
  State<SimpleImplicitOpacityExample> createState() =>
      _SimpleImplicitOpacityExampleState();
}

class _SimpleImplicitOpacityExampleState
    extends State<SimpleImplicitOpacityExample> {
  double _opacity = 0.5;

  void _toggleOpacity() {
    setState(() {
      _opacity = 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Simple Implicit Animation Example')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Using our custom ImplicitlyAnimatedWidget
              CustomImplicitlyAnimatedOpacity(
                opacity: _opacity,
                duration: const Duration(seconds: 6),
                curve: Curves.easeInOut,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _toggleOpacity,
                child: const Text('Increase Opacity'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ## Advantages of TweenAnimationBuilder
///
/// [TweenAnimationBuilder] offers:
/// 1. **Simplicity**: No need to manage AnimationController
/// 2. **Flexibility**: Can animate any type that can be interpolated
/// 3. **Reusability**: Easy to extract and reuse animation logic
/// 4. **Performance**: Automatically handles animation lifecycle
/// 5. **Maintainability**: Less code, fewer potential bugs
///
/// ## When to Use Each
///
/// Use [TweenAnimationBuilder] when:
/// - You need a custom animation without complexity
/// - You want to animate non-standard properties
/// - You need more control than ImplicitlyAnimatedWidget
/// - You want to avoid AnimationController boilerplate
///
/// Use [AnimatedBuilder] when:
/// - You need precise control over the animation
/// - You want to share an AnimationController
/// - You're building complex, multi-part animations
/// - You need to manually control the animation state
///
/// Use [ImplicitlyAnimatedWidget] when:
/// - You're using standard widget properties
/// - You need the simplest possible animation
/// - You're building a reusable animated widget
/// - Performance is critical
///
/// This example demonstrates the simplicity and power of [TweenAnimationBuilder]
/// while maintaining the flexibility to create custom animations.

class SimpleOpacityTweenExample extends StatefulWidget {
  const SimpleOpacityTweenExample({super.key});

  @override
  State<SimpleOpacityTweenExample> createState() =>
      _SimpleOpacityTweenExampleState();
}

class _SimpleOpacityTweenExampleState extends State<SimpleOpacityTweenExample> {
  // Controls whether we're fading in (true) or out (false)
  bool _isFadingIn = true;

  void _toggleFade() {
    setState(() {
      _isFadingIn = !_isFadingIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('Simple Opacity Tween')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Opacity animation using TweenAnimationBuilder
              TweenAnimationBuilder<double>(
                // Tween defines the interpolation from start to end value
                tween: Tween<double>(
                  begin:
                      0.5, // begin value is used only for first time, for next time onwards it'll use whatever is the current value.
                  end: _isFadingIn ? 1.0 : 0.5,
                ),
                // Animation duration
                duration: const Duration(seconds: 6),
                // Builder function called on each animation frame
                builder: (context, opacity, child) {
                  return Opacity(
                    opacity: opacity,
                    child: Container(
                      width: 300,
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.3),
                            blurRadius: 10,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Opacity: ${opacity.toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            _isFadingIn ? 'Fading In' : 'Fading Out',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 40),
              // Button to toggle fade direction
              ElevatedButton(
                onPressed: _toggleFade,
                child: Text(_isFadingIn ? 'Fade Out' : 'Fade In'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
