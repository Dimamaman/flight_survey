import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    const MaterialApp(
      home: OrderHistoryPage(),
      debugShowCheckedModeBanner: false,
    ),
  );
}

@immutable
class ExampleCupertinoDownloadButton extends StatefulWidget {
  const ExampleCupertinoDownloadButton({super.key});

  @override
  State<ExampleCupertinoDownloadButton> createState() =>
      _ExampleCupertinoDownloadButtonState();
}

class _ExampleCupertinoDownloadButtonState
    extends State<ExampleCupertinoDownloadButton> {
  late final List<DownloadController> _downloadControllers;

  @override
  void initState() {
    super.initState();
    _downloadControllers = List<DownloadController>.generate(
      20,
      (index) => SimulatedDownloadController(
        onOpenDownload: () {
          _openDownload(index);
        },
      ),
    );
  }

  void _openDownload(int index) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Open App ${index + 1}')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Apps')),
      body: ListView.separated(
        itemCount: _downloadControllers.length,
        separatorBuilder: (_, _) => const Divider(),
        itemBuilder: _buildListItem,
      ),
    );
  }

  Widget _buildListItem(BuildContext context, int index) {
    final theme = Theme.of(context);
    final downloadController = _downloadControllers[index];

    return ListTile(
      leading: const DemoAppIcon(),
      title: Text(
        'App ${index + 1}',
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.titleLarge,
      ),
      subtitle: Text(
        'Lorem ipsum dolor #${index + 1}',
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.bodySmall,
      ),
      trailing: SizedBox(
        width: 96,
        child: AnimatedBuilder(
          animation: downloadController,
          builder: (context, child) {
            return DownloadButton(
              status: downloadController.downloadStatus,
              downloadProgress: downloadController.progress,
              onDownload: downloadController.startDownload,
              onCancel: downloadController.stopDownload,
              onOpen: downloadController.openDownload,
            );
          },
        ),
      ),
    );
  }
}

@immutable
class DemoAppIcon extends StatelessWidget {
  const DemoAppIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return const AspectRatio(
      aspectRatio: 1,
      child: FittedBox(
        child: SizedBox(
          width: 80,
          height: 80,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [Colors.red, Colors.blue]),
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Center(
              child: Icon(Icons.ac_unit, color: Colors.white, size: 40),
            ),
          ),
        ),
      ),
    );
  }
}

enum DownloadStatus { notDownloaded, fetchingDownload, downloading, downloaded }

abstract class DownloadController implements ChangeNotifier {
  DownloadStatus get downloadStatus;
  double get progress;

  void startDownload();
  void stopDownload();
  void openDownload();
}

class SimulatedDownloadController extends DownloadController
    with ChangeNotifier {
  SimulatedDownloadController({
    DownloadStatus downloadStatus = DownloadStatus.notDownloaded,
    double progress = 0.0,
    required VoidCallback onOpenDownload,
  }) : _downloadStatus = downloadStatus,
       _progress = progress,
       _onOpenDownload = onOpenDownload;

  DownloadStatus _downloadStatus;
  @override
  DownloadStatus get downloadStatus => _downloadStatus;

  double _progress;
  @override
  double get progress => _progress;

  final VoidCallback _onOpenDownload;

  bool _isDownloading = false;

  @override
  void startDownload() {
    if (downloadStatus == DownloadStatus.notDownloaded) {
      _doSimulatedDownload();
    }
  }

  @override
  void stopDownload() {
    if (_isDownloading) {
      _isDownloading = false;
      _downloadStatus = DownloadStatus.notDownloaded;
      _progress = 0.0;
      notifyListeners();
    }
  }

  @override
  void openDownload() {
    if (downloadStatus == DownloadStatus.downloaded) {
      _onOpenDownload();
    }
  }

  Future<void> _doSimulatedDownload() async {
    _isDownloading = true;
    _downloadStatus = DownloadStatus.fetchingDownload;
    notifyListeners();

    // Wait a second to simulate fetch time.
    await Future<void>.delayed(const Duration(seconds: 1));

    // If the user chose to cancel the download, stop the simulation.
    if (!_isDownloading) {
      return;
    }

    // Shift to the downloading phase.
    _downloadStatus = DownloadStatus.downloading;
    notifyListeners();

    const downloadProgressStops = [0.0, 0.15, 0.45, 0.8, 1.0];
    for (final stop in downloadProgressStops) {
      // Wait a second to simulate varying download speeds.
      await Future<void>.delayed(const Duration(seconds: 1));

      // If the user chose to cancel the download, stop the simulation.
      if (!_isDownloading) {
        return;
      }

      // Update the download progress.
      _progress = stop;
      notifyListeners();
    }

    // Wait a second to simulate a final delay.
    await Future<void>.delayed(const Duration(seconds: 1));

    // If the user chose to cancel the download, stop the simulation.
    if (!_isDownloading) {
      return;
    }

    // Shift to the downloaded state, completing the simulation.
    _downloadStatus = DownloadStatus.downloaded;
    _isDownloading = false;
    notifyListeners();
  }
}

@immutable
class DownloadButton extends StatelessWidget {
  const DownloadButton({
    super.key,
    required this.status,
    this.downloadProgress = 0.0,
    required this.onDownload,
    required this.onCancel,
    required this.onOpen,
    this.transitionDuration = const Duration(milliseconds: 500),
  });

  final DownloadStatus status;
  final double downloadProgress;
  final VoidCallback onDownload;
  final VoidCallback onCancel;
  final VoidCallback onOpen;
  final Duration transitionDuration;

  bool get _isDownloading => status == DownloadStatus.downloading;

  bool get _isFetching => status == DownloadStatus.fetchingDownload;

  bool get _isDownloaded => status == DownloadStatus.downloaded;

  void _onPressed() {
    switch (status) {
      case DownloadStatus.notDownloaded:
        onDownload();
      case DownloadStatus.fetchingDownload:
        // do nothing.
        break;
      case DownloadStatus.downloading:
        onCancel();
      case DownloadStatus.downloaded:
        onOpen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onPressed,
      child: Stack(
        children: [
          ButtonShapeWidget(
            transitionDuration: transitionDuration,
            isDownloaded: _isDownloaded,
            isDownloading: _isDownloading,
            isFetching: _isFetching,
          ),
          Positioned.fill(
            child: AnimatedOpacity(
              duration: transitionDuration,
              opacity: _isDownloading || _isFetching ? 1.0 : 0.0,
              curve: Curves.ease,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ProgressIndicatorWidget(
                    downloadProgress: downloadProgress,
                    isDownloading: _isDownloading,
                    isFetching: _isFetching,
                  ),
                  if (_isDownloading)
                    const Icon(
                      Icons.stop,
                      size: 14,
                      color: CupertinoColors.activeBlue,
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

@immutable
class ButtonShapeWidget extends StatelessWidget {
  const ButtonShapeWidget({
    super.key,
    required this.isDownloading,
    required this.isDownloaded,
    required this.isFetching,
    required this.transitionDuration,
  });

  final bool isDownloading;
  final bool isDownloaded;
  final bool isFetching;
  final Duration transitionDuration;

  @override
  Widget build(BuildContext context) {
    final ShapeDecoration shape;
    if (isDownloading || isFetching) {
      shape = const ShapeDecoration(
        shape: CircleBorder(),
        color: Colors.transparent,
      );
    } else {
      shape = const ShapeDecoration(
        shape: StadiumBorder(),
        color: CupertinoColors.lightBackgroundGray,
      );
    }

    return AnimatedContainer(
      duration: transitionDuration,
      curve: Curves.ease,
      width: double.infinity,
      decoration: shape,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: AnimatedOpacity(
          duration: transitionDuration,
          opacity: isDownloading || isFetching ? 0.0 : 1.0,
          curve: Curves.ease,
          child: Text(
            isDownloaded ? 'OPEN' : 'GET',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: CupertinoColors.activeBlue,
            ),
          ),
        ),
      ),
    );
  }
}

@immutable
class ProgressIndicatorWidget extends StatelessWidget {
  const ProgressIndicatorWidget({
    super.key,
    required this.downloadProgress,
    required this.isDownloading,
    required this.isFetching,
  });

  final double downloadProgress;
  final bool isDownloading;
  final bool isFetching;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: downloadProgress),
        duration: const Duration(milliseconds: 200),
        builder: (context, progress, child) {
          return CircularProgressIndicator(
            backgroundColor: isDownloading
                ? CupertinoColors.lightBackgroundGray
                : Colors.transparent,
            valueColor: AlwaysStoppedAnimation(
              isFetching
                  ? CupertinoColors.lightBackgroundGray
                  : CupertinoColors.activeBlue,
            ),
            strokeWidth: 2,
            value: isFetching ? null : progress,
          );
        },
      ),
    );
  }
}

sealed class HistoryItem {}

class DateHeaderItem extends HistoryItem {
  final String date;
  DateHeaderItem(this.date);
}

class OrderHistoryItem extends HistoryItem {
  final BaseOrder order;
  OrderHistoryItem(this.order);
}

abstract class BaseOrder {
  final String title;
  final String time;
  final String price;
  final String statusText;
  final String iconPath;
  final Color statusColor;

  BaseOrder({
    required this.title,
    required this.time,
    required this.price,
    required this.statusText,
    required this.iconPath,
    required this.statusColor,
  });

  factory BaseOrder.fromJson(Map<String, dynamic> json) {
    final type = json['type'];
    final time = json['time'];
    final price = json['price'];
    final isCancelled = json['isCancelled'] ?? false;

    return switch (type) {
      'cargo' => CargoOrder(time: time, price: price),
      'delivery' => DeliveryOrder(
        time: time,
        price: price,
        isCancelled: isCancelled,
      ),
      'market' => MarketOrder(
        time: time,
        price: price,
        isCancelled: isCancelled,
      ),
      _ => throw Exception("Noma'lum tur: $type"),
    };
  }
}

class CargoOrder extends BaseOrder {
  CargoOrder({required String time, required String price})
    : super(
        title: "Cargo",
        time: time,
        price: price,
        statusText: "Завершено",
        statusColor: Colors.green,
        iconPath:
            'https://cdn-icons-png.flaticon.com/512/754/754848.png', // Test uchun rasm
      );
}

class DeliveryOrder extends BaseOrder {
  final bool isCancelled;
  DeliveryOrder({
    required String time,
    required String price,
    this.isCancelled = false,
  }) : super(
         title: "Доставка",
         time: time,
         price: price,
         statusText: isCancelled ? "Отменен" : "Завершено",
         statusColor: isCancelled ? Colors.red : Colors.green,
         iconPath: 'https://cdn-icons-png.flaticon.com/512/709/709790.png',
       );
}

class MarketOrder extends BaseOrder {
  final bool isCancelled;
  MarketOrder({
    required String time,
    required String price,
    this.isCancelled = false,
  }) : super(
         title: "Market",
         time: time,
         price: price,
         statusText: isCancelled ? "Отменен" : "Завершено",
         statusColor: isCancelled ? Colors.red : Colors.green,
         iconPath: 'https://cdn-icons-png.flaticon.com/512/3082/3082006.png',
       );
}

List<HistoryItem> groupOrders(List<Map<String, dynamic>> rawData) {
  List<HistoryItem> items = [];
  String? lastDate;

  for (var data in rawData) {
    String date = data['date'];

    if (date != lastDate) {
      items.add(DateHeaderItem(date));
      lastDate = date;
    }
    items.add(OrderHistoryItem(BaseOrder.fromJson(data)));
  }
  return items;
}

// -------------------------------------------------------------------------
// 3. UI QISMI - Asosiy Ekran
// -------------------------------------------------------------------------

final List<Map<String, dynamic>> rawApiData = [
  // Bugungi buyurtmalar
  {'date': 'Сегодня', 'type': 'cargo', 'time': '09:15', 'price': '25 000'},
  {'date': 'Сегодня', 'type': 'market', 'time': '10:30', 'price': '45 000'},
  {'date': 'Сегодня', 'type': 'delivery', 'time': '12:02', 'price': '16 000'},
  {
    'date': 'Сегодня',
    'type': 'cargo',
    'time': '14:45',
    'price': '30 000',
    'isCancelled': true,
  },

  // 1-noyabr buyurtmalari
  {'date': '1 ноября', 'type': 'delivery', 'time': '08:20', 'price': '12 000'},
  {'date': '1 ноября', 'type': 'market', 'time': '11:10', 'price': '85 000'},
  {
    'date': '1 ноября',
    'type': 'delivery',
    'time': '13:50',
    'price': '16 000',
    'isCancelled': true,
  },
  {'date': '1 ноября', 'type': 'cargo', 'time': '17:05', 'price': '50 000'},

  // 25-oktabr buyurtmalari (qo'shimcha sana)
  {'date': '25 октября', 'type': 'market', 'time': '09:00', 'price': '110 000'},
  {
    'date': '25 октября',
    'type': 'delivery',
    'time': '15:30',
    'price': '20 000',
  },
];

class OrderHistoryPage extends StatelessWidget {
  const OrderHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<HistoryItem> items = groupOrders(rawApiData);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Tarix", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return switch (item) {
            DateHeaderItem(date: final date) => _buildHeader(date),
            OrderHistoryItem(order: final order) => _buildOrderTile(order),
          };
        },
      ),
    );
  }

  Widget _buildHeader(String sana) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        sana,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Color(0xFF2D3142),
        ),
      ),
    );
  }

  Widget _buildOrderTile(BaseOrder buyurtma) {
    return Column(
      children: [
        ListTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Image.network(buyurtma.iconPath, width: 30, height: 30),
          ),
          title: Text(
            "${buyurtma.title}, ${buyurtma.time}",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Заказ ${buyurtma.statusText.toLowerCase()}",
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 8),
              const Row(
                children: [
                  Icon(Icons.refresh, size: 16, color: Colors.orange),
                  Text(
                    " Повторить",
                    style: TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "${buyurtma.price} сум",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              Text(
                buyurtma.statusText,
                style: TextStyle(color: buyurtma.statusColor, fontSize: 13),
              ),
            ],
          ),
        ),
        const Divider(indent: 75, endIndent: 16, height: 1),
      ],
    );
  }
}
