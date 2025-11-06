import 'package:flutter/material.dart';

class FullscreenCarousel extends StatefulWidget {
  const FullscreenCarousel({super.key, required this.images});
  final List<String> images;

  @override
  State<FullscreenCarousel> createState() => _FullscreenCarouselState();
}

class _FullscreenCarouselState extends State<FullscreenCarousel> {
  final PageController _controller = PageController();
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Full-screen, swipe-only pages
          PageView.builder(
            controller: _controller,
            physics: const PageScrollPhysics(), // swipe only; no auto
            itemCount: widget.images.length,
            onPageChanged: (i) => setState(() => _index = i),
            itemBuilder: (context, i) {
              final src = widget.images[i];

              final imageWidget = InteractiveViewer(
                panEnabled: true,
                child: Image.asset(
                  'assets/images/meds/' + src,
                  fit: BoxFit.contain,
                  width: double.infinity,
                  height: double.infinity,
                ),
              );
              return SizedBox.expand(child: imageWidget);
            },
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 24,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${_index + 1} / ${widget.images.length}',
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
            ),
          ),

          // Close/back affordance (optional)
          Positioned(
            top: 40,
            left: 16,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () => Navigator.of(context).maybePop(),
              tooltip: 'Close',
            ),
          ),
        ],
      ),
    );
  }
}
