import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:insult_me/services/device_info_service.dart';

class RatingBarWidget extends StatefulWidget {
  final int quoteId;
  const RatingBarWidget({super.key, required this.quoteId});

  @override
  State<RatingBarWidget> createState() => _RatingBarWidgetState();
}

class _RatingBarWidgetState extends State<RatingBarWidget> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: DeviceInfoService.getDeviceId(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // or some other widget while waiting
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.data == null) {
          return RatingBar.builder(
            itemSize: 20,
            ignoreGestures: true,
            initialRating: 5,
            minRating: 0,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) => const Icon(
              Icons.favorite_border_outlined,
              color: Colors.black26,
            ),
            onRatingUpdate: (rating) {},
          );
        }

        return Container();
      },
    );
  }
}
