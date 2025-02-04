import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFormField extends StatefulWidget {
  final String labelText;
  final TextEditingController controller;
  final bool obscureText;
  final String? Function(String?)? validator;
  final Color borderColor;
  final Color focusedBorderColor;
  final Color labelColor;
  final FontWeight labelFontWeight;
  final bool showVisibilityToggle;
  final TextInputType? keyboardType;
  final bool readOnly;
  final bool enabled; // Added parameter
  final VoidCallback? onTap;

  const CustomTextFormField({
    Key? key,
    required this.labelText,
    required this.controller,
    this.obscureText = false,
    this.validator,
    this.borderColor = Colors.teal,
    this.focusedBorderColor = Colors.teal,
    this.labelColor = Colors.grey,
    this.labelFontWeight = FontWeight.bold,
    this.showVisibilityToggle = false,
    this.keyboardType,
    this.readOnly = false,
    this.enabled = true, // Default to true
    this.onTap,
  }) : super(key: key);

  @override
  _CustomTextFormFieldState createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  IconData _getPrefixIcon() {
    switch (widget.labelText.toLowerCase()) {
      case 'name':
        return Icons.person;
      case 'password':
        return Icons.lock;
      case 'email':
        return Icons.email;
      case 'mobile number':
      case 'phone number':
        return Icons.phone;
      case 'country':
        return Icons.public;
      case 'donation amount':
        return Icons.currency_rupee;
      case 'additional details':
        return Icons.message;
      case 'gender':
        return Icons.wc;
      case 'address':
        return Icons.home;
      case 'age':
        return Icons.cake;
      case 'event title':
        return Icons.subtitles_outlined;
      case 'date and time':
        return Icons.calendar_month;
      case 'event description':
        return Icons.subtitles_outlined;
      case 'location':
        return Icons.location_pin;
      case 'description':
        return Icons.subtitles_outlined;
      case 'event organizer':
        return Icons.location_city_sharp;
      case 'username':
        return Icons.person;
      case 'contact':
        return Icons.phonelink_ring_sharp;
      case 'old password':
        return Icons.password_sharp;
      case 'new password':
        return Icons.password_sharp;
      case 'confirm password':
        return Icons.phonelink_lock;
      case 'event image':
        return Icons.image;
      case 'amount':
        return Icons.money_outlined;
      case 'advance amount':
        return Icons.currency_rupee_sharp;
      case 'date of birth':
        return Icons.calendar_month;
      case 'additional details (optional)':
        return Icons.message;
      default:
        return Icons.text_fields;
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _obscureText,
      keyboardType: widget.keyboardType,
      decoration: InputDecoration(
        labelText: widget.labelText,
        prefixIcon: Icon(_getPrefixIcon(), color: Colors.brown[800]),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: widget.borderColor,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: widget.borderColor,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: widget.focusedBorderColor,
          ),
        ),
        labelStyle: TextStyle(
          color: widget.labelColor,
          fontWeight: widget.labelFontWeight,
        ),
        suffixIcon: widget.showVisibilityToggle && widget.obscureText
            ? IconButton(
                icon: const Icon(
                  Icons.visibility,
                  color: Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              )
            : widget.showVisibilityToggle && !widget.obscureText
                ? IconButton(
                    icon: const Icon(
                      Icons.visibility_off,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  )
                : null,
      ),
      style: const TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
      validator: widget.validator,
      inputFormatters: [
        if (widget.keyboardType == TextInputType.number)
          FilteringTextInputFormatter.digitsOnly,
        if (widget.labelText.toLowerCase() == 'mobile number')
          LengthLimitingTextInputFormatter(10),
      ],
      readOnly: widget.readOnly,
      enabled: widget.enabled,
      // Controls whether the field is enabled or disabled
      onTap: widget.enabled
          ? widget.onTap
          : null, // Prevents interaction if disabled
    );
  }
}
