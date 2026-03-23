import 'package:dev_buddy/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:dev_buddy/features/auth/presentation/cubit/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/locale_provider.dart';
import '../../../../shared/widgets/app_background.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController(); // مسكر للتعديل
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // تحميل بيانات اليوزر الحالي في الـ TextFields
    final user = context.read<AuthCubit>().getCurrentUser();
    if (user != null) {
      _nameController.text = user.name;
      _emailController.text = user.email;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _saveChanges(bool isArabic) async {
    if (_nameController.text.trim().isEmpty) return;

    setState(() => _isLoading = true);
    final authCubit = context.read<AuthCubit>();
    final currentUser = authCubit.getCurrentUser();

    if (currentUser != null) {
      // تحديث الاسم فقط
      final updatedUser = currentUser.copyWith(name: _nameController.text.trim());
      await authCubit.updateUserProfile(updatedUser);
    }

    setState(() => _isLoading = false);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isArabic ? 'تم حفظ التغييرات بنجاح ✅' : 'Changes saved successfully ✅', style: GoogleFonts.cairo()),
          backgroundColor: Colors.greenAccent[700],
        ),
      );
      Navigator.pop(context); // الرجوع لشاشة البروفايل
    }
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = Provider.of<LocaleProvider>(context).locale.languageCode == 'ar';

    return Scaffold(
      // Transparent so AppBackground's radial gradient renders fully.
      backgroundColor: Colors.transparent,
      body: AppBackground(
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context, isArabic),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(24),
                  physics: const BouncingScrollPhysics(),
                  children: [
                    // Real initials avatar — matches the ProfileScreen avatar style.
                    BlocBuilder<AuthCubit, dynamic>(
                      builder: (context, state) {
                        final name = (state is Authenticated) ? state.user.name : '';
                        final initials = name.isNotEmpty ? name[0].toUpperCase() : '?';
                        return Center(
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const LinearGradient(
                                colors: [Colors.indigoAccent, Colors.purpleAccent],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.indigoAccent.withValues(alpha: 0.4),
                                  blurRadius: 20,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                initials,
                                style: GoogleFonts.cairo(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 32),
                    
                    _buildTextField(isArabic ? 'الاسم' : 'Name', Icons.person_outline, _nameController, isArabic),
                    const SizedBox(height: 16),
                    
                    // الإيميل مقفول للتعديل (Read-only)
                    Opacity(
                      opacity: 0.6,
                      child: _buildTextField(isArabic ? 'البريد الإلكتروني (لا يمكن تعديله)' : 'Email (Cannot be changed)', Icons.email_outlined, _emailController, isArabic, readOnly: true),
                    ),
                    const SizedBox(height: 48),

                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : () => _saveChanges(isArabic),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigoAccent,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : Text(
                                isArabic ? 'حفظ التغييرات' : 'Save Changes',
                                style: GoogleFonts.cairo(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isArabic) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          IconButton(
            icon: Icon(isArabic ? Icons.arrow_forward : Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 8),
          Text(
            isArabic ? 'تعديل الملف الشخصي' : 'Edit Profile',
            style: GoogleFonts.cairo(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, IconData icon, TextEditingController controller, bool isArabic, {bool readOnly = false}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        style: GoogleFonts.cairo(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.cairo(color: Colors.white54),
          prefixIcon: Icon(icon, color: Colors.indigoAccent),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }
}