import 'package:flutter/material.dart';
import 'styles.dart';

var lightTheme = new ThemeData(
    brightness: Brightness.light
);

var darkTheme = new ThemeData(
    brightness: Brightness.dark
);

getSliverAppBarBackground(isDarkmode) {
  if(isDarkmode) {
    return Color(0xff303030);
  } else {
    return Colors.white10;
  }
}


getLabelBackgroundColor(count) {
  var result = BACKGROUND_TAG_LOW;
  if(count <= 10 && count > 0) {
    result = BACKGROUND_TAG_MEDIUM;
  } else if (count > 10) {
    result = BACKGROUND_TAG_HIGH;
  }
  return result;
}

getSliverAppBarTitleStyle(isDarkmode) {
  if(isDarkmode) {
    return STYLE_APP_TITLE_DARK_THEME;
  } else {
    return STYLE_APP_TITLE_LIGHT_THEME;
  }
}

getMenuIconColor(isDarkmode) {
  if(isDarkmode) {
    return Colors.white;
  } else {
    return COLOR_DARK;
  }
}

getStyleMeta(isDarkmode) {
  if (isDarkmode) {
    return STYLE_METADATA_DARK_THEME;
  } else {
    return STYLE_METADATA_LIGHT_THEME;
  }
}