// lib/theme/app_theme.dart
// ── Design Tokens ─────────────────────────────────────────────────────────────
import 'package:flutter/material.dart';

const kPrimary = Color(0xFFFF6B35);
const kPrimaryLight = Color(0xFFFFF3EE);
const kPrimaryDark = Color(0xFFCC4F1F);
const kBg = Color(0xFFF5F4F2);
const kSurface = Colors.white;
const kText = Color(0xFF111111);
const kTextSub = Color(0xFF666666);
const kTextHint = Color(0xFFBBBBBB);
const kBorder = Color(0xFFEDEBE8);
const kGreen = Color(0xFF16A34A);
const kBlue = Color(0xFF2563EB);
const kAmber = Color(0xFFD97706);
const kRed = Color(0xFFDC2626);
const kPurple = Color(0xFF7C3AED);

// ── Text Styles ───────────────────────────────────────────────────────────────
TextStyle get displayXL => const TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w900,
    color: kText,
    letterSpacing: -1.2,
    height: 1.0);

TextStyle get h1 => const TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w800,
    color: kText,
    letterSpacing: -0.8,
    height: 1.1);

TextStyle get h2 => const TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w700,
    color: kText,
    letterSpacing: -0.4);

TextStyle get h3 => const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: kText,
    letterSpacing: -0.2);

TextStyle get bodyStyle => const TextStyle(
    fontSize: 13, fontWeight: FontWeight.w400, color: kTextSub, height: 1.5);

TextStyle get caption => const TextStyle(
    fontSize: 11, fontWeight: FontWeight.w600, color: kTextHint, letterSpacing: 0.3);

TextStyle get label => const TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w800,
    color: kTextHint,
    letterSpacing: 1.2);