' /**
'  * @module rooibosh
'  */

' /**
'  * @memberof module:rooibosh
'  * @name Rooibos__Init
'  * @function
'  * @description Entry point for rooibos unit testing framework. Will identify, run, and report all tests in the app, before terminating the application.
'  * @param {Dynamic} preTestSetup - called to do any initialization once the screen is created
'  *                   Use this to configure anything such as globals, etc that you need
'  * @param {Dynamic} testUtilsDecorator - will be invoked, with the test case as a param - the function
'  *                     can then compose/decorate any additional functionality, as required
'  *                   Use this to add things like, rodash, common test utils, etc
'  * @param testsSceneName as string - name of scene to create. All unit tests run in the scene thread
'  *                   and therefore require a screen and scene are created.
'  */
function Rooibos__Init(_options = {} as object) as void
  options = {
    preTestSetup: invalid
    testUtilsDecoratorMethodName: invalid
    testSceneName: "TestsScene"
    configPath: "pkg:/source/tests/rooibos/testconfig.json"
  }
  options.append(_options)
  ? "OPTIONS: " options
  if NOT validateOptions(options) then return


  args = {}
  if createObject("roAPPInfo").IsDev() <> true then
    ? " not running in dev mode! - rooibos tests only support sideloaded builds - aborting"
    return
  end if

  args.testUtilsDecoratorMethodName = options.testUtilsDecoratorMethodName

  screen = CreateObject("roSGScreen")
  m.port = CreateObject("roMessagePort")
  screen.setMessagePort(m.port)

  args.testConfigPath = options.configPath

  ? "Starting test using test scene with name TestsScene" ; options.testSceneName
  scene = screen.CreateScene(options.testSceneName)
  scene.id = "ROOT"
  screen.show()

  m.global = screen.getGlobalNode()
  m.global.addFields({"testsScene": scene})
  
  if (options.preTestSetup <> invalid)
    options.preTestSetup(screen)
  end if


  testId = args.TestId
  if (testId = invalid)
    testId = "UNDEFINED_TEST_ID"
  end if

  ? "#########################################################################"
  ? "#TEST START : ###" ; testId ; "###"

  args.testScene = scene
  args.global = m.global
  
  runner = RBS_TR_TestRunner(args)
  runner.Run()

  while(true)
    msg = wait(0, m.port)
    msgType = type(msg)
    if msgType = "roSGScreenEvent"
      if msg.isScreenClosed()
        return
      end if
    end if
  end while
end function

function validateOptions(opts) as Boolean
  if opts.preTestSetup <> invalid AND type(opts.preTestSetup, 3) <> "Function"
    ? "preTestSetup should be of type Function"
    return false
  end if

  if opts.testUtilsDecoratorMethodName <> invalid AND type(opts.testUtilsDecoratorMethodName, 3) <> "String"
    ? "testUtilsDecoratorMethodName should be of type String"
    return false
  end if

  if type(opts.testSceneName, 3) <> "String"
    ? "testSceneName should be of type String"
    return false
  end if

  if type(opts.configPath, 3) <> "String"
    ? "configPath should be of type String"
    return false
  end if

  return true
end function




