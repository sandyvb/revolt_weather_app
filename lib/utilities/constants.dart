import 'package:flutter/material.dart';

// FONTS USED
// Oxygen 200 400 900 narrow // NUMBERS
// RedHat 400 900 wide // TEXT

// COLOR PALETTE
const kSwitchColor = Color(0xFF29D857);
const kLighterBlue = Colors.white70;
// const kLighterBlue = Color(0xFF9D9DA5);
const kHr = Color(0xFF4E505F);
const kHeaderBlue = Color(0xFF3B3C4E);

//COLOR PALETTE from dribble
const kBlack = Color(0xFF0F111A);

// GRADIENT BACKGROUND DECORATION FOR ENTIRE SCREEN
const kGradientBackgroundDecoration = BoxDecoration(
  gradient: LinearGradient(
    colors: [
      Color(0xFF37394B),
      Color(0xFF292B38),
      Color(0xFF222536),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    tileMode: TileMode.clamp,
  ),
);

// BLUE GRADIENT VERTICAL
const kBlueGradientVertical = LinearGradient(
  colors: [
    Color(0x7F709EFE),
    Color(0x7F5C47E0),
    Color(0xFF4120A9),
  ],
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  tileMode: TileMode.clamp,
);

// FOOTER GRADIENT VERTICAL
// BLUE GRADIENT VERTICAL
const kBlueGradientFooter = LinearGradient(
  colors: [
    Color(0x7F709EFE),
    Color(0x7F5C47E0),
  ],
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  tileMode: TileMode.clamp,
);

// HEADER BLUE/PURPLE DIAGONAL GRADIENT
const kBlueGradientDiagonal = LinearGradient(
  colors: [
    Color(0xFF709EFE),
    Color(0xFF5C47E0),
    Color(0xFF4120A9),
  ],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  tileMode: TileMode.clamp,
);

// HEADER BLUE/PURPLE HORIZONTAL GRADIENT
const kBlueGradientHorizontal = LinearGradient(
  colors: [
    Color(0xFF709EFE),
    Color(0xFF5C47E0),
    Color(0xFF4120A9),
  ],
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
  tileMode: TileMode.clamp,
);

// HEADER SECTION RED GRADIENT
const kRedGradientDiagonal = LinearGradient(
  colors: [
    Color(0xFFC42E2C),
    Color(0xFF7D001F),
  ],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  tileMode: TileMode.clamp,
);

// BOX SHADOW DOWN (0x7F OPACITY)
const kBoxShadowDown = [
  BoxShadow(
    color: Color(0x7F0F111A),
    spreadRadius: 5,
    blurRadius: 7,
    offset: Offset(0, 3),
  )
];

// BOX SHADOW UP (0x7F OPACITY)
const kBoxShadowUp = [
  BoxShadow(
    color: Color(0x7F0F111A),
    spreadRadius: 5,
    blurRadius: 7,
    offset: Offset(0, -3),
  )
];

// BOX SHADOW DIAGONAL DOWN (0x7F OPACITY)
const kBoxShadowDD = [
  BoxShadow(
    color: Color(0x7F0F111A),
    spreadRadius: 5,
    blurRadius: 7,
    offset: Offset(5, 5),
  )
];

// GREETING IN HEADINGS
const kGreetingText = TextStyle(
  fontWeight: FontWeight.w400,
  letterSpacing: 1,
  color: Colors.white,
);

// DATE TIMES IN HEADINGS
const kHeadingText = TextStyle(
  fontSize: 13.0,
  color: Colors.white70,
  letterSpacing: 1.5,
);

// eg CITY NAME
const kHeadingTextLarge = TextStyle(
  fontSize: 20.0,
  color: kLighterBlue,
  letterSpacing: 1.5,
);

// TIME & PRECIP HEADINGS IN MINUTELY
const kTimePrecipHeadings = TextStyle(
  fontSize: 12.0,
  color: Colors.white70,
  letterSpacing: 1.5,
);

// Forecast page data text
const kDataText = TextStyle(
  fontFamily: 'Oxygen',
  letterSpacing: 0.7,
  color: kLighterBlue,
  height: 1.3,
);

// FORECAST TOGGLE BUTTONS
const kLighterBlueText = TextStyle(
  color: kLighterBlue,
);

// eg UNDER CITY NAME IN LOCATION SCREEN
const kSubHeadingText = TextStyle(
  fontSize: 13.0,
  color: kLighterBlue,
  letterSpacing: 1.3,
);

// NUMBERS IN LARGE SPINNER
const kMainDataLargeSpinner = TextStyle(
  fontFamily: 'Oxygen',
  fontWeight: FontWeight.w400,
  fontSize: 45.0,
  letterSpacing: 1.5,
  shadows: <Shadow>[
    Shadow(
      offset: Offset(0.0, 0.0),
      blurRadius: 20.0,
      color: Colors.white70,
    ),
  ],
);

// NUMBERS IN SMALL SPINNERS
const kData = TextStyle(
  fontFamily: 'Oxygen',
  fontWeight: FontWeight.w400,
  fontSize: 20.0,
  shadows: <Shadow>[
    Shadow(
      offset: Offset(0.0, 0.0),
      blurRadius: 20.0,
      color: kBlack,
    ),
  ],
);

// NUMBERS IN CURRENT FORECAST SPINNERS
const kDataCurrent = TextStyle(
  fontFamily: 'Oxygen',
  fontWeight: FontWeight.w400,
  fontSize: 25.0,
  shadows: <Shadow>[
    Shadow(
      offset: Offset(0.0, 0.0),
      blurRadius: 20.0,
      color: kBlack,
    ),
  ],
);

// NUMBERS IN SMALL CURRENT FORECAST SPINNERS
const kDataCurrentSmall = TextStyle(
  fontFamily: 'Oxygen',
  fontWeight: FontWeight.w400,
  fontSize: 20.0,
  shadows: <Shadow>[
    Shadow(
      offset: Offset(0.0, 0.0),
      blurRadius: 20.0,
      color: kBlack,
    ),
  ],
);

// CHANGE FAMILY TO OXYGEN
const kOxygen = TextStyle(
  fontFamily: 'Oxygen',
  color: kLighterBlue,
);

// CHANGE FAMILY TO OXYGEN
const kOxygenWhite = TextStyle(
  fontFamily: 'Oxygen',
  fontSize: 15.0,
  letterSpacing: 0.5,
  color: Colors.white,
);

// BOTTOM TEXT IN LARGE SPINNER
const kBottomLabelStyle = TextStyle(
  fontSize: 13.0,
  color: kLighterBlue,
);

const kBottomLabelStyleSm = TextStyle(
  fontSize: 11.0,
  color: kLighterBlue,
);

// TEXT UNDER SPINNERS
const kSpinnerLabels = TextStyle(
  fontSize: 15.0,
  color: kLighterBlue,
);

const kRevoltText = TextStyle(
  fontSize: 18.0,
  height: 1.5,
);

// MAP LEGEND COMPONENT TEXT STYLE
const kUpdateLegendText = TextStyle(
  fontFamily: 'Oxygen',
  color: Colors.black,
  fontWeight: FontWeight.w900,
  fontSize: 14.0,
);

Container kExpansionContainer({dynamic child}) {
  return Container(
    margin: EdgeInsets.symmetric(vertical: 15.0),
    padding: EdgeInsets.all(15.0),
    decoration: BoxDecoration(
      boxShadow: kBoxShadowDD,
      borderRadius: BorderRadius.circular(15.0),
      gradient: LinearGradient(
        colors: [
          Color(0xFF37394B),
          Color(0xFF292B38),
          Color(0xFF222536),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        tileMode: TileMode.clamp,
      ),
    ),
    child: child,
  );
}
