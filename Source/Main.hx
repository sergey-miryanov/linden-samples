package;


import flash.display.Sprite;
import flash.display.Bitmap;
import flash.filters.ColorMatrixFilter;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.ui.Keyboard;
import flash.text.TextField;
import flash.Lib;

import openfl.Assets;

#if android
import ru.zzzzzzerg.linden.Flurry;
import ru.zzzzzzerg.linden.Localytics;

import ru.zzzzzzerg.linden.GoogleIAP;
import ru.zzzzzzerg.linden.GooglePlay;
import ru.zzzzzzerg.linden.play.Achievement;
import ru.zzzzzzerg.linden.play.AppState;
#end

class Main extends Sprite {

  public static var GRAYSCALE_FILTER = new ColorMatrixFilter (
      [1 - (1 / 3.0 * 2), 1 / 3.0, 1 / 3.0, 0, 0,
       1 / 3.0, 1 - (1 / 3.0 * 2), 1 / 3.0, 0, 0,
       1 / 3.0, 1 / 3.0, 1 - (1 / 3.0 * 2), 0, 0,
       0, 0, 0, 1, 0]);

  private static var FLURRY_KEY = "FLURRY_KEY";
  private static var LOCALYTICS_KEY = "LOCALYTICS_KEY";
  private static var IAP_KEY = "GOOGLE_IN_APP_BILLING_KEY";

  public static var LEADERBOARD_ID = "CgkIrdyYssYUEAIQAg";
  public static var ACHIEVEMENT_ID = "CgkIrdyYssYUEAIQAA";
  public static var ACHIEVEMENT_ID_INC = "CgkIrdyYssYUEAIQAQ";

  public static var STATE_KEY = 1;

  public static var flurry : Flurry;
  public static var localytics : Localytics;
  public var googlePlay : GooglePlay;
  public var googleIAP : GoogleIAP;

  public var testProduct : PurchaseInfo = null;
  public var managedProduct : PurchaseInfo = null;

  public var signInGames : ColorBtn;
  public var signOutGames : ColorBtn;
  public var signInCloudSave : ColorBtn;
  public var signOutCloudSave : ColorBtn;

  public var unlockAchievement : ColorBtn;
  public var unlockIncrementalAchievement : ColorBtn;
  public var showAchievements : ColorBtn;

  public var updateScore : ColorBtn;
  public var showLeaderboard : ColorBtn;

  public var updateState : ColorBtn;
  public var loadState : ColorBtn;
  public var deleteState : ColorBtn;
  public var state : TextArea;

  public var purchaseTest : ColorBtn;
  public var purchaseManaged : ColorBtn;
  public var consumeTest : ColorBtn;
  public var consumeManaged : ColorBtn;
  public var purchaseLog : TextArea;

  var gamesIcon : Sprite;
  var achievementIcon : Sprite;
  var scoreIcon : Sprite;
  var billingIcon : Sprite;

  public function new () {

    super ();

    stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);


    testFlurry(FLURRY_KEY);
    testLocalytics(LOCALYTICS_KEY);

    signInGames = new ColorBtn(0x7EB5D6, "SignIn\nGames", true);
    signOutGames = new ColorBtn(0xFF8000, "SignOut\nGames", false);

    signInCloudSave = new ColorBtn(0x7EB5D6, "SignIn\nCloudSave", true);
    signOutCloudSave = new ColorBtn(0xFF8000, "SignOut\nCloudSave", false);


    unlockAchievement = new ColorBtn(0x51C5D4, "Unlock", false);
    unlockIncrementalAchievement = new ColorBtn(0x51C5D4, "Unlock\nIncremental", false);
    showAchievements = new ColorBtn(0x51C5D4, "Show\nAchievements", false);

    updateScore = new ColorBtn(0xEAA83A, "Update\nscore", false);
    showLeaderboard = new ColorBtn(0xEAA83A, "Show\nLeaderboard", false);

    updateState = new ColorBtn(0xDAB4C9, "Update\nstate", false);
    loadState = new ColorBtn(0xDAB4C9, "Load\nstate", false);
    deleteState = new ColorBtn(0xDAB4C9, "Delete\nstate", false);
    state = new TextArea("", 354, 64);

    purchaseTest = new ColorBtn(0xCDDB9D, "Purchase\ntest", true);
    purchaseManaged = new ColorBtn(0xCDDB9D, "Purchase\nmanaged", true);
    consumeTest = new ColorBtn(0xCDDB9D, "Consume\ntest", true);
    consumeManaged = new ColorBtn(0xCDDB9D, "Consume\nmanaged", true);

    purchaseLog = new TextArea("", 354, 64);

    gamesIcon = new Sprite();
    achievementIcon = new Sprite();
    scoreIcon = new Sprite();
    billingIcon = new Sprite();

    gamesIcon.addChild(new Bitmap(Assets.getBitmapData("assets/ic_play_games_badge_green.png")));
    achievementIcon.addChild(new Bitmap(Assets.getBitmapData("assets/ic_play_games_badge_achievements_green.png")));
    scoreIcon.addChild(new Bitmap(Assets.getBitmapData("assets/ic_play_games_badge_leaderboards_green.png")));
    billingIcon.addChild(new Bitmap(Assets.getBitmapData("assets/googleplay-64.png")));

    signInGames.x = 20;
    signInGames.y = 20;
    signInGames.addEventListener(MouseEvent.CLICK, onSignInGamesClick);

    signOutGames.x = 260;
    signOutGames.y = 20;
    signOutGames.addEventListener(MouseEvent.CLICK, onSignOutGamesClick);

    gamesIcon.x = 380;
    gamesIcon.y = 20;

    unlockAchievement.x = 20;
    unlockAchievement.y = 100;
    unlockAchievement.addEventListener(MouseEvent.CLICK, onUnlockAchievementClick);

    unlockIncrementalAchievement.x = 140;
    unlockIncrementalAchievement.y = 100;
    unlockIncrementalAchievement.addEventListener(MouseEvent.CLICK, onUnlockIncrementalAchievementClick);

    showAchievements.x = 260;
    showAchievements.y = 100;
    showAchievements.addEventListener(MouseEvent.CLICK, onShowAchievementsClick);

    achievementIcon.x = 380;
    achievementIcon.y = 100;

    updateScore.x = 20;
    updateScore.y = 180;
    updateScore.addEventListener(MouseEvent.CLICK, onUpdateScoreClick);

    showLeaderboard.x = 140;
    showLeaderboard.y = 180;
    showLeaderboard.addEventListener(MouseEvent.CLICK, onShowLeaderboardClick);

    scoreIcon.x = 380;
    scoreIcon.y = 180;

    signInCloudSave.x = 20;
    signInCloudSave.y = 260;
    signInCloudSave.addEventListener(MouseEvent.CLICK, onSignInCloudSaveClick);

    signOutCloudSave.x = 260;
    signOutCloudSave.y = 260;
    signOutCloudSave.addEventListener(MouseEvent.CLICK, onSignOutCloudSaveClick);

    updateState.x = 20;
    updateState.y = 340;
    updateState.addEventListener(MouseEvent.CLICK, onUpdateStateClick);

    loadState.x = 140;
    loadState.y = 340;
    loadState.addEventListener(MouseEvent.CLICK, onLoadStateClick);

    deleteState.x = 260;
    deleteState.y = 340;
    deleteState.addEventListener(MouseEvent.CLICK, onDeleteStateClick);

    state.x = 20;
    state.y = 420;

    purchaseTest.x = 20;
    purchaseTest.y = 500;
    purchaseTest.addEventListener(MouseEvent.CLICK, onPurchaseTestClick);

    purchaseManaged.x = 140;
    purchaseManaged.y = 500;
    purchaseManaged.addEventListener(MouseEvent.CLICK, onPurchaseManagedClick);

    consumeTest.x = 20;
    consumeTest.y = 580;
    consumeTest.addEventListener(MouseEvent.CLICK, onConsumeTestClick);

    consumeManaged.x = 140;
    consumeManaged.y = 580;
    consumeManaged.addEventListener(MouseEvent.CLICK, onConsumeManagedClick);

    purchaseLog.x = 20;
    purchaseLog.y = 660;

    billingIcon.x = 380;
    billingIcon.y = 500;

    addChild(signInGames);
    addChild(signOutGames);
    addChild(signInCloudSave);
    addChild(signOutCloudSave);
    addChild(unlockAchievement);
    addChild(unlockIncrementalAchievement);
    addChild(showAchievements);
    addChild(updateScore);
    addChild(showLeaderboard);

    addChild(updateState);
    addChild(loadState);
    addChild(deleteState);
    addChild(state);

    addChild(gamesIcon);
    addChild(achievementIcon);
    addChild(scoreIcon);

    addChild(purchaseTest);
    addChild(purchaseManaged);
    addChild(consumeTest);
    addChild(consumeManaged);
    addChild(purchaseLog);

    addChild(billingIcon);

    googlePlay = new GooglePlay(new GooglePlayHandler(this));
    if(googlePlay.games.isSignedIn())
    {
      googlePlay.games.connect();
    }
    if(googlePlay.cloudSave.isSignedIn())
    {
      googlePlay.cloudSave.connect();
    }

    analytics("Start google iap service");
    googleIAP = new GoogleIAP(IAP_KEY, new GoogleIAPHandler(this));
  }

  function onKeyUp(event : KeyboardEvent)
  {
    switch(event.keyCode)
    {
      case Keyboard.ESCAPE:
        Lib.exit();
    }
  }

  function onSignInGamesClick(event : MouseEvent)
  {
    analytics("SignIn to GooglePlay.GamesClient");
    if(!googlePlay.games.isSignedIn())
    {
      if(!googlePlay.games.connect())
      {
        trace("Failed to sign in to GooglePlay.GamesClient");
      }
    }
    else
    {
      trace("Signed in");
    }
  }

  function onSignInCloudSaveClick(event : MouseEvent)
  {
    analytics("SignIn to GooglePlay.AppStateClient");
    if(!googlePlay.cloudSave.isSignedIn())
    {
      if(!googlePlay.cloudSave.connect())
      {
        trace("Failed to sign in to GooglePlay.AppStateClient");
      }
    }
    else
    {
      trace("Signed in");
    }
  }

  function onSignOutGamesClick(event : MouseEvent)
  {
    analytics("SignOut from GooglePlay.GamesClient");
    googlePlay.games.signOut();
  }

  function onSignOutCloudSaveClick(event : MouseEvent)
  {
    analytics("SignOut from GooglePlay.AppStateClient");
    googlePlay.cloudSave.signOut();
  }

  function onUnlockAchievementClick(event : MouseEvent)
  {
    analytics("Unlock achievement");
    googlePlay.games.unlockAchievement(ACHIEVEMENT_ID);
  }

  function onUnlockIncrementalAchievementClick(event : MouseEvent)
  {
    analytics("Unlock incremental achievement");
    googlePlay.games.incrementAchievement(ACHIEVEMENT_ID_INC, 1);
  }

  function onShowAchievementsClick(event : MouseEvent)
  {
    analytics("Show achievements");
    googlePlay.games.showAchievements();
  }

  function onUpdateScoreClick(event : MouseEvent)
  {
    analytics("Update score");
    googlePlay.games.submitScore(LEADERBOARD_ID, Std.random(1000));
  }

  function onShowLeaderboardClick(event : MouseEvent)
  {
    analytics("Show leaderboard");
    googlePlay.games.showLeaderboard(LEADERBOARD_ID);
  }

  function onUpdateStateClick(event : MouseEvent)
  {
    analytics("Update state");
    googlePlay.cloudSave.updateState(STATE_KEY, Std.string(Std.random(100)));
  }

  function onLoadStateClick(event : MouseEvent)
  {
    analytics("Load state");
    googlePlay.cloudSave.loadState(STATE_KEY);
  }

  function onDeleteStateClick(event : MouseEvent)
  {
    analytics("Delete state");
    googlePlay.cloudSave.deleteState(STATE_KEY);
  }

  function onPurchaseTestClick(event : MouseEvent)
  {
    analytics("Purchase test");
    var item = "android.test.purchased";
    if(!googleIAP.purchaseItem(item, new IAPPurchaseHandler(this)))
    {
      purchaseLog.text.text = 'Can not purchase\n$item';
    }
  }

  function onPurchaseManagedClick(event : MouseEvent)
  {
    analytics("Purchase managed");
    var item = "linden.managed_product";
    if(!googleIAP.purchaseItem(item, new IAPPurchaseHandler(this)))
    {
      purchaseLog.text.text = 'Can not purchase\n$item';
    }
  }

  function onConsumeTestClick(event : MouseEvent)
  {
    analytics("Consume test");
    if(testProduct == null)
    {
      purchaseLog.text.text = "Purchase test before";
    }
    else
    {
      if(!googleIAP.consumeItem(testProduct.productId, testProduct.purchaseToken))
      {
        purchaseLog.text.text = 'Can not consume\n${testProduct.productId}';
      }
      else
      {
        purchaseLog.text.text = 'Consume\n${testProduct.productId}';
      }
    }
  }

  function onConsumeManagedClick(event : MouseEvent)
  {
    analytics("Consume managed");
    if(managedProduct == null)
    {
      purchaseLog.text.text = "Purchase managed before";
    }
    else
    {
      if(!googleIAP.consumeItem(managedProduct.productId, managedProduct.purchaseToken))
      {
        purchaseLog.text.text = 'Can not consume\n${managedProduct.productId}';
      }
      else
      {
        purchaseLog.text.text = 'Consume\n${managedProduct.productId}';
      }
    }
  }

  public static function analytics(msg : String, ?params : Dynamic = null)
  {
    flurry.logEvent(msg, params);
    localytics.tagEvent(msg, params);
  }

  function testFlurry(key : String)
  {
    flurry = new Flurry();

    flurry.onStartSession(key);
    flurry.setLogEvents(true);
    flurry.setCaptureUncaughtExceptions(true);

    flurry.logEvent("TEST_LINDEN_FLURRY", null, false);
    flurry.logEvent("TEST_LINDEN_FLURRY_PARAMS", {'test' : 1, 'value' : 'TEST'}, false);

    flurry.logEvent("TEST_LINDEN_FLURRY_TIMED", true);
    flurry.endTimedEvent("TEST_LINDEN_FLURRY_TIMED");

    flurry.logEvent("TEST_LINDEN_FLURRY_PARAMS_TIMED", {'test' : 2, 'value' : 'TEST_TIMED'}, true);
    flurry.endTimedEvent("TEST_LINDEN_FLURRY_PARAMS_TIMED");

    flurry.logEvent("TEST_LINDEN_FLURRY_PARAMS_TIMED_2", {'test' : 3, 'value' : 'TEST_TIMED_2'}, true);
    flurry.endTimedEvent("TEST_LINDEN_FLURRY_PARAMS_TIMED_2", {'timed' : 'end'});
  }

  function testLocalytics(key : String)
  {
    localytics = new Localytics();

    localytics.start(key);
    localytics.tagEvent("TEST_LINDEN_LOCALYTICS");
    localytics.tagEvent("TEST_LINDEN_LOCALYTICS_PARAMS", {'test' : 'localytics'});
    localytics.tagScreen("TEST_LINDEN_LOCALYTICS_SCREEN");
  }
}

class ColorBtn extends Sprite
{
  public var enabled : Bool;
  public var label : TextField;
  public var color : Int;

  private static var WIDTH : Int = 64;
  private static var HEIGHT : Int = 64;

  public function new(color : Int, text : String, ?enabled : Bool = true)
  {
    super();

    this.enabled = enabled;
    this.color = color;
    this.label = new TextField();
    this.label.x = 10;
    this.label.y = HEIGHT / 3.0;
    this.label.text = text;
    this.label.selectable = false;

    addChild(this.label);
    setEnabled(enabled);
  }

  private function fill(clr : Int)
  {
    graphics.beginFill(clr);
    graphics.drawRect(0, 0, width, HEIGHT);
    graphics.endFill();
  }

  public function setEnabled(e : Bool)
  {
    this.enabled = e;
    if(this.enabled)
    {
      fill(color);
      this.useHandCursor = true;
      this.mouseEnabled = true;
    }
    else
    {
      fill(0xaaaaaa);
      this.useHandCursor = false;
      this.mouseEnabled = false;
    }
  }

}

class TextArea extends Sprite
{
  var _w : Int;
  var _h : Int;

  public var text : TextField;

  public function new(text : String, w : Int, h : Int)
  {
    super();
    this._w = w;
    this._h = h;

    this.text = new TextField();
    this.text.x = 2;
    this.text.y = 2;
    this.text.width = w;
    this.text.height = h;

    addChild(this.text);
    rect(0xff0000);
  }

  public function rect(color : Int)
  {
    graphics.beginFill(0xdddddd);
    graphics.drawRect(0, 0, _w, _h);
    graphics.endFill();
  }
}

class GooglePlayHandler extends ru.zzzzzzerg.linden.play.ConnectionHandler
{
  var _m : Main;

  public function new(m : Main)
  {
    super();
    _m = m;
  }

  override public function onConnectionEstablished(what : String)
  {
    if(what == "GAMES_CLIENT")
    {
      _m.signInGames.setEnabled(false);
      _m.signOutGames.setEnabled(true);
      _m.unlockAchievement.setEnabled(true);
      _m.unlockIncrementalAchievement.setEnabled(true);
      _m.showAchievements.setEnabled(true);
      _m.updateScore.setEnabled(true);
      _m.showLeaderboard.setEnabled(true);
    }
    else if(what == "APP_STATE_CLIENT")
    {
      _m.signInCloudSave.setEnabled(false);
      _m.signOutCloudSave.setEnabled(true);
      _m.updateState.setEnabled(true);
      _m.loadState.setEnabled(true);
      _m.deleteState.setEnabled(true);
    }
  }

  override public function onSignedOut(what : String)
  {
    if(what == "GAMES_CLIENT")
    {
      _m.signInGames.setEnabled(true);
      _m.signOutGames.setEnabled(false);
      _m.unlockAchievement.setEnabled(false);
      _m.unlockIncrementalAchievement.setEnabled(false);
      _m.showAchievements.setEnabled(false);
      _m.updateScore.setEnabled(false);
      _m.showLeaderboard.setEnabled(false);
    }
    else if(what == "APP_STATE_CLIENT")
    {
      _m.signInCloudSave.setEnabled(true);
      _m.signOutCloudSave.setEnabled(false);
      _m.updateState.setEnabled(false);
      _m.loadState.setEnabled(false);
      _m.deleteState.setEnabled(false);
    }
  }

  override public function onAchievementsLoaded(achievements : Array<Achievement>)
  {
    for(a in achievements)
    {
      trace(a);
    }
  }

  override public function onStateListLoaded(states : Array<AppState>)
  {
    for(s in states)
    {
      trace(s);
    }
  }

  override public function onStateLoaded(key : Int, data : String, stale : Bool)
  {
    _m.state.text.text = data;
    if(stale)
    {
      _m.state.rect(0xffaaaa);
    }
    else
    {
      _m.state.rect(0xaaaaaa);
    }
  }

  override public function onStateDeleted(statusCode : Int, key : Int)
  {
    _m.state.text.text = "<DELETED>";
  }

  override public function onStateNotFound(key : Int)
  {
    _m.state.text.text = "<STATE NOT FOUND>";
  }

  override public function onWarning(msg : String, where : String)
  {
    trace(["Warning", msg, where]);
  }

  override public function onError(what : String, code : Int, where : String)
  {
    trace(["Error", what, code, where]);
  }

  override public function onException(msg : String, where : String)
  {
    trace(["Exception", msg, where]);
  }
}

class GoogleIAPHandler extends ru.zzzzzzerg.linden.iap.ConnectionHandler
{
  var _m : Main;

  public function new(m : Main)
  {
    super();
    this._m = m;
  }

  override public function onServiceCreated(created : Bool)
  {
    super.onServiceCreated(created);

    if(created)
    {
      for(p in _m.googleIAP.getPurchases())
      {
        if(p.productId == "android.test.purchased")
        {
          _m.testProduct = p;
        }
        else if(p.productId == "linden.managed_product")
        {
          _m.managedProduct = p;
        }
      }
    }
    else
    {
      _m.purchaseLog.text.text = "BILLING SERVICE IS NOT CREATED";
    }
  }
}

class IAPPurchaseHandler extends ru.zzzzzzerg.linden.iap.PurchaseHandler
{
  var _m : Main;
  public function new(m : Main)
  {
    super();
    this._m = m;
  }

  override public function purchased(jsonString : String)
  {
    super.purchased(jsonString);

    if(item.productId == "android.test.purchased")
    {
      _m.testProduct = item;
      _m.purchaseLog.text.text = 'Purchased\n${item.productId}';
    }
    else if(item.productId == "linden.managed_product")
    {
      _m.managedProduct = item;
      _m.purchaseLog.text.text = 'Purchased\n${item.productId}';
    }
  }

  override public function finished()
  {
    super.finished();
  }
}
