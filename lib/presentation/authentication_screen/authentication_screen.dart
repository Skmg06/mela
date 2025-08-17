import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/auth_input_field.dart';
import './widgets/auth_tab_bar.dart';
import './widgets/business_verification_form.dart';
import './widgets/social_login_button.dart';
import 'widgets/auth_input_field.dart';
import 'widgets/auth_tab_bar.dart';
import 'widgets/business_verification_form.dart';
import 'widgets/social_login_button.dart';

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({super.key});

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen>
    with TickerProviderStateMixin {
  int _selectedTabIndex = 0;
  bool _isLoading = false;
  bool _isSellerSignup = false;
  bool _showBusinessForm = false;

  // Controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  // Validation states
  bool _emailError = false;
  bool _passwordError = false;
  bool _confirmPasswordError = false;
  bool _nameError = false;

  String? _emailErrorText;
  String? _passwordErrorText;
  String? _confirmPasswordErrorText;
  String? _nameErrorText;

  // Business data
  Map<String, String> _businessData = {};

  // Animation controllers
  late AnimationController _logoAnimationController;
  late AnimationController _formAnimationController;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _formSlideAnimation;

  // Mock credentials for testing
  final Map<String, Map<String, String>> _mockCredentials = {
    'buyer': {
      'email': 'buyer@mela.com',
      'password': 'buyer123',
      'name': 'John Buyer',
    },
    'seller': {
      'email': 'seller@mela.com',
      'password': 'seller123',
      'name': 'Jane Seller',
    },
    'admin': {
      'email': 'admin@mela.com',
      'password': 'admin123',
      'name': 'Admin User',
    },
  };

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _setupControllerListeners();
  }

  void _initializeAnimations() {
    _logoAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _formAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _logoScaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: Curves.elasticOut,
    ));

    _formSlideAnimation = Tween<double>(
      begin: 50.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _formAnimationController,
      curve: Curves.easeOutCubic,
    ));

    // Start animations
    _logoAnimationController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      _formAnimationController.forward();
    });
  }

  void _setupControllerListeners() {
    _emailController.addListener(_validateFields);
    _passwordController.addListener(_validateFields);
    _confirmPasswordController.addListener(_validateFields);
    _nameController.addListener(_validateFields);
  }

  void _validateFields() {
    setState(() {
      // Email validation
      _emailError = _emailController.text.isNotEmpty &&
          !_isValidEmail(_emailController.text);
      _emailErrorText =
          _emailError ? 'Please enter a valid email address' : null;

      // Password validation
      _passwordError = _passwordController.text.isNotEmpty &&
          _passwordController.text.length < 6;
      _passwordErrorText =
          _passwordError ? 'Password must be at least 6 characters' : null;

      // Confirm password validation (only for signup)
      if (_selectedTabIndex == 1) {
        _confirmPasswordError = _confirmPasswordController.text.isNotEmpty &&
            _confirmPasswordController.text != _passwordController.text;
        _confirmPasswordErrorText =
            _confirmPasswordError ? 'Passwords do not match' : null;

        // Name validation
        _nameError =
            _nameController.text.isNotEmpty && _nameController.text.length < 2;
        _nameErrorText =
            _nameError ? 'Name must be at least 2 characters' : null;
      }
    });
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  bool _isFormValid() {
    if (_selectedTabIndex == 0) {
      // Login validation
      return _emailController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty &&
          _isValidEmail(_emailController.text) &&
          !_emailError &&
          !_passwordError;
    } else {
      // Signup validation
      return _nameController.text.isNotEmpty &&
          _emailController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty &&
          _confirmPasswordController.text.isNotEmpty &&
          _isValidEmail(_emailController.text) &&
          _passwordController.text == _confirmPasswordController.text &&
          _nameController.text.length >= 2 &&
          _passwordController.text.length >= 6 &&
          !_emailError &&
          !_passwordError &&
          !_confirmPasswordError &&
          !_nameError;
    }
  }

  void _onTabChanged(int index) {
    setState(() {
      _selectedTabIndex = index;
      _clearErrors();
      _showBusinessForm = false;
      _isSellerSignup = false;
    });

    // Provide haptic feedback
    HapticFeedback.selectionClick();
  }

  void _clearErrors() {
    setState(() {
      _emailError = false;
      _passwordError = false;
      _confirmPasswordError = false;
      _nameError = false;
      _emailErrorText = null;
      _passwordErrorText = null;
      _confirmPasswordErrorText = null;
      _nameErrorText = null;
    });
  }

  Future<void> _handleAuthentication() async {
    if (!_isFormValid()) return;

    setState(() {
      _isLoading = true;
    });

    // Provide haptic feedback
    HapticFeedback.lightImpact();

    try {
      await Future.delayed(
          const Duration(milliseconds: 1500)); // Simulate API call

      if (_selectedTabIndex == 0) {
        // Login logic
        await _handleLogin();
      } else {
        // Signup logic
        await _handleSignup();
      }
    } catch (e) {
      _showErrorMessage('Authentication failed. Please try again.');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    // Check mock credentials
    bool isValidCredential = false;
    String userType = '';

    for (final entry in _mockCredentials.entries) {
      if (entry.value['email'] == email &&
          entry.value['password'] == password) {
        isValidCredential = true;
        userType = entry.key;
        break;
      }
    }

    if (isValidCredential) {
      // Success haptic feedback
      HapticFeedback.selectionClick();

      // Navigate based on user type
      if (userType == 'seller' || userType == 'admin') {
        Navigator.pushNamedAndRemoveUntil(
            context, '/seller-dashboard', (route) => false);
      } else {
        Navigator.pushNamedAndRemoveUntil(
            context, '/video-feed-home', (route) => false);
      }
    } else {
      _showErrorMessage(
          'Invalid credentials. Please use:\nBuyer: buyer@mela.com / buyer123\nSeller: seller@mela.com / seller123');
    }
  }

  Future<void> _handleSignup() async {
    if (_isSellerSignup && (!_showBusinessForm || _businessData.isEmpty)) {
      setState(() {
        _showBusinessForm = true;
      });
      return;
    }

    // Success haptic feedback
    HapticFeedback.selectionClick();

    // Navigate to appropriate screen
    if (_isSellerSignup) {
      Navigator.pushNamedAndRemoveUntil(
          context, '/seller-dashboard', (route) => false);
    } else {
      Navigator.pushNamedAndRemoveUntil(
          context, '/video-feed-home', (route) => false);
    }
  }

  Future<void> _handleSocialLogin(String provider) async {
    setState(() {
      _isLoading = true;
    });

    // Provide haptic feedback
    HapticFeedback.lightImpact();

    try {
      await Future.delayed(
          const Duration(milliseconds: 1000)); // Simulate social login

      // Success haptic feedback
      HapticFeedback.selectionClick();

      Navigator.pushNamedAndRemoveUntil(
          context, '/video-feed-home', (route) => false);
    } catch (e) {
      _showErrorMessage('$provider login failed. Please try again.');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _handleForgotPassword() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Password'),
        content: const Text(
            'Password reset link will be sent to your email address.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSuccessMessage('Password reset link sent to your email!');
            },
            child: const Text('Send Link'),
          ),
        ],
      ),
    );
  }

  void _handleGuestBrowsing() {
    HapticFeedback.lightImpact();
    Navigator.pushNamedAndRemoveUntil(
        context, '/video-feed-home', (route) => false);
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(4.w),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.successLight,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(4.w),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _onBusinessDataChanged(Map<String, String> data) {
    setState(() {
      _businessData = data;
    });
  }

  @override
  void dispose() {
    _logoAnimationController.dispose();
    _formAnimationController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 4.h),
                    _buildLogo(),
                    SizedBox(height: 4.h),
                    _buildTabBar(),
                    SizedBox(height: 2.h),
                    _buildForm(),
                    if (_selectedTabIndex == 1) ...[
                      SizedBox(height: 2.h),
                      _buildUserTypeSelector(),
                    ],
                    if (_showBusinessForm) ...[
                      SizedBox(height: 2.h),
                      BusinessVerificationForm(
                        isVisible: _showBusinessForm,
                        onBusinessDataChanged: _onBusinessDataChanged,
                      ),
                    ],
                    SizedBox(height: 3.h),
                    _buildActionButton(),
                    if (_selectedTabIndex == 0) ...[
                      SizedBox(height: 2.h),
                      _buildForgotPassword(),
                    ],
                    SizedBox(height: 3.h),
                    _buildDivider(),
                    SizedBox(height: 2.h),
                    _buildSocialLogins(),
                    SizedBox(height: 3.h),
                    _buildGuestOption(),
                    SizedBox(height: 2.h),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AnimatedBuilder(
      animation: _logoScaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _logoScaleAnimation.value,
          child: Column(
            children: [
              Container(
                width: 20.w,
                height: 20.w,
                decoration: BoxDecoration(
                  color: colorScheme.onSurface,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.shadow.withValues(alpha: 0.1),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    'M',
                    style: theme.textTheme.headlineLarge?.copyWith(
                      color: colorScheme.surface,
                      fontWeight: FontWeight.bold,
                      fontSize: 24.sp,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                'Mela',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              SizedBox(height: 0.5.h),
              Text(
                'Shop through stories',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTabBar() {
    return AnimatedBuilder(
      animation: _formSlideAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _formSlideAnimation.value),
          child: AuthTabBar(
            selectedIndex: _selectedTabIndex,
            onTabChanged: _onTabChanged,
          ),
        );
      },
    );
  }

  Widget _buildForm() {
    return AnimatedBuilder(
      animation: _formSlideAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _formSlideAnimation.value),
          child: Column(
            children: [
              if (_selectedTabIndex == 1) ...[
                AuthInputField(
                  label: 'Full Name',
                  hintText: 'Enter your full name',
                  iconName: 'person',
                  controller: _nameController,
                  showError: _nameError,
                  errorText: _nameErrorText,
                ),
                SizedBox(height: 2.h),
              ],
              AuthInputField(
                label: 'Email',
                hintText: 'Enter your email address',
                iconName: 'email',
                keyboardType: TextInputType.emailAddress,
                controller: _emailController,
                showError: _emailError,
                errorText: _emailErrorText,
              ),
              SizedBox(height: 2.h),
              AuthInputField(
                label: 'Password',
                hintText: 'Enter your password',
                iconName: 'lock',
                isPassword: true,
                controller: _passwordController,
                showError: _passwordError,
                errorText: _passwordErrorText,
              ),
              if (_selectedTabIndex == 1) ...[
                SizedBox(height: 2.h),
                AuthInputField(
                  label: 'Confirm Password',
                  hintText: 'Confirm your password',
                  iconName: 'lock',
                  isPassword: true,
                  controller: _confirmPasswordController,
                  showError: _confirmPasswordError,
                  errorText: _confirmPasswordErrorText,
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildUserTypeSelector() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Account Type',
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: colorScheme.onSurface.withValues(alpha: 0.8),
            ),
          ),
          SizedBox(height: 1.h),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _isSellerSignup = false;
                      _showBusinessForm = false;
                    });
                  },
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 3.w),
                    decoration: BoxDecoration(
                      color: !_isSellerSignup
                          ? colorScheme.onSurface.withValues(alpha: 0.1)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: !_isSellerSignup
                            ? colorScheme.onSurface
                            : colorScheme.outline.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'shopping_bag',
                          size: 20,
                          color: colorScheme.onSurface,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          'Buyer',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: !_isSellerSignup
                                ? FontWeight.w600
                                : FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _isSellerSignup = true;
                    });
                  },
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 3.w),
                    decoration: BoxDecoration(
                      color: _isSellerSignup
                          ? colorScheme.onSurface.withValues(alpha: 0.1)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: _isSellerSignup
                            ? colorScheme.onSurface
                            : colorScheme.outline.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'store',
                          size: 20,
                          color: colorScheme.onSurface,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          'Seller',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: _isSellerSignup
                                ? FontWeight.w600
                                : FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      height: 6.h,
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      child: ElevatedButton(
        onPressed: _isFormValid() && !_isLoading ? _handleAuthentication : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.onSurface,
          foregroundColor: colorScheme.surface,
          disabledBackgroundColor: colorScheme.onSurface.withValues(alpha: 0.3),
          elevation: _isFormValid() ? 2 : 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: _isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor:
                      AlwaysStoppedAnimation<Color>(colorScheme.surface),
                ),
              )
            : Text(
                _selectedTabIndex == 0 ? 'Login' : 'Create Account',
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.surface,
                ),
              ),
      ),
    );
  }

  Widget _buildForgotPassword() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: _handleForgotPassword,
        child: Text(
          'Forgot Password?',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurface.withValues(alpha: 0.7),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        Expanded(
          child: Divider(
            color: colorScheme.outline.withValues(alpha: 0.3),
            thickness: 1,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Text(
            'Or continue with',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: colorScheme.outline.withValues(alpha: 0.3),
            thickness: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildSocialLogins() {
    return Column(
      children: [
        SocialLoginButton(
          iconName: 'g_translate',
          label: 'Continue with Google',
          onPressed: () => _handleSocialLogin('Google'),
        ),
        SocialLoginButton(
          iconName: 'apple',
          label: 'Continue with Apple',
          onPressed: () => _handleSocialLogin('Apple'),
        ),
        SocialLoginButton(
          iconName: 'facebook',
          label: 'Continue with Facebook',
          onPressed: () => _handleSocialLogin('Facebook'),
        ),
      ],
    );
  }

  Widget _buildGuestOption() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      height: 6.h,
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      child: OutlinedButton(
        onPressed: _handleGuestBrowsing,
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: colorScheme.onSurface.withValues(alpha: 0.3),
            width: 1,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'visibility',
              size: 20,
              color: colorScheme.onSurface.withValues(alpha: 0.7),
            ),
            SizedBox(width: 2.w),
            Text(
              'Browse as Guest',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}