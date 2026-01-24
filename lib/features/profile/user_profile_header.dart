import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class UserProfileHeader extends StatelessWidget {
  final VoidCallback onTap;

  const UserProfileHeader({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.primaryBlue,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 40, 16, 20),
          child: Row(
            children: [
              // =====================
              // USER AVATAR
              // =====================
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.person,
                  size: 36,
                  color: AppColors.primaryBlue,
                ),
              ),

              const SizedBox(width: 14),

              // =====================
              // USER DETAILS
              // =====================
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Abhinav Sharma",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "DL User • India",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),

              // =====================
              // ARROW
              // =====================
              const Icon(
                Icons.arrow_forward_ios,
                color: Colors.white70,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
