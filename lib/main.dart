import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    clearSystemBar(light);   // 여기에 두면 appbar 유무에 상관없이 작용
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: indigo),
        useMaterial3: true,
      ),

      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: w(context, 0.5),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: topCenter, 
          end: bottomCenter, 
          colors: [white, o(indigo)]
        ),
      ),
      child: const Scaffold(
        backgroundColor: transparent,
        body: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: spaceBetween,
            mainAxisSize: max,
            children: [
              Text('Hi'), 
              SwitchX(borderColor: white, barColor: indigo, circleColor: white),
              Text('Hi'), 
            ],
          ),
        ),
      ),
    );
  }
}

class SwitchX extends HookConsumerWidget {
  // final void Function(bool)? onChanged;
  final void Function()? onTap;
  final bool value;
  final double scale;
  final double height;
  final double width;
  final Color? borderColor;
  final Color? barColor;
  final Color? circleColor;
  const SwitchX({
    // this.onChanged,
    this.onTap,
    this.value = false,
    this.height = 20,
    this.width = 60,
    this.scale = 1,
    this.borderColor,    //
    this.barColor,    // mColor[5],
    this.circleColor, // mColor[6],
    super.key
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spot = useState(value);
    // return Container(
    //   color: red,
    //   height: height, 
    //   width: width,
    //   child: Transform.scale(
    //     scale: scale, 
    //     child: Switch.adaptive(
    //       inactiveTrackColor: color1,   
    //       activeColor: color2,          
    //       value: spot.value,
    //       onChanged: onChanged ?? (value) {spot.value = value;}
    //     ),
    //   ),
    // );
    return GestureDetector(
      onPanUpdate: (details) {
        if (details.delta.dx > 0) {spot.value = true;}
        else {spot.value = false;} 
      },
      child: Container(
        width: 56, 
        height: 28, 
        decoration: decoration(color: barColor, borderColor: borderColor),
        alignment: spot.value == false? centerLeft : centerRight,
        child: CircleAvatar(
          backgroundColor: transparent,
          child: CircleAvatar(
            radius: 8,
            backgroundColor: circleColor,
          ),
        ),
      ),
    );
  }
}

w(BuildContext context, [double? ratio])   // 0.04
=> MediaQuery.sizeOf(context).width * (ratio ?? 1);

h(BuildContext context, [double? ratio])   // 0.02
=> MediaQuery.sizeOf(context).height * (ratio ?? 1);

r({double? radius})
=> BorderRadius.all(Radius.circular(radius ?? 100));

b({double? width, Color? color})
=> Border.all(width: width ?? 1, color: color ?? transparent);

g({AlignmentGeometry? begin, AlignmentGeometry? end, List<Color>? colors}) 
=> LinearGradient(
  begin: begin ?? topCenter, 
  end: end ?? bottomCenter, 
  colors: colors ?? [white, o(indigo)]
);

o(Color color, [double? ratio]) 
=> color.withOpacity(ratio ?? 0.3);

decoration({
  double? radius,
  double? borderWidth,
  Color? borderColor,
  Color? color,
}) 
=> BoxDecoration(
  shape: BoxShape.rectangle,
  borderRadius: r(radius: radius),
  border: b(width: borderWidth, color: borderColor),
  gradient: g(),
  color: color, 
);

clearSystemBar(ThemeMode themeMode) 
=> SystemChrome.setSystemUIOverlayStyle(
  SystemUiOverlayStyle(
    statusBarColor: transparent,
    statusBarBrightness: themeMode == light ? Brightness.dark : Brightness.light,
    statusBarIconBrightness: themeMode == light ? Brightness.dark : Brightness.light,
  ),
);

void log(arg0, [arg1, arg2, arg3, arg4, arg5]) { 
  final args = [arg0, arg1, arg2, arg3, arg4, arg5];
  args.removeWhere((e) => e == null);
  debugPrint('\x1B[31;1m${args.join(", ")}\x1B[0m'); // red:31, magenta:35, yellow:33, green:32, cyan:36, blue:34
}

const transparent = Colors.transparent;
const white = Colors.white;
const blue = Colors.blue;
const indigo = Colors.indigo;
const purple = Colors.purple;
const pink = Colors.pink;
const red = Colors.red;
const light = ThemeMode.light;
const max = MainAxisSize.max;
const spaceBetween = MainAxisAlignment.spaceBetween;
const topCenter = Alignment.topCenter;
const centerLeft = Alignment.centerLeft;
const centerRight = Alignment.centerRight;
const bottomCenter = Alignment.bottomCenter;