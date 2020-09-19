import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

// Oxygen 200 400 900 narrow
// RedHat 400 900 wide

const kTopColor = Color(0xFFF3B3C4E);
const kActiveColor = Color(0xFF29D857);
const kLighterBlue = Color(0xFF9D9DA5);
const kHr = Color(0xFF4E505F);
const kLightestBlue = Color(0xFF474958);

//COLOR PALETTE from dribble
const kBlack = Color(0xFF0F111A);
const kDarkGrey = Color(0xFF31354B);
const kDarkBlue = Color(0xFF1D28DD);
const kGrey = Color(0xFF46495E);
const kLightGrey = Color(0xFFDEE0EB);
const kLightBlue = Color(0xFF567FB5);

const kWhite70Text = TextStyle(
//  color: Color(0xFF9798F1),
  color: Colors.white70,
);

const kGreetingText = TextStyle(
  fontWeight: FontWeight.w400,
  fontSize: 22.0,
  letterSpacing: 1,
);

const kHeadingText = TextStyle(
  fontSize: 15.0,
  color: kLighterBlue,
  letterSpacing: 1.5,
);

const kHeadingTextWhite = TextStyle(
  fontSize: 15.0,
  letterSpacing: 1.5,
);

// eg CITY NAME
const kHeadingTextLarge = TextStyle(
  fontSize: 20.0,
  color: kLighterBlue,
  letterSpacing: 1.5,
);

const kToggleButtonText = TextStyle(
  fontSize: 14.0,
  color: kLighterBlue,
);

// eg UNDER CITY NAME IN LOCATION SCREEN
const kSubHeadingText = TextStyle(
  fontSize: 13.0,
  color: kLighterBlue,
  letterSpacing: 1.3,
);

// NUMBERS IN LARGE SPINNER
const kMainData = TextStyle(
  fontFamily: 'Oxygen',
  fontWeight: FontWeight.w400,
  fontSize: 45.0,
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
  fontSize: 30.0,
  shadows: <Shadow>[
    Shadow(
      offset: Offset(0.0, 0.0),
      blurRadius: 20.0,
      color: kBlack,
    ),
  ],
);

// BOTTOM TEXT IN LARGE SPINNER
const kBottomLabelStyle = TextStyle(
  fontSize: 13.0,
  color: Colors.white70,
);

// TEXT UNDER SPINNERS
const kSpinnerLabels = TextStyle(
  fontSize: 15.0,
  color: kLighterBlue,
);

// TEXT UNDER BOTTOM ICONS
const kBottomIconText = TextStyle(
  color: Colors.white30,
  fontSize: 12.0,
);

const kRevoltText = TextStyle(
  fontSize: 18.0,
  height: 1.5,
);

const kUpdateLegendText = TextStyle(
  color: Colors.black,
  fontWeight: FontWeight.bold,
  fontSize: 14.0,
);

const kInputDecoration = InputDecoration(
  hintText: 'Enter City Name',
  hintStyle: TextStyle(color: Colors.grey),
  filled: true,
  fillColor: Colors.white,
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(10.0),
    ),
    borderSide: BorderSide.none,
  ),
  icon: Icon(
    MaterialCommunityIcons.city_variant_outline,
    color: Colors.white,
  ),
);
