import 'package:go_router/go_router.dart';
import '../views/ciclo_vida/ciclo_vida_screen.dart';
import '../views/future/future_async_screen.dart';
import '../views/home/home_screen.dart';
import '../views/isolate/isolate_advanced_screen.dart';
import '../views/paso_parametros/detalle_screen.dart';
import '../views/paso_parametros/paso_parametros_screen.dart';
import '../views/timer/timer_screen.dart';
import '../views/widgets_demo/widgets_demo_screen.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/paso_parametros',
      builder: (context, state) => const PasoParametrosScreen(),
    ),
    GoRoute(
      path: '/detalle/:parametro/:metodo',
      builder: (context, state) {
        final parametro = state.pathParameters['parametro']!;
        final metodo = state.pathParameters['metodo']!;
        return DetalleScreen(parametro: parametro, metodoNavegacion: metodo);
      },
    ),
    GoRoute(
      path: '/ciclo_vida',
      builder: (context, state) => const CicloVidaScreen(),
    ),
    GoRoute(
      path: '/widgets_demo',
      builder: (context, state) => const WidgetsDemoScreen(),
    ),
    GoRoute(
      path: '/future_async',
      builder: (context, state) => const FutureAsyncScreen(),
    ),
    GoRoute(
      path: '/timer',
      builder: (context, state) => const TimerScreen(),
    ),
    GoRoute(
      path: '/isolate',
      builder: (context, state) => const IsolateAdvancedScreen(),
    ),
  ],
);
