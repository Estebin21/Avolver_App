import 'package:flutter/material.dart';
import 'brand_header.dart';

class BrandScaffold extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;
  final Widget? bottom;
  final bool showBack;
  final bool showLogo;

  const BrandScaffold({
    super.key,
    required this.title,
    required this.subtitle,
    required this.child,
    this.bottom,
    this.showBack = true,
    this.showLogo = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: showBack
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              )
            : null,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 6, 16, 16),
          child: Column(
            children: [
              BrandHeader(title: title, subtitle: subtitle, showLogo: showLogo),
              const SizedBox(height: 14),
              Expanded(child: child),
              if (bottom != null) ...[
                const SizedBox(height: 12),
                bottom!,
              ]
            ],
          ),
        ),
      ),
    );
  }
}
