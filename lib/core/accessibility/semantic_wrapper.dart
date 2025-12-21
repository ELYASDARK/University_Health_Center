import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import '../constants/accessibility_constants.dart';

/// A reusable wrapper widget that adds semantic information
/// to child widgets for better screen reader support
///
/// Usage:
/// ```dart
/// SemanticWrapper(
///   label: 'Book appointment',
///   hint: 'Double tap to book an appointment',
///   isButton: true,
///   child: ElevatedButton(...),
/// )
/// ```
class SemanticWrapper extends StatelessWidget {
  final Widget child;
  final String? label;
  final String? hint;
  final String? value;
  final bool isButton;
  final bool isLink;
  final bool isHeader;
  final bool isImage;
  final bool isTextField;
  final bool enabled;
  final bool selected;
  final bool checked;
  final bool toggled;
  final bool excludeSemantics;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final String? increasedValue;
  final String? decreasedValue;
  final VoidCallback? onIncrease;
  final VoidCallback? onDecrease;

  const SemanticWrapper({
    super.key,
    required this.child,
    this.label,
    this.hint,
    this.value,
    this.isButton = false,
    this.isLink = false,
    this.isHeader = false,
    this.isImage = false,
    this.isTextField = false,
    this.enabled = true,
    this.selected = false,
    this.checked = false,
    this.toggled = false,
    this.excludeSemantics = false,
    this.onTap,
    this.onLongPress,
    this.increasedValue,
    this.decreasedValue,
    this.onIncrease,
    this.onDecrease,
  });

  @override
  Widget build(BuildContext context) {
    if (excludeSemantics) {
      return ExcludeSemantics(child: child);
    }

    return Semantics(
      label: label,
      hint: hint,
      value: value,
      button: isButton,
      link: isLink,
      header: isHeader,
      image: isImage,
      textField: isTextField,
      enabled: enabled,
      selected: selected,
      checked: checked,
      toggled: toggled,
      onTap: onTap,
      onLongPress: onLongPress,
      increasedValue: increasedValue,
      decreasedValue: decreasedValue,
      onIncrease: onIncrease,
      onDecrease: onDecrease,
      child: child,
    );
  }
}

/// A specialized semantic wrapper for navigation items
class SemanticNavigationItem extends StatelessWidget {
  final Widget child;
  final String destination;
  final bool isSelected;

  const SemanticNavigationItem({
    super.key,
    required this.child,
    required this.destination,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return SemanticWrapper(
      label: destination,
      hint: 'Navigate to $destination',
      isButton: true,
      selected: isSelected,
      child: child,
    );
  }
}

/// A specialized semantic wrapper for status indicators
class SemanticStatus extends StatelessWidget {
  final Widget child;
  final String status;
  final String? description;

  const SemanticStatus({
    super.key,
    required this.child,
    required this.status,
    this.description,
  });

  @override
  Widget build(BuildContext context) {
    final statusLabel =
        AccessibilityConstants.statusSemantics[status] ?? status;

    return SemanticWrapper(label: statusLabel, hint: description, child: child);
  }
}

/// A specialized semantic wrapper for list items
class SemanticListItem extends StatelessWidget {
  final Widget child;
  final String label;
  final int index;
  final int totalItems;
  final VoidCallback? onTap;

  const SemanticListItem({
    super.key,
    required this.child,
    required this.label,
    required this.index,
    required this.totalItems,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SemanticWrapper(
      label: '$label, item ${index + 1} of $totalItems',
      isButton: onTap != null,
      onTap: onTap,
      child: child,
    );
  }
}

/// A specialized semantic wrapper for rating stars
class SemanticRating extends StatelessWidget {
  final Widget child;
  final double rating;
  final double maxRating;
  final bool isInteractive;

  const SemanticRating({
    super.key,
    required this.child,
    required this.rating,
    this.maxRating = 5.0,
    this.isInteractive = false,
  });

  @override
  Widget build(BuildContext context) {
    final ratingText = '$rating out of $maxRating stars';

    return SemanticWrapper(
      label: ratingText,
      value: rating.toString(),
      hint: isInteractive ? 'Double tap to change rating' : null,
      child: child,
    );
  }
}

/// A specialized semantic wrapper for loading indicators
class SemanticLoading extends StatelessWidget {
  final Widget child;
  final String? message;

  const SemanticLoading({super.key, required this.child, this.message});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: message ?? AccessibilityConstants.loadingAnnouncement,
      child: child,
    );
  }
}

/// A specialized semantic wrapper for error messages
class SemanticError extends StatelessWidget {
  final Widget child;
  final String errorMessage;

  const SemanticError({
    super.key,
    required this.child,
    required this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '${AccessibilityConstants.errorAnnouncement}: $errorMessage',
      liveRegion: true,
      child: child,
    );
  }
}

/// A specialized semantic wrapper for success messages
class SemanticSuccess extends StatelessWidget {
  final Widget child;
  final String successMessage;

  const SemanticSuccess({
    super.key,
    required this.child,
    required this.successMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '${AccessibilityConstants.successAnnouncement}: $successMessage',
      liveRegion: true,
      child: child,
    );
  }
}

/// A specialized semantic wrapper for announcements
/// Use this to announce dynamic changes to screen readers
class SemanticAnnouncement extends StatelessWidget {
  final String announcement;
  final Widget child;

  const SemanticAnnouncement({
    super.key,
    required this.announcement,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(label: announcement, liveRegion: true, child: child);
  }
}

/// A helper function to announce a message to screen readers
void announceToScreenReader(BuildContext context, String message) {
  // Use SemanticsService to announce directly
  SemanticsService.announce(message, TextDirection.ltr);
}

/// A specialized semantic wrapper for images with alt text
class SemanticImage extends StatelessWidget {
  final Widget child;
  final String altText;
  final bool isDecorative;

  const SemanticImage({
    super.key,
    required this.child,
    required this.altText,
    this.isDecorative = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isDecorative) {
      return ExcludeSemantics(child: child);
    }

    return SemanticWrapper(label: altText, isImage: true, child: child);
  }
}
