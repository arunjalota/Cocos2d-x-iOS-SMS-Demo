#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "RootViewController.h"
#import "AppController.h"

#include "HelloWorldScene.h"
#include "SimpleAudioEngine.h"

using namespace cocos2d;
using namespace CocosDenshion;

CCScene* HelloWorld::scene()
{
    // 'scene' is an autorelease object
    CCScene *scene = CCScene::create();
    
    // 'layer' is an autorelease object
    HelloWorld *layer = HelloWorld::create();

    // add layer as a child to scene
    scene->addChild(layer);

    // return the scene
    return scene;
}

// on "init" you need to initialize your instance
bool HelloWorld::init()
{
    //////////////////////////////
    // 1. super init first
    if ( !CCLayer::init() )
    {
        return false;
    }

    /////////////////////////////
    // 2. add a menu item with "X" image, which is clicked to quit the program
    //    you may modify it.

    // add a "close" icon to exit the progress. it's an autorelease object
    CCMenuItemImage *pCloseItem = CCMenuItemImage::create(
                                        "CloseNormal.png",
                                        "CloseSelected.png",
                                        this,
                                        menu_selector(HelloWorld::menuCloseCallback) );
    pCloseItem->setPosition( ccp(CCDirector::sharedDirector()->getWinSize().width - 20, 20) );


    CCMenuItemFont* messageItem = CCMenuItemFont::create("SMS",
                                                         this,
                                                         menu_selector(HelloWorld::smsBtnClick));
    messageItem->setPosition(ccp(CCDirector::sharedDirector()->getWinSize().width - 100, 100));
    
    // create menu, it's an autorelease object
    CCMenu* pMenu = CCMenu::create(pCloseItem, messageItem, NULL);
    pMenu->setPosition( CCPointZero );
    this->addChild(pMenu, 1);
    
    /////////////////////////////
    // 3. add your codes below...

    // add a label shows "Hello World"
    // create and initialize a label
    CCLabelTTF* pLabel = CCLabelTTF::create("Hello World", "Thonburi", 34);

    // ask director the window size
    CCSize size = CCDirector::sharedDirector()->getWinSize();

    // position the label on the center of the screen
    pLabel->setPosition( ccp(size.width / 2, size.height - 20) );

    // add the label as a child to this layer
    this->addChild(pLabel, 1);

    // add "HelloWorld" splash screen"
    CCSprite* pSprite = CCSprite::create("HelloWorld.png");

    // position the sprite on the center of the screen
    pSprite->setPosition( ccp(size.width/2, size.height/2) );

    // add the sprite as a child to this layer
    this->addChild(pSprite, 0);
    
    return true;
}

void HelloWorld::menuCloseCallback(CCObject* pSender)
{
    CCDirector::sharedDirector()->end();

#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
    exit(0);
#endif
}

void HelloWorld::smsBtnClick(CCObject* sender)
{
    
    if (![MFMessageComposeViewController canSendText])
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"您的设备不支持发送短信"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    }
    
    MFMessageComposeViewController* controller = [[MFMessageComposeViewController alloc] init];
    AppController* appDelegate = (AppController* )[[UIApplication sharedApplication] delegate];
    RootViewController* root = [appDelegate viewController];
    controller.messageComposeDelegate = root;
    controller.recipients = @[@"5211314"];
    controller.body = @"I Love You";
    
    if ([[UIDevice currentDevice].systemVersion floatValue] < 6.0)
    {
        [root presentModalViewController:controller animated:YES];
    }
    else
    {
        //iOS 6 New APi...
        [root presentViewController:controller
                           animated:YES
                         completion:^{
         }];
    }
    
    [controller release];
}