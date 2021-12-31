import 'package:bonfire/bonfire.dart';

class ActionAnim {
  static const String CrowbarRight = "CrowbarRight";
  static const String CrowbarLeft = "CrowbarLeft";
  static const String CrowbarTop = "CrowbarTop";
  static const String CrowbarBottom = "CrowbarBottom";
  //
  static const String HammerRight = "HammerRight";
  static const String HammerLeft = "HammerLeft";
  static const String HammerTop = "HammerTop";
  static const String HammerBottom = "HammerBottom";
  //
  static const String SawRight = "SawRight";
  static const String SawLeft = "SawLeft";
  static const String SawTop = "SawTop";
  static const String SawBottom = "SawBottom";
  //
  static const String KeysRight = "KeysRight";
  static const String KeysLeft = "KeysLeft";
  static const String KeysTop = "KeysTop";
  static const String KeysBottom = "KeysBottom";
  //
  static const String DrillRight = "DrillRight";
  static const String DrillLeft = "DrillLeft";
  static const String DrillTop = "DrillTop";
  static const String DrillBottom = "DrillBottom";
  //
  static const String OscillatorRight = "OscillatorRight";
  static const String OscillatorLeft = "OscillatorLeft";
  static const String OscillatorTop = "OscillatorTop";
  static const String OscillatorBottom = "OscillatorBottom";
  //
  static const String PliersRight = "PliersRight";
  static const String PliersLeft = "PliersLeft";
  static const String PliersTop = "PliersTop";
  static const String PliersBottom = "PliersBottom";
  //
  static const String ScannerRight = "ScannerRight";
  static const String ScannerLeft = "ScannerLeft";
  static const String ScannerTop = "ScannerTop";
  static const String ScannerBottom = "ScannerBottom";
  //
  static const String ComputerRight = "ComputerRight";
  static const String ComputerLeft = "ComputerLeft";
  static const String ComputerTop = "ComputerTop";
  static const String ComputerBottom = "ComputerBottom";
  //
  static const String SmallBombRight = "SmallBombRight";
  static const String SmallBombLeft = "SmallBombLeft";
  static const String SmallBombTop = "SmallBombTop";
  static const String SmallBombBottom = "SmallBombBottom";
  //
  static const String LargeBombRight = "LargeBombRight";
  static const String LargeBombLeft = "LargeBombLeft";
  static const String LargeBombTop = "LargeBombTop";
  static const String LargeBombBottom = "LargeBombBottom";
  //
  static const String KnifeRight = "KnifeRight";
  static const String KnifeLeft = "KnifeLeft";
  static const String KnifeTop = "KnifeTop";
  static const String KnifeBottom = "KnifeBottom";
  //
  static const String LootRight = "LootRight";
  static const String LootLeft = "LootLeft";
  static const String LootTop = "LootTop";
  static const String LootBottom = "LootBottom";

  static Map<String, SpriteAnimation> anims(SpriteSheet spriteSheet) => {
        LootRight: spriteSheet.createAnimation(
          row: 21,
          stepTime: 0.1,
          from: 1,
          to: 4,
        ),
        LootLeft:
            spriteSheet.createAnimation(row: 20, stepTime: 0.1, from: 1, to: 4),
        LootTop:
            spriteSheet.createAnimation(row: 20, stepTime: 0.1, from: 5, to: 8),
        LootBottom:
            spriteSheet.createAnimation(row: 21, stepTime: 0.1, from: 5, to: 8),
        /////////////////////////
        CrowbarRight:
            spriteSheet.createAnimation(row: 17, stepTime: 0.1, from: 1, to: 4),
        CrowbarLeft:
            spriteSheet.createAnimation(row: 16, stepTime: 0.1, from: 1, to: 4),
        CrowbarTop:
            spriteSheet.createAnimation(row: 16, stepTime: 0.1, from: 5, to: 8),
        CrowbarBottom:
            spriteSheet.createAnimation(row: 17, stepTime: 0.1, from: 5, to: 8),
        /////////////////////////
        HammerRight:
            spriteSheet.createAnimation(row: 5, stepTime: 0.1, from: 0, to: 4),
        HammerLeft:
            spriteSheet.createAnimation(row: 4, stepTime: 0.1, from: 0, to: 4),
        HammerTop:
            spriteSheet.createAnimation(row: 4, stepTime: 0.1, from: 4, to: 8),
        HammerBottom:
            spriteSheet.createAnimation(row: 5, stepTime: 0.1, from: 4, to: 8),
        /////////////////////////
        KeysRight:
            spriteSheet.createAnimation(row: 7, stepTime: 0.1, from: 0, to: 4),
        KeysLeft:
            spriteSheet.createAnimation(row: 6, stepTime: 0.1, from: 0, to: 4),
        KeysTop:
            spriteSheet.createAnimation(row: 6, stepTime: 0.1, from: 4, to: 8),
        KeysBottom:
            spriteSheet.createAnimation(row: 7, stepTime: 0.1, from: 4, to: 8),
        /////////////////////////
        KnifeRight:
            spriteSheet.createAnimation(row: 9, stepTime: 0.1, from: 0, to: 4),
        KnifeLeft:
            spriteSheet.createAnimation(row: 8, stepTime: 0.1, from: 0, to: 4),
        KnifeTop:
            spriteSheet.createAnimation(row: 8, stepTime: 0.1, from: 4, to: 8),
        KnifeBottom:
            spriteSheet.createAnimation(row: 9, stepTime: 0.1, from: 4, to: 8),
        /////////////////////////
        DrillRight:
            spriteSheet.createAnimation(row: 11, stepTime: 0.1, from: 0, to: 4),
        DrillLeft:
            spriteSheet.createAnimation(row: 10, stepTime: 0.1, from: 0, to: 4),
        DrillTop:
            spriteSheet.createAnimation(row: 10, stepTime: 0.1, from: 4, to: 8),
        DrillBottom:
            spriteSheet.createAnimation(row: 11, stepTime: 0.1, from: 4, to: 8),
        /////////////////////////
        OscillatorRight:
            spriteSheet.createAnimation(row: 13, stepTime: 0.1, from: 0, to: 4),
        OscillatorLeft:
            spriteSheet.createAnimation(row: 12, stepTime: 0.1, from: 0, to: 4),
        OscillatorTop:
            spriteSheet.createAnimation(row: 12, stepTime: 0.1, from: 4, to: 8),
        OscillatorBottom:
            spriteSheet.createAnimation(row: 13, stepTime: 0.1, from: 4, to: 8),
        /////////////////////////
        ComputerRight:
            spriteSheet.createAnimation(row: 15, stepTime: 0.1, from: 0, to: 4),
        ComputerLeft:
            spriteSheet.createAnimation(row: 14, stepTime: 0.1, from: 0, to: 4),
        ComputerTop:
            spriteSheet.createAnimation(row: 14, stepTime: 0.1, from: 4, to: 8),
        ComputerBottom:
            spriteSheet.createAnimation(row: 15, stepTime: 0.1, from: 4, to: 8),
        /////////////////////////
        SawRight:
            spriteSheet.createAnimation(row: 19, stepTime: 0.1, from: 0, to: 4),
        SawLeft:
            spriteSheet.createAnimation(row: 18, stepTime: 0.1, from: 0, to: 4),
        SawTop:
            spriteSheet.createAnimation(row: 18, stepTime: 0.1, from: 4, to: 8),
        SawBottom:
            spriteSheet.createAnimation(row: 19, stepTime: 0.1, from: 4, to: 8),
        /////////////////////////
        PliersRight:
            spriteSheet.createAnimation(row: 23, stepTime: 0.1, from: 0, to: 4),
        PliersLeft:
            spriteSheet.createAnimation(row: 22, stepTime: 0.1, from: 0, to: 4),
        PliersTop:
            spriteSheet.createAnimation(row: 22, stepTime: 0.1, from: 4, to: 8),
        PliersBottom:
            spriteSheet.createAnimation(row: 23, stepTime: 0.1, from: 4, to: 8),
      };
}
