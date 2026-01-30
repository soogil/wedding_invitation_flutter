import 'package:flutter/material.dart';
import 'package:wedding/feature/home/domain/entities/guest_book.dart';
import 'package:wedding/feature/home/presentation/wedding/wedding_contract.dart';

/// Wedding View Delegate (Presenter 명령 → UI 동작 번역)
class WeddingDelegate implements WeddingView {
  final BuildContext context;
  final ValueNotifier<bool> isLoadingState;
  final ValueNotifier<bool> isSubmittingState;
  final ValueNotifier<List<GuestBook>> guestBooksState;
  final TextEditingController nameController;
  final TextEditingController messageController;
  final VoidCallback? onDismissDialog;

  WeddingDelegate({
    required this.context,
    required this.isLoadingState,
    required this.isSubmittingState,
    required this.guestBooksState,
    required this.nameController,
    required this.messageController,
    this.onDismissDialog,
  });

  @override
  void showLoading() => isLoadingState.value = true;

  @override
  void hideLoading() => isLoadingState.value = false;

  @override
  void showGuestBooks(List<GuestBook> guestBooks) {
    guestBooksState.value = guestBooks;
  }

  @override
  void showSubmitLoading() => isSubmittingState.value = true;

  @override
  void hideSubmitLoading() => isSubmittingState.value = false;

  @override
  void showSuccessMessage(String message) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void showErrorMessage(String message) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void dismissDialog() {
    if (!context.mounted) return;
    onDismissDialog?.call();
  }

  @override
  void clearInputFields() {
    nameController.clear();
    messageController.clear();
  }
}
