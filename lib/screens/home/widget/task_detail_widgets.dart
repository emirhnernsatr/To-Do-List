import 'package:flutter/material.dart';
import 'package:to_do_uygulamsi/core/constants/app_strings.dart';
import 'package:to_do_uygulamsi/core/theme/app_theme.dart';
import 'package:to_do_uygulamsi/screens/home/model/task_model.dart';

Widget taskTitleTextField({
  required TextEditingController controller,
  required bool isDark,
}) => TextField(
  controller: controller,
  style: TextStyle(
    color: isDark ? AppColors.white : AppColors.black,
    fontSize: 16,
  ),
  autofocus: true,
  decoration: InputDecoration(
    labelText: 'Görev Başlığı',
    labelStyle: TextStyle(
      color: isDark ? AppColors.white : AppColors.primaryColor,
      fontSize: 16,
      fontWeight: FontWeight.bold,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: AppColors.primaryColor, width: 2),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: AppColors.primaryColor, width: 2),
    ),
    filled: true,
    fillColor: isDark ? AppColors.charlestonGreen : AppColors.white,
  ),
);

Widget infoCard({required TaskModel task, required bool isDark}) {
  // ignore: unnecessary_nullable_for_final_variable_declarations
  final DateTime? time = task.timestamp;
  final String formattedDate = time != null
      ? '${time.day.toString().padLeft(2, '0')}/${time.month.toString().padLeft(2, '0')}/${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}'
      : 'Tarih Bilgisi Yok';
  return Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
      side: const BorderSide(color: AppColors.primaryColor, width: 2),
    ),
    color: isDark ? AppColors.charlestonGreen : AppColors.white,
    elevation: 3,
    child: Padding(
      padding: AppPadding.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppText.creationDate,
          Text(
            formattedDate,
            style: TextStyle(
              fontSize: 14,
              color: isDark ? AppColors.white : AppColors.black,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget statusCard({required bool isDark, required TaskModel task}) {
  final bool isCompleted = task.isCompleted;
  return Card(
    color: isDark ? AppColors.charlestonGreen : AppColors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
      side: const BorderSide(color: AppColors.primaryColor, width: 2),
    ),
    elevation: 3,
    child: Padding(
      padding: AppPadding.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Görev Durumu',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            isCompleted ? 'Tamamlandı' : 'Tamamlanmadı',
            style: TextStyle(
              fontSize: 16,
              color: isCompleted
                  ? AppColors.green
                  : (isDark ? AppColors.redAccent : AppColors.redAccent),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget timeTextfield({
  required BuildContext context,
  required bool isDark,
  required TimeOfDay? selectedTime,
  required VoidCallback onTap,
}) {
  return TextFormField(
    readOnly: true,
    onTap: onTap,
    controller: TextEditingController(
      text: selectedTime != null ? selectedTime.format(context) : '',
    ),
    decoration: InputDecoration(
      labelText: 'Saat',
      labelStyle: TextStyle(
        color: isDark ? AppColors.white : AppColors.primaryColor,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
      prefixIcon: const Icon(Icons.access_time, color: AppColors.primaryColor),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primaryColor, width: 2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primaryColor, width: 2),
      ),
      fillColor: isDark ? AppColors.charlestonGreen : AppColors.white,
      filled: true,
    ),
  );
}

Widget dateTextfield({
  required bool isDark,
  required DateTime? selectedDate,
  required VoidCallback onTap,
}) {
  return TextField(
    readOnly: true,
    onTap: onTap,
    controller: TextEditingController(
      text: selectedDate != null
          ? '${selectedDate.day.toString().padLeft(2, '0')}/${selectedDate.month.toString().padLeft(2, '0')}/${selectedDate.year}'
          : '',
    ),
    decoration: InputDecoration(
      labelText: 'Tarih',
      labelStyle: TextStyle(
        color: isDark ? AppColors.white : AppColors.primaryColor,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
      prefixIcon: const Icon(
        Icons.calendar_today,
        color: AppColors.primaryColor,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primaryColor, width: 2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primaryColor, width: 2),
      ),
      filled: true,
      fillColor: isDark ? AppColors.charlestonGreen : AppColors.white,
    ),
  );
}

Widget noteTextfield({
  required TextEditingController controller,
  required bool isDark,
  required dynamic maxLine,
}) {
  return TextFormField(
    controller: controller,
    maxLines: maxLine,
    decoration: InputDecoration(
      labelText: 'Notlar',
      labelStyle: TextStyle(
        color: isDark ? AppColors.white : AppColors.primaryColor,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primaryColor, width: 2),
      ),
      alignLabelWithHint: true,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primaryColor, width: 2),
      ),
      filled: true,
      fillColor: isDark ? AppColors.charlestonGreen : AppColors.white,
    ),
  );
}

Widget saveElevatedButtton({required VoidCallback onPressed}) {
  return ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primaryColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
    ),
    child: AppText.saveText,
  );
}
