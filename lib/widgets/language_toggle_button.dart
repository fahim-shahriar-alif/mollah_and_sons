import 'package:flutter/material.dart';
import '../services/language_service.dart';
import '../l10n/app_localizations.dart';

class LanguageToggleButton extends StatelessWidget {
  final bool showText;
  final Color? iconColor;
  final Color? backgroundColor;

  const LanguageToggleButton({
    super.key,
    this.showText = true,
    this.iconColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final languageService = LanguageService();
    final localizations = AppLocalizations.of(context);

    return ListenableBuilder(
      listenable: languageService,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            color: backgroundColor ?? Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () async {
              await languageService.toggleLanguage();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      languageService.isBengali 
                        ? 'ভাষা বাংলায় পরিবর্তিত হয়েছে'
                        : 'Language changed to English',
                    ),
                    duration: const Duration(seconds: 2),
                    backgroundColor: const Color(0xFF2E7D32),
                  ),
                );
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.language,
                    color: iconColor ?? Colors.white,
                    size: 20,
                  ),
                  if (showText) ...[
                    const SizedBox(width: 8),
                    Text(
                      languageService.isBengali ? 'EN' : 'বাং',
                      style: TextStyle(
                        color: iconColor ?? Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
