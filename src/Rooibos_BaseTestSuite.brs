' /**
'  * @module BaseTestSuite
'  */

function BaseTestSuite() as Object

    this = {}
    this.Name                           = "BaseTestSuite"
    
    'Test Cases methods
    this.TestCases = []
    this.AddTest                        = RBS_BTS_AddTest
    this.CreateTest                     = RBS_BTS_CreateTest
    
    'Assertion methods which determine test failure
    this.Fail                           = RBS_BTS_Fail
    this.AssertFalse                    = RBS_BTS_AssertFalse
    this.AssertTrue                     = RBS_BTS_AssertTrue
    this.AssertEqual                    = RBS_BTS_AssertEqual
    this.AssertLike                     = RBS_BTS_AssertLike
    this.AssertNotEqual                 = RBS_BTS_AssertNotEqual
    this.AssertInvalid                  = RBS_BTS_AssertInvalid
    this.AssertNotInvalid               = RBS_BTS_AssertNotInvalid
    this.AssertAAHasKey                 = RBS_BTS_AssertAAHasKey
    this.AssertAANotHasKey              = RBS_BTS_AssertAANotHasKey
    this.AssertAAHasKeys                = RBS_BTS_AssertAAHasKeys
    this.AssertAANotHasKeys             = RBS_BTS_AssertAANotHasKeys
    this.AssertArrayContains            = RBS_BTS_AssertArrayContains
    this.AssertArrayNotContains         = RBS_BTS_AssertArrayNotContains
    this.AssertArrayContainsSubset      = RBS_BTS_AssertArrayContainsSubset
    this.AssertArrayNotContainsSubset   = RBS_BTS_AssertArrayNotContainsSubset
    this.AssertArrayCount               = RBS_BTS_AssertArrayCount
    this.AssertArrayNotCount            = RBS_BTS_AssertArrayNotCount
    this.AssertEmpty                    = RBS_BTS_AssertEmpty
    this.AssertNotEmpty                 = RBS_BTS_AssertNotEmpty
    this.AssertArrayContainsOnly        = RBS_BTS_AssertArrayContainsOnly
    this.AssertType                   = RBS_BTS_AssertType
    this.AssertSubType                = RBS_BTS_AssertSubType
    
    'Node extensions
    this.AssertNodeCount               = RBS_BTS_AssertNodeCount
    this.AssertNodeNotCount            = RBS_BTS_AssertNodeNotCount
    this.AssertNodeEmpty              = RBS_BTS_AssertNodeEmpty
    this.AssertNodeNotEmpty            = RBS_BTS_AssertNodenotEmpty

    this.AssertNodeContains            = RBS_BTS_AssertNodeContains
    this.AssertNodeNotContains         = RBS_BTS_AssertNodeNotContains
    this.AssertNodeContainsFields      = RBS_BTS_AssertNodeContainsFields
    this.AssertNodeNotContainsFields   = RBS_BTS_AssertNodeNotContainsFields
    this.AssertAAContainsSubset   = RBS_BTS_AssertAAContainsSubset

    'Type Comparison Functionality
    this.EqValues                       = RBS_BTS_EqValues
    this.EqAssocArrays                  = RBS_BTS_EqAssocArray
    this.EqArrays                       = RBS_BTS_EqArray

    'Mocking and stubbing
    
    this.Stub             = RBS_BTS_Stub
    this.Mock             = RBS_BTS_Mock
    this.AssertMocks      = RBS_BTS_AssertMocks
    this.CreateFake       = RBS_BTS_CreateFake
    this.MockFail         = RBS_BTS_MockFail
    this.CleanMocks         = RBS_BTS_CleanMocks
    this.CleanStubs         = RBS_BTS_CleanStubs
    
    'Mocking short hand methods
    this.ExpectOnce         = RBS_BTS_ExpectOnce
    this.ExpectNone         = RBS_BTS_ExpectNone
    this.Expect         = RBS_BTS_Expect
    
    
    'note the following callbacks are mapped as we don't have reflection in brightscript
    'and we need context to know what fields are called
    'I avoided using eval, as I don't know what threads tests might run in
    'so dont' want to risk srewing with people's lives
    
    'Callback mapping - mocks
    this.MockCallback0         = RBS_BTS_MockCallback0
    this.MockCallback1         = RBS_BTS_MockCallback1
    this.MockCallback2         = RBS_BTS_MockCallback2
    this.MockCallback3         = RBS_BTS_MockCallback3
    this.MockCallback4         = RBS_BTS_MockCallback4
    this.MockCallback5         = RBS_BTS_MockCallback5
    
    
    'Callback mapping - Stubs
    this.StubCallback0         = RBS_BTS_StubCallback0
    this.StubCallback1         = RBS_BTS_StubCallback1
    this.StubCallback2         = RBS_BTS_StubCallback2
    this.StubCallback3         = RBS_BTS_StubCallback3
    this.StubCallback4         = RBS_BTS_StubCallback4
    this.StubCallback5         = RBS_BTS_StubCallback5
    
    'utility functions to make life nicer
    this.pathAsArray_ = RBS_BTS_rodash_pathsAsArray_
    this.g = RBS_BTS_rodash_get_
    return this
End Function

' /**
'  * @memberof module:BaseTestSuite
'  * @name AddTest
'  * @function
'  * @instance
'  * @description Add a test to a suite's test cases array. Used internally.
'  * @param {String} name - A test name.
'  * @param {String} func - A test function name.
'  */ 
Sub RBS_BTS_AddTest(name as String, func as Object, funcName as String, setup = invalid as Object, teardown = invalid as Object)
    m.testCases.Push(m.createTest(name, func, funcName, setup, teardown))
End Sub

' /**
'  * @memberof module:BaseTestSuite
'  * @name CreateTest
'  * @function
'  * @instance
'  * @description Create a test object. Used internally
'  * @param {String} name - A test name.
'  * @param {String} func - A test function name.
'  */ 
Function RBS_BTS_CreateTest(name as String, func as Object, funcName as String, setup = invalid as Object, teardown = invalid as Object) as Object

    if (func = invalid) 
        ? " ASKED TO CREATE TEST WITH INVALID FUNCITON POINTER FOR FUNCTION " ; funcName
        ? " Looking it up now"
        res = eval("functionPointer=" + funcName)
        
        if (RBS_CMN_IsInteger(res) and res = 252 and functionPointer <> invalid)
            ? "found the function"
            func = functionPointer
        else
            ? " could not find function!"
        end if
    end if
    return {
        Name: name 
        Func: func
        FuncName: funcName
        SetUp: setup
        TearDown: teardown
    }
End Function

' /**
'  * @memberof module:BaseTestSuite
'  * @name Fail
'  * @function
'  * @instance
'  * @description Fail immediately, with the given message
'  * @param {String} msg - message to display in the test report
'  * @returns {boolean} - true if the assert was satisfied, false otherwise
'  */
Function RBS_BTS_Fail(msg = "Error" as string) as boolean
    if (m.currentResult.isFail) then return false ' skip test we already failed
    m.currentResult.AddResult(msg)
    return false
End Function

' /**
'  * @memberof module:BaseTestSuite
'  * @name AssertFalse
'  * @function
'  * @instance
'  * @description Fail the test if the expression is true.
'  * @param {dynamic} expr - An expression to evaluate.
'  * @param {String} msg - alternate error message
' Default value: "Expression evaluates to true"'  * @returns {boolean} - true if the assert was satisfied, false otherwise
'  */ 
Function RBS_BTS_AssertFalse(expr as dynamic, msg = "Expression evaluates to true" as string) as boolean
    if (m.currentResult.isFail) then return false ' skip test we already failed
    if not RBS_CMN_IsBoolean(expr) or expr 
        m.currentResult.AddResult(msg)
        return m.fail(msg)
    end if
    m.currentResult.AddResult("")
    return true
End Function

' /**
'  * @memberof module:BaseTestSuite
'  * @name AssertTrue
'  * @function
'  * @instance
'  * @description Fail the test unless the expression is true.
'  * @param {dynamic} expr - An expression to evaluate.
'  * @param {String} msg - alternate error message
'  * @returns {boolean} - true if the assert was satisfied, false otherwise
'  */ 
Function RBS_BTS_AssertTrue(expr as dynamic, msg = "Expression evaluates to false" as string) as boolean
    if (m.currentResult.isFail) then return false ' skip test we already failed
    if not RBS_CMN_IsBoolean(expr) or not expr then
        m.currentResult.AddResult(msg)
        return false
    End if
    m.currentResult.AddResult("")
    return true
End Function

' /**
'  * @memberof module:BaseTestSuite
'  * @name AssertEqual
'  * @function
'  * @instance
'  * @description Fail if the two objects are unequal as determined by the '<>' operator.
'  * @param {dynamic} first - first object to compare
'  * @param {dynamic} second - second object to compare
'  * @param {String} msg - alternate error message
'  * @returns {boolean} - true if the assert was satisfied, false otherwise
'  */ 
Function RBS_BTS_AssertEqual(first as dynamic, second as dynamic, msg = "" as string) as boolean
    if (m.currentResult.isFail) then return false ' skip test we already failed
    if not m.eqValues(first, second)
        if msg = ""
            first_as_string = RBS_CMN_AsString(first)
            second_as_string = RBS_CMN_AsString(second)
            msg = first_as_string + " != " + second_as_string 
        end if
        m.currentResult.AddResult(msg)
        return false
    end if
    m.currentResult.AddResult("")
    return true
End Function

' /**
'  * @memberof module:BaseTestSuite
'  * @name AssertLike
'  * @function
'  * @instance
'  * @description does a fuzzy comparison
'  * @param {dynamic} first - first object to compare
'  * @param {dynamic} second - second object to compare
'  * @param {String} msg - alternate error message
'  * @returns {boolean} - true if the assert was satisfied, false otherwise
'  */ 
Function RBS_BTS_AssertLike(first as dynamic, second as dynamic, msg = "" as string) as boolean
    if (m.currentResult.isFail) then return false ' skip test we already failed
    if first <> second
        if msg = ""
            first_as_string = RBS_CMN_AsString(first)
            second_as_string = RBS_CMN_AsString(second)
            msg = first_as_string + " != " + second_as_string 
        end if
        m.currentResult.AddResult(msg)
        return false
    end if
    m.currentResult.AddResult("")
    return true
End Function

' /**
'  * @memberof module:BaseTestSuite
'  * @name AssertNotEqual
'  * @function
'  * @instance
'  * @description Fail if the two objects are equal as determined by the '=' operator.
'  * @param {dynamic} first - first object to compare
'  * @param {dynamic} second - second object to compare
'  * @param {String} msg - alternate error message
'  * @returns {boolean} - true if the assert was satisfied, false otherwise
'  */ 
Function RBS_BTS_AssertNotEqual(first as dynamic, second as dynamic, msg = "" as string) as boolean
    if (m.currentResult.isFail) then return false ' skip test we already failed
    if m.eqValues(first, second)
        if msg = ""
            first_as_string = RBS_CMN_AsString(first)
            second_as_string = RBS_CMN_AsString(second)
            msg = first_as_string + " == " + second_as_string 
        end if
        m.currentResult.AddResult(msg)
        return false
    end if
    m.currentResult.AddResult("")
    return true
End Function

' /**
'  * @memberof module:BaseTestSuite
'  * @name AssertInvalid
'  * @function
'  * @instance
'  * @description Fail if the value is not invalid.
'  * @param {dynamic} value - value to check for
'  * @param {String} msg - alternate error message
'  * @returns {boolean} - true if the assert was satisfied, false otherwise
'  */ 
Function RBS_BTS_AssertInvalid(value as dynamic, msg = "" as string) as boolean
    if (m.currentResult.isFail) then return false ' skip test we already failed
    if value <> Invalid
        if msg = ""
            expr_as_string = RBS_CMN_AsString(value)
            msg = expr_as_string + " <> Invalid"
        end if
        m.currentResult.AddResult(msg)
        return false
    end if
    m.currentResult.AddResult("")
    return true
End Function

' /**
'  * @memberof module:BaseTestSuite
'  * @name AssertNotInvalid
'  * @function
'  * @instance
'  * @description Fail if the value is invalid.
'  * @param {dynamic} value - value to check for
'  * @param {String} msg - alternate error message
'  * @returns {boolean} - true if the assert was satisfied, false otherwise
'  */ 
Function RBS_BTS_AssertNotInvalid(value as dynamic, msg = "" as string) as boolean
    if (m.currentResult.isFail) then return false ' skip test we already failed
    if value = Invalid
        if msg = ""
            expr_as_string = RBS_CMN_AsString(value)
            msg = expr_as_string + " = Invalid"
        end if
        m.currentResult.AddResult(msg)
        return false
    end if
    m.currentResult.AddResult("")
    return true
End Function

' /**
'  * @memberof module:BaseTestSuite
'  * @name AssertAAHasKey
'  * @function
'  * @instance
'  * @description Fail if the array doesn't have the key.
'  * @param {Object} array - target array
'  * @param {String} key - key name
'  * @param {String} msg - alternate error message
'  * @returns {boolean} - true if the assert was satisfied, false otherwise
'  */ 
Function RBS_BTS_AssertAAHasKey(array as dynamic, key as string, msg = "" as string) as boolean
    if (m.currentResult.isFail) then return false ' skip test we already failed
    if RBS_CMN_IsAssociativeArray(array)
        if not array.DoesExist(key)
            if msg = ""
                msg = "Array doesn't have the '" + key + "' key."
            end if
        m.currentResult.AddResult(msg)
        return false
        end if
    else
        msg = "Input value is not an Associative Array."
        m.currentResult.AddResult(msg)
        return false
    end if
    m.currentResult.AddResult("")
    return true
End Function

' /**
'  * @memberof module:BaseTestSuite
'  * @name AssertAANotHasKey
'  * @function
'  * @instance
'  * @description Fail if the array has the key.
'  * @param {Object} array - target array
'  * @param {String} key - key name
'  * @param {String} msg - alternate error message
'  * @returns {boolean} - true if the assert was satisfied, false otherwise
'  */ 
Function RBS_BTS_AssertAANotHasKey(array as dynamic, key as string, msg = "" as string) as boolean
    if (m.currentResult.isFail) then return false ' skip test we already failed
    if RBS_CMN_IsAssociativeArray(array)
        if array.DoesExist(key)
            if msg = ""
                msg = "Array has the '" + key + "' key."
            end if
        m.currentResult.AddResult(msg)
        return false
        end if
    else
        msg = "Input value is not an Associative Array."
        m.currentResult.AddResult(msg)
        return false
    end if
    m.currentResult.AddResult("")
    return true
End Function

' /**
'  * @memberof module:BaseTestSuite
'  * @name AssertAAHasKeys
'  * @function
'  * @instance
'  * @description Fail if the array doesn't have the keys list.
'  * @param {dynamic} array - A target associative array.
'  * @param {Array} keys - Array of key names.
'  * @param {String} msg - alternate error message
'  * @returns {boolean} - true if the assert was satisfied, false otherwise
'  */ 
Function RBS_BTS_AssertAAHasKeys(array as dynamic, keys as object, msg = "" as string) as boolean
    if (m.currentResult.isFail) then return false ' skip test we already failed
    if RBS_CMN_IsAssociativeArray(array) and RBS_CMN_IsArray(keys)
        for each key in keys
            if not array.DoesExist(key)
                if msg = ""
                    msg = "Array doesn't have the '" + key + "' key."
                end if
            m.currentResult.AddResult(msg)
            return false
            end if
        end for
    else
        msg = "Input value is not an Associative Array."
        m.currentResult.AddResult(msg)
        return false
    end if
    m.currentResult.AddResult("")
    return true
End Function

' /**
'  * @memberof module:BaseTestSuite
'  * @name AssertAANotHasKeys
'  * @function
'  * @instance
'  * @description Fail if the array has the keys list.
'  * @param {dynamic} array - A target associative array.
'  * @param {Array} keys - Array of key names.
'  * @param {String} msg - alternate error message
'  * @returns {boolean} - true if the assert was satisfied, false otherwise
'  */ 
Function RBS_BTS_AssertAANotHasKeys(array as dynamic, keys as object, msg = "" as string) as boolean
    if (m.currentResult.isFail) then return false ' skip test we already failed
    if RBS_CMN_IsAssociativeArray(array) and RBS_CMN_IsArray(keys)
        for each key in keys
            if array.DoesExist(key)
                if msg = ""
                    msg = "Array has the '" + key + "' key."
                end if
            m.currentResult.AddResult(msg)
            return false
            end if
        end for
    else
        msg = "Input value is not an Associative Array."
        m.currentResult.AddResult(msg)
        return false
    end if
    m.currentResult.AddResult("")
    return true
End Function



' /**
'  * @memberof module:BaseTestSuite
'  * @name AssertArrayContains
'  * @function
'  * @instance
'  * @description Fail if the array doesn't have the item.
'  * @param {Object} array - target array
'  * @param {dynamic} value - value to check for
'  * @param {String} key - key name in associative array
'  * @param {String} msg - alternate error message
'  * @returns {boolean} - true if the assert was satisfied, false otherwise
'  */ 
Function RBS_BTS_AssertArrayContains(array as dynamic, value as dynamic, key = invalid as string, msg = "" as string) as boolean
    if (m.currentResult.isFail) then return false ' skip test we already failed
    if RBS_CMN_IsAssociativeArray(array) or RBS_CMN_IsArray(array)
        if not RBS_CMN_ArrayContains(array, value, key)
            msg = "Array doesn't have the '" + RBS_CMN_AsString(value) + "' value."
            m.currentResult.AddResult(msg)
            return false
        end if
    else
        msg = "Input value is not an Array."
        m.currentResult.AddResult(msg)
        return false
    end if
    m.currentResult.AddResult("")
    return true
End Function

' /**
'  * @memberof module:BaseTestSuite
'  * @name AssertArrayNotContains
'  * @function
'  * @instance
'  * @description Fail if the array has the item.
'  * @param {Object} array - target array
'  * @param {dynamic} array - target array
'  * @param {dynamic} value - Value to check for
'  * @param {String} key - A key name for associative array.
'  * @param {String} msg - alternate error message
'  * @returns {boolean} - true if the assert was satisfied, false otherwise
'  */ 
Function RBS_BTS_AssertArrayNotContains(array as dynamic, value as dynamic, key = invalid as string, msg = "" as string) as boolean
    if (m.currentResult.isFail) then return false ' skip test we already failed
    if RBS_CMN_IsAssociativeArray(array) or RBS_CMN_IsArray(array)
        if RBS_CMN_ArrayContains(array, value, key)
            msg = "Array has the '" + RBS_CMN_AsString(value) + "' value."
            m.currentResult.AddResult(msg)
            return false
        end if
    else
        msg = "Input value is not an Array."
        m.currentResult.AddResult(msg)
        return false
    end if
    m.currentResult.AddResult("")
    return true
End Function

' /**
'  * @memberof module:BaseTestSuite
'  * @name AssertArrayContainsSubset
'  * @function
'  * @instance
'  * @description Fail if the array doesn't have the item subset.
'  * @param {Object} array - target array
'  * @param {dynamic} subset - items to check presnece of
'  * @param {String} msg - alternate error message
'  * @returns {boolean} - true if the assert was satisfied, false otherwise
'  */ 
Function RBS_BTS_AssertArrayContainsSubset(array as dynamic, subset as dynamic, msg = "" as string) as boolean
    if (m.currentResult.isFail) then return false ' skip test we already failed
    if (RBS_CMN_IsAssociativeArray(array) and RBS_CMN_IsAssociativeArray(subset)) or (RBS_CMN_IsArray(array) and RBS_CMN_IsArray(subset))
        isAA = RBS_CMN_IsAssociativeArray(subset)
        for each item in subset
            key = invalid
            value = item
            if isAA
                key = item
                value = subset[key]
            end if
            if not RBS_CMN_ArrayContains(array, value, key)
                msg = "Array doesn't have the '" + RBS_CMN_AsString(value) + "' value."
                m.currentResult.AddResult(msg)
                return false
            end if
        end for
    else
        msg = "Input value is not an Array."
        m.currentResult.AddResult(msg)
        return false
    end if
    m.currentResult.AddResult("")
    return true
End Function

' /**
'  * @memberof module:BaseTestSuite
'  * @name AssertArrayNotContainsSubset
'  * @function
'  * @instance
'  * @description Fail if the array have the item from subset.
'  * @param {Object} array - target array
'  * @param {dynamic} subset - items to check presnece of
'  * @param {String} msg - alternate error message
'  * @returns {boolean} - true if the assert was satisfied, false otherwise
'  */ 
Function RBS_BTS_AssertArrayNotContainsSubset(array as dynamic, subset as dynamic, msg = "" as string) as boolean
    if (m.currentResult.isFail) then return false ' skip test we already failed
    if (RBS_CMN_IsAssociativeArray(array) and RBS_CMN_IsAssociativeArray(subset)) or (RBS_CMN_IsArray(array) and RBS_CMN_IsArray(subset))
        isAA = RBS_CMN_IsAssociativeArray(subset)
        for each item in subset
            key = invalid
            value = item
            if isAA
                key = item
                value = item[key]
            end if
            if RBS_CMN_ArrayContains(array, value, key)
                msg = "Array has the '" + RBS_CMN_AsString(value) + "' value."
                m.currentResult.AddResult(msg)
                return false
            end if
        end for
    else
        msg = "Input value is not an Array."
        m.currentResult.AddResult(msg)
        return false
    end if
    m.currentResult.AddResult("")
    return true
End Function

' /**
'  * @memberof module:BaseTestSuite
'  * @name AssertArrayCount
'  * @function
'  * @instance
'  * @description Fail if the array items count <> expected count
'  * @param {Object} array - target array
'  * @param {integer} count - An expected array items count
'  * @param {String} msg - alternate error message
'  * @returns {boolean} - true if the assert was satisfied, false otherwise
'  */ 
Function RBS_BTS_AssertArrayCount(array as dynamic, count as integer, msg = "" as string) as boolean
    if (m.currentResult.isFail) then return false ' skip test we already failed
    if RBS_CMN_IsAssociativeArray(array) or RBS_CMN_IsArray(array)
        if array.Count() <> count
            msg = "Array items count " + RBS_CMN_AsString(array.Count()) + " <> " + RBS_CMN_AsString(count) + "."
            m.currentResult.AddResult(msg)
            return false
        end if
    else
        msg = "Input value is not an Array."
        m.currentResult.AddResult(msg)
        return false
    end if
    m.currentResult.AddResult("")
    return true
End Function

' /**
'  * @memberof module:BaseTestSuite
'  * @name AssertArrayNotCount
'  * @function
'  * @instance
'  * @description Fail if the array items count = expected count.
'  * @param {Object} array - target array
'  * @param {integer} count - An expected array items count.
'  * @param {String} msg - alternate error message
'  * @returns {boolean} - true if the assert was satisfied, false otherwise
'  */ 
Function RBS_BTS_AssertArrayNotCount(array as dynamic, count as integer, msg = "" as string) as boolean
    if (m.currentResult.isFail) then return false ' skip test we already failed
    if RBS_CMN_IsAssociativeArray(array) or RBS_CMN_IsArray(array)
        if array.Count() = count
            msg = "Array items count = " + RBS_CMN_AsString(count) + "."
            m.currentResult.AddResult(msg)
            return false
        end if
    else
        msg = "Input value is not an Array."
        m.currentResult.AddResult(msg)
        return false
    end if
    m.currentResult.AddResult("")
    return true
End Function

' /**
'  * @memberof module:BaseTestSuite
'  * @name AssertEmpty
'  * @function
'  * @instance
'  * @description Fail if the item is not empty array or string.
'  * @param {dynamic} item - item to check
'  * @param {String} msg - alternate error message
'  * @returns {boolean} - true if the assert was satisfied, false otherwise
'  */ 
Function RBS_BTS_AssertEmpty(item as dynamic, msg = "" as string) as boolean
    if (m.currentResult.isFail) then return false ' skip test we already failed
    if RBS_CMN_IsAssociativeArray(item) or RBS_CMN_IsArray(item)
        if item.Count() > 0
            msg = "Array is not empty."
            m.currentResult.AddResult(msg)
            return false
        end if
    else if (RBS_CMN_IsString(item))
        if (RBS_CMN_AsString(item) <> "")
            msg = "Input value is not empty."
            m.currentResult.AddResult(msg)
            return false
        end if
    else 
        msg = "AssertEmpty: Input value was not an array or a string"
        m.currentResult.AddResult(msg)
        return false
    end if
    m.currentResult.AddResult("")
    return true
End Function

' /**
'  * @memberof module:BaseTestSuite
'  * @name AssertNotEmpty
'  * @function
'  * @instance
'  * @description Fail if the item is empty array or string.
'  * @param {dynamic} item - item to check
'  * @param {String} msg - alternate error message
'  * @returns {boolean} - true if the assert was satisfied, false otherwise
'  */ 
Function RBS_BTS_AssertNotEmpty(item as dynamic, msg = "" as string) as boolean
    if (m.currentResult.isFail) then return false ' skip test we already failed
    if RBS_CMN_IsAssociativeArray(item) or RBS_CMN_IsArray(item)
        if item.Count() = 0
            msg = "Array is empty."
            m.currentResult.AddResult(msg)
            return false
        end if
    else if RBS_CMN_IsString(item)
        if (item = "")
            msg = "Input value is empty."
            m.currentResult.AddResult(msg)
            return false
        end if
    end if
    m.currentResult.AddResult("")
    return true
End Function

' /**
'  * @memberof module:BaseTestSuite
'  * @name AssertArratNotEmpty
'  * @function
'  * @instance
'  * @description Fail if the item is empty array or string.
'  * @param {dynamic} item - item to check
'  * @param {String} msg - alternate error message
'  * @returns {boolean} - true if the assert was satisfied, false otherwise
'  */ 
Function RBS_BTS_AssertArratNotEmpty(item as dynamic, msg = "" as string) as boolean
    if (m.currentResult.isFail) then return false ' skip test we already failed
    if RBS_CMN_IsAssociativeArray(item) or RBS_CMN_IsArray(item)
        if item.Count() = 0
            msg = "Array is empty."
            m.currentResult.AddResult(msg)
            return false
        end if
    else if RBS_CMN_AsString(item) = ""
        msg = "Input value is empty."
        m.currentResult.AddResult(msg)
        return false
    end if
    m.currentResult.AddResult("")
    return true
End Function



' /**
'  * @memberof module:BaseTestSuite
'  * @name AssertArrayContainsOnly
'  * @function
'  * @instance
'  * @description Fail if the array doesn't contains items of specific type only.
'  * @param {Object} array - target array
'  * @param {String} typeStr - type name
'  * @param {String} msg - alternate error message
'  * @returns {boolean} - true if the assert was satisfied, false otherwise
'  */ 
Function RBS_BTS_AssertArrayContainsOnly(array as dynamic, typeStr as string, msg = "" as string) as boolean
    if (m.currentResult.isFail) then return false ' skip test we already failed
    if RBS_CMN_IsAssociativeArray(array) or RBS_CMN_IsArray(array)
        methodName = "RBS_CMN_Is" + typeStr
        for each item in array
            if not methodName(item)
                msg = RBS_CMN_AsString(item) + "is not a '" + typeStr + "' type."
                m.currentResult.AddResult(msg)
                return false
            end if    
        end for
    else
        msg = "Input value is not an Array."
        m.currentResult.AddResult(msg)
        return false
    end if
    m.currentResult.AddResult("")
    return true
End Function

' /**
'  * @memberof module:BaseTestSuite
'  * @name AssertType
'  * @function
'  * @instance
'  * @description Asserts that the value is a node of designated type
'  * @param {Object} value - target node
'  * @param {String} typeStr - type name
'  * @param {String} msg - alternate error message
'  * @returns {boolean} - true if the assert was satisfied, false otherwise
'  */ 
function RBS_BTS_AssertType(value as dynamic, typeStr as string, msg ="" as string) as boolean
    if (m.currentResult.isFail) then return false ' skip test we already failed
    if type(value) <> typeStr
        if msg = ""
            expr_as_string = RBS_CMN_AsString(value)
            msg = expr_as_string + " was not expected type " + typeStr
        end if
        m.currentResult.AddResult(msg)
        return false
    end if
    m.currentResult.AddResult("")
    return true
end function

' /**
'  * @memberof module:BaseTestSuite
'  * @name AssertSubType
'  * @function
'  * @instance
'  * @description Asserts that the value is a node of designated subtype
'  * @param {Object} value - target node
'  * @param {String} typeStr - type name
'  * @param {String} msg - alternate error message
'  * @returns {boolean} - true if the assert was satisfied, false otherwise
'  */ 
function RBS_BTS_AssertSubType(value as dynamic, typeStr as string, msg ="" as string) as boolean
    if (m.currentResult.isFail) then return false ' skip test we already failed
    if type(value) <> "roSGNode"
        if msg = ""
            expr_as_string = RBS_CMN_AsString(value)
            msg = expr_as_string + " was not a node, so could not match subtype " + typeStr
        end if
        m.currentResult.AddResult(msg)
        return false
    else if (value.subType() <> typeStr)
        if msg = ""
            expr_as_string = RBS_CMN_AsString(value)
            msg = expr_as_string + "( type : " + value.subType() +") was not of subType " + typeStr
        end if
        m.currentResult.AddResult(msg)
        return false
    end if
    m.currentResult.AddResult("")
    return true
end function

' /**
'  * @memberof module:BaseTestSuite
'  * @name EqValues
'  * @function
'  * @instance
'  * @description Compare two arbtrary values to eachother.
'  * @param {Object} Vallue1 - first item to compare
'  * @param {Object} Vallue2 - second item to compare
'  * @returns {boolean} - True if values are equal or False in other case.
'  */ 
Function RBS_BTS_EqValues(Value1 as dynamic, Value2 as dynamic) as Boolean
    ' Workaraund for bug with string boxing, and box everything else
    val1Type = type(Value1)
    val2Type = type(Value2)
    if val1Type = "<uninitialized>" or val2Type = "<uninitialized>"
        ? "ERROR!!!! - undefined value passed"
        return false
    end if 
    
    if val1Type = "roString" or val1Type = "String"
        Value1 = RBS_CMN_AsString(Value1)
    else
        Value1 = box(Value1)
    end if
    
    if val2Type = "roString" or val2Type = "String"
        Value2 = RBS_CMN_AsString(Value2)
    else
        Value2 = box(Value2)
    end if
    'update types after boxing
    val1Type = type(Value1)
    val2Type = type(Value2)

    
    'Upcast int to float, if other is float
    if val1Type = "roFloat" and val2Type = "roInt"
        Value2 = box(Cdbl(Value2))
    else if val2Type = "roFloat" and val1Type = "roInt"
        Value1 = box(Cdbl(Value1))
    end if

    if val1Type <> val2Type
        return False
    else
        valtype = val1Type
        
        if valtype = "<uninitialized>"
            return False
        else if valtype = "roList"
            return m.eqArrays(Value1, Value2)
        else if valtype = "roAssociativeArray"
            return m.eqAssocArrays(Value1, Value2)
        else if valtype = "roArray"
            return m.eqArrays(Value1, Value2)
        else if (valtype = "roSGNode")
            if (val2Type <> "roSGNode")
                return false
            else
                return Value1.isSameNode(Value2)
            end if
        else
            'If you crashed on this line, then you're trying to compare
            '2 things which can't be compared - check what value1 and value2
            'are in your debug log
            return Value1 = Value2
        end if    
    end if
End Function 

' /**
'  * @memberof module:BaseTestSuite
'  * @name EqAssocArray
'  * @function
'  * @instance
'  * @description Compare to roAssociativeArray objects for equality.
'  * @param {Object} Vallue1 - first associative array
'  * @param {Object} Vallue2 - second associative array
'  * @returns {boolean} - True if arrays are equal or False in other case.
'  */ 
Function RBS_BTS_EqAssocArray(Value1 as Object, Value2 as Object) as Boolean
    l1 = Value1.Count()
    l2 = Value2.Count()
    
    if not l1 = l2
        return False
    else
        for each k in Value1
            if not Value2.DoesExist(k)
                return False
            else
                v1 = Value1[k]
                v2 = Value2[k]
                if not m.eqValues(v1, v2)
                    return False
                end if
            end if
        end for
        return True
    end if
End Function 

' /**
'  * @memberof module:BaseTestSuite
'  * @name EqArray
'  * @function
'  * @instance
'  * @description Compare to roArray objects for equality.
'  * @param {Object} Vallue1 - first array
'  * @param {Object} Vallue2 - second array
'  * @returns {boolean} - True if arrays are equal or False in other case.
'  */ 
Function RBS_BTS_EqArray(Value1 as Object, Value2 as Object) as Boolean
    l1 = Value1.Count()
    l2 = Value2.Count()
    
    if not l1 = l2
        return False
    else
        for i = 0 to l1 - 1
            v1 = Value1[i]
            v2 = Value2[i]
            if not m.eqValues(v1, v2) then
                return False
            end if
        end for
        return True
    end if
End Function




'+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
'++ NEW NODE ASSERTS
'+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

' /**
'  * @memberof module:BaseTestSuite
'  * @name AssertNodeCount
'  * @function
'  * @instance
'  * @description Asserts that the node contains the desginated number of children
'  * @param {dynamic} node - target node
'  * @param {integer} count - expected number of child items
'  * @param {String} msg - alternate error message
'  * @returns {boolean} - true if the assert was satisfied, false otherwise
'  */ 
Function RBS_BTS_AssertNodeCount(node as dynamic, count as integer, msg = "" as string) as boolean
    if (m.currentResult.isFail) then return false ' skip test we already failed
    if type(node) = "roSGNode" 
        if node.getChildCount() <> count
            msg = "node items count <> " + RBS_CMN_AsString(count) + ". Received " + RBS_CMN_AsString(node.getChildCount())
            m.currentResult.AddResult(msg)
            return false
        end if
    else
        msg = "Input value is not an node."
        m.currentResult.AddResult(msg)
        return false
    end if
    m.currentResult.AddResult("")
    return true
End Function

' /**
'  * @memberof module:BaseTestSuite
'  * @name AssertNodeNotCount
'  * @function
'  * @instance
'  * @description Fail if the node items count = expected count.
'  * @param {dynamic} node - A target node
'  * @param {integer} count - Expected item count
'  * @param {String} msg - alternate error message
'  * @returns {boolean} - true if the assert was satisfied, false otherwise
'  */ 
Function RBS_BTS_AssertNodeNotCount(node as dynamic, count as integer, msg = "" as string) as boolean
    if (m.currentResult.isFail) then return false ' skip test we already failed
    if type(node) = "roSGNode" 
        if node.getChildCount() = count
            msg = "node items count = " + RBS_CMN_AsString(count) + "."
            m.currentResult.AddResult(msg)
            return false
        end if
    else
        msg = "Input value is not an node."
        m.currentResult.AddResult(msg)
        return false
    end if
    m.currentResult.AddResult("")
    return true
End Function

' /**
'  * @memberof module:BaseTestSuite
'  * @name AssertNodeEmpty
'  * @function
'  * @instance
'  * @description Asserts the node has no children
'  * @param {dynamic} node - a node to check
'  * @param {String} msg - alternate error message
'  * @returns {boolean} - true if the assert was satisfied, false otherwise
'  */ 
Function RBS_BTS_AssertNodeEmpty(node as dynamic, msg = "" as string) as boolean
    if (m.currentResult.isFail) then return false ' skip test we already failed
    if type(node) = "roSGNode" 
        if node.getChildCount() > 0
            msg = "node is not empty."
            m.currentResult.AddResult(msg)
            return false
        end if
    end if
    m.currentResult.AddResult("")
    return true
End Function

' /**
'  * @memberof module:BaseTestSuite
'  * @name AssertNodeNotEmpty
'  * @function
'  * @instance
'  * @description Asserts the node has children
'  * @param {dynamic} node - a node to check
'  * @param {String} msg - alternate error message
'  * @returns {boolean} - true if the assert was satisfied, false otherwise
'  */ 
Function RBS_BTS_AssertNodeNotEmpty(node as dynamic, msg = "" as string) as boolean
    if (m.currentResult.isFail) then return false ' skip test we already failed
    if type(node) = "roSGNode" 
        if node.Count() = 0
            msg = "Array is empty."
            m.currentResult.AddResult(msg)
            return false
        end if
    end if
    m.currentResult.AddResult("")
    return true
End Function

' /**
'  * @memberof module:BaseTestSuite
'  * @name AssertNodeEmpty
'  * @function
'  * @instance
'  * @description Asserts the node has contains the child _value_
'  * @param {dynamic} node - a node to check
'  * @param {dynamic} value - value to look for
'  * @param {String} msg - alternate error message
'  * @returns {boolean} - true if the assert was satisfied, false otherwise
'  */ 
Function RBS_BTS_AssertNodeContains(node as dynamic, value as dynamic, msg = "" as string) as boolean
    if (m.currentResult.isFail) then return false ' skip test we already failed
    if  type(node) = "roSGNode" 
        if not RBS_CMN_NodeContains(node, value)
            msg = "Node doesn't have the '" + RBS_CMN_AsString(value) + "' value."
            m.currentResult.AddResult(msg)
            return false
        end if
    else
        msg = "Input value is not an Node."
        m.currentResult.AddResult(msg)
        return false
    end if
    m.currentResult.AddResult("")
    return true
End Function

' /**
'  * @memberof module:BaseTestSuite
'  * @name AssertNodeContainsOnly
'  * @function
'  * @instance
'  * @description Asserts the node contains only the child _value_
'  * @param {dynamic} node - a node to check
'  * @param {dynamic} value - value to look for
'  * @param {String} msg - alternate error message
'  * @returns {boolean} - true if the assert was satisfied, false otherwise
'  */ 
Function RBS_BTS_AssertNodeContainsOnly(node as dynamic, msg = "" as string) as boolean
    if (m.currentResult.isFail) then return false ' skip test we already failed
    if  type(node) = "roSGNode" 
        if not RBS_CMN_NodeContains(node, value)
            msg = "Node doesn't have the '" + RBS_CMN_AsString(value) + "' value."
            m.currentResult.AddResult(msg)
            return false
        else if node.getChildCount() <> 1
            msg = "Node Contains speicified value; but other values as well"
            m.currentResult.AddResult(msg)
            return false
        end if
    else
        msg = "Input value is not an Node."
        m.currentResult.AddResult(msg)
        return false
    end if
    m.currentResult.AddResult("")
    return true
End Function


' /**
'  * @memberof module:BaseTestSuite
'  * @name AssertNodeNotContains
'  * @function
'  * @instance
'  * @description Fail if the node has the item.
'  * @param {dynamic} node - A target node
'  * @param {Object} value - a node child
'  * @param {String} msg - alternate error message
'  * @returns {boolean} - true if the assert was satisfied, false otherwise
'  */ 
Function RBS_BTS_AssertNodeNotContains(node as dynamic, value as dynamic, msg = "" as string) as boolean
    if (m.currentResult.isFail) then return false ' skip test we already failed
    if  type(node) = "roSGNode" 
        if RBS_CMN_NodeContains(node, value)
            msg = "Node has the '" + RBS_CMN_AsString(value) + "' value."
            m.currentResult.AddResult(msg)
            return false
        end if
    else
        msg = "Input value is not an Node."
        m.currentResult.AddResult(msg)
        return false
    end if
    m.currentResult.AddResult("")
    return true
End Function

' /**
'  * @memberof module:BaseTestSuite
'  * @name AssertNodeContainsFields
'  * @function
'  * @instance
'  * @description Fail if the node doesn't have the item subset.
'  * @param {dynamic} node - A target node
'  * @param {dynamic} subset - items to check
'  * @param {String} msg - alternate error message
'  * @returns {boolean} - true if the assert was satisfied, false otherwise
'  */ 
Function RBS_BTS_AssertNodeContainsFields(node as dynamic, subset as dynamic, ignoredFields=invalid, msg = "" as string) as boolean
    if (m.currentResult.isFail) then return false ' skip test we already failed
    if ( type(node) = "roSGNode" and RBS_CMN_IsAssociativeArray(subset)) or ( type(node) = "roSGNode"  and RBS_CMN_IsArray(subset))
        isAA = RBS_CMN_IsAssociativeArray(subset)
        isIgnoredFields = RBS_CMN_IsArray(ignoredFields)
        for each key in subset
            if (key <> "")
                if (not isIgnoredFields or not RBS_CMN_ArrayContains(ignoredFields, key))
                    subsetValue = subset[key]
                    nodeValue = node[key]
                    if not m.eqValues(nodeValue, subsetValue)
                        msg = key + ": Expected '" + RBS_CMN_AsString(subsetValue) + "', got '" + RBS_CMN_AsString(nodeValue) + "'"
                        m.currentResult.AddResult(msg)
                        return false
                    end if
                end if
            else
                ? "Found empty key!"    
            end if
        end for
    else
        msg = "Input value is not an Node."
        m.currentResult.AddResult(msg)
        return false
    end if
    m.currentResult.AddResult("")
    return true
End Function

' /**
'  * @memberof module:BaseTestSuite
'  * @name AssertNodeNotContainsFields
'  * @function
'  * @instance
'  * @description Fail if the node have the item from subset.
'  * @param {dynamic} node - A target node
'  * @param {dynamic} subset - the items to check for
'  * @param {String} msg - alternate error message
'  * @returns {boolean} - true if the assert was satisfied, false otherwise
' */
Function RBS_BTS_AssertNodeNotContainsFields(node as dynamic, subset as dynamic, msg = "" as string) as boolean
    if (m.currentResult.isFail) then return false ' skip test we already failed
    if ( type(node) = "roSGNode"  and RBS_CMN_IsAssociativeArray(subset)) or ( type(node) = "roSGNode" and RBS_CMN_IsArray(subset))
        isAA = RBS_CMN_IsAssociativeArray(subset)
        for each item in subset
            key = invalid
            value = item
            if isAA
                key = item
                value = item[key]
            end if
            if RBS_CMN_NodeContains(node, value, key)
                msg = "Node has the '" + RBS_CMN_AsString(value) + "' value."
                m.currentResult.AddResult(msg)
            return false
            end if
        end for
    else
        msg = "Input value is not an Node."
        m.currentResult.AddResult(msg)
        return false
    end if
    m.currentResult.AddResult("")
    return true
End Function

'+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
'++ END NODE ASSERTS
'+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

' /**
'  * @memberof module:BaseTestSuite
'  * @name AssertAAContainsSubset
'  * @function
'  * @instance
'  * @description Asserts the associative array contains the fields contained in subset; while ignoring the fields in the ignoredFields array
'  * @param {dynamic} array - associative array  to check
'  * @param {dynamic} subset - associative array of values to check for
'  * @param {Array} ignoredFields - array of fieldnames to ignore while comparing
'  * @param {String} msg - alternate error message
'  * @returns {boolean} - true if the assert was satisfied, false otherwise
'  */ 
Function RBS_BTS_AssertAAContainsSubset(array as dynamic, subset as dynamic, ignoredFields = invalid, msg = "" as string) as boolean
    if (m.currentResult.isFail) then return false ' skip test we already failed
    if (RBS_CMN_IsAssociativeArray(array) and RBS_CMN_IsAssociativeArray(subset)) 
        isAA = RBS_CMN_IsAssociativeArray(subset)
        isIgnoredFields = RBS_CMN_IsArray(ignoredFields)
        for each key in subset
            if (key <> "")
                if (not isIgnoredFields or not RBS_CMN_ArrayContains(ignoredFields, key))
                    subsetValue = subset[key]
                    arrayValue = array[key]
                    if not m.eqValues(arrayValue, subsetValue)
                        msg = key + ": Expected '" + RBS_CMN_AsString(subsetValue) + "', got '" + RBS_CMN_AsString(arrayValue) + "'"
                        m.currentResult.AddResult(msg)
                        return false
                    end if
                end if
            else
                ? "Found empty key!"    
            end if
        end for
    else
        msg = "Input values are not an Associative Array."
        
        return false
    end if
    m.currentResult.AddResult("")
    return true
End Function


'+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
'++ STubbing helpers
'+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

'*************************************************************
'** ExpectCall
'** Will create a stub and expect the number of invocations, with args. Will also return the stub return value
'** @param target as ObjectP paramdesc
'** @param methodName as ObjectP paramdesc
'** @param expectedInvocations as ObjectP paramdesc
'** @param expectedArgs as ObjectP paramdesc
'** @param param as ObjectP paramdesc
'** @return returnValue retdesc
'*************************************************************


' /**
'  * @memberof module:BaseTestSuite
'  * @name Stub
'  * @function
'  * @instance
'  * @description Creates a stub to replace a real method with
'  * @param {Object} target - object on which the method to be stubbed is found
'  * @param {String} methodName - name of method to stub
'  * @param {integer} expectedInvocations - number of invocations we expect
'  * @param {Array} expectedArgs - array containing the arguments we expect the method to be invoked with
'  * @param {dynamic} returnValue - value that the stub method will return when invoked
'  * @returns {Object} - stub that was wired into the real method
'  */ 
function RBS_BTS_Stub(target, methodName, expectedInvocations = 1, expectedArgs = invalid, returnValue = invalid) as object
    if (m.stubs =invalid)
        m.__stubId = -1
        m.stubs = {}
    end if
    m.__stubId++
      
    if (m.__stubId > 5)
         ? "ERROR ONLY 6 STUBS PER TEST ARE SUPPORTED!!"
         return invalid
    end if
    
    id = stri(m.__mockId).trim()

    fake = m.CreateFake(id, target, methodName, expectedInvocations, expectedArgs, returnValue)
    m.stubs[id] = fake
    if (type(target[methodName]) = "Function" or type(target[methodName]) = "roFunction")
        target[methodName] = fake.callback
        target.__mocks = m.stubs
    else
        ? "ERROR - could not create Stub : method not found  "; target ; "." ; methodName 
    end if
    
    return fake
end function

' /**
'  * @memberof module:BaseTestSuite
'  * @name ExpectOnce
'  * @function
'  * @instance
'  * @description Creates a stub to replace a real method with, which the framework will track. If it was invoked the wrong number of times, or with wrong arguments, it will result in test failure
'  * @param {Object} target - object on which the method to be stubbed is found
'  * @param {String} methodName - name of method to stub
'  * @param {Array} expectedArgs - array containing the arguments we expect the method to be invoked with
'  * @param {dynamic} returnValue - value that the stub method will return when invoked
'  * @returns {Object} - stub that was wired into the real method
'  */ 
function RBS_BTS_ExpectOnce(target, methodName, expectedArgs = invalid, returnValue = invalid) as object
    return m.Mock(target, methodName, 1, expectedArgs, returnValue)
end function 

' /**
'  * @memberof module:BaseTestSuite
'  * @name ExpecTNone
'  * @function
'  * @instance
'  * @description Creates a stub to replace a real method with, which the framework will track. If it was invoked, it will result in test failure
'  * @param {Object} target - object on which the method to be stubbed is found
'  * @param {String} methodName - name of method to stub
'  * @param {Array} expectedArgs - array containing the arguments we expect the method to be invoked with
'  * @param {dynamic} returnValue - value that the stub method will return when invoked
'  * @returns {Object} - stub that was wired into the real method
'  */ 
function RBS_BTS_ExpectNone(target, methodName, expectedArgs = invalid, returnValue = invalid) as object
    return m.Mock(target, methodName, 0, expectedArgs, returnValue)
end function 

' /**
'  * @memberof module:BaseTestSuite
'  * @name Expect
'  * @function
'  * @instance
'  * @description Creates a stub to replace a real method with, which the framework will track. If it was invoked the wrong number of times, or with wrong arguments, it will result in test failure
'  * @param {Object} target - object on which the method to be stubbed is found
'  * @param {String} methodName - name of method to stub
'  * @param {integer} expectedInvocations - number of invocations we expect
'  * @param {Array} expectedArgs - array containing the arguments we expect the method to be invoked with
'  * @param {dynamic} returnValue - value that the stub method will return when invoked
'  * @returns {Object} - stub that was wired into the real method
'  */ 
function RBS_BTS_Expect(target, methodName, expectedInvocations = 1, expectedArgs = invalid, returnValue = invalid) as object
    return m.Mock(target, methodName, expectedInvocations, expectedArgs, returnValue)
end function 

' /**
'  * @memberof module:BaseTestSuite
'  * @name Mock
'  * @function
'  * @instance
'  * @description Creates a stub to replace a real method with, which the framework will track. If it was invoked the wrong number of times, or with wrong arguments, it will result in test failure
'  * @param {Object} target - object on which the method to be stubbed is found
'  * @param {String} methodName - name of method to stub
'  * @param {integer} expectedInvocations - number of invocations we expect
'  * @param {Array} expectedArgs - array containing the arguments we expect the method to be invoked with
'  * @param {dynamic} returnValue - value that the stub method will return when invoked
'  * @returns {Object} - stub that was wired into the real method
'  */ 

function RBS_BTS_Mock(target, methodName, expectedInvocations = 1, expectedArgs = invalid, returnValue = invalid) as object
    if (m.mocks = invalid)
        m.__mockId = -1
        m.mocks = {}
    end if
    m.__mockId++
    
    if (m.__mockId > 5)
         ? "ERROR ONLY 6 MOCKS PER TEST ARE SUPPORTED!! you're on # " ; m.__mockId
         ? " Method was " ; methodName
         return invalid
    end if
    
    id = stri(m.__mockId).trim()
    fake = m.CreateFake(id, target, methodName, expectedInvocations, expectedArgs, returnValue)
    m.mocks[id] = fake 'this will bind it to m
    if (type(target[methodName]) = "Function" or type(target[methodName]) = "roFunction")
        target[methodName] =  m["MockCallback" + id]
        target.__mocks = m.mocks
    else
        ? "ERROR - could not create Mock : method not found  "; target ; "." ; methodName 
    end if
    
    return fake
end function

' /**
'  * @memberof module:BaseTestSuite
'  * @name CreateFake
'  * @function
'  * @instance
'  * @description Creates a stub to replace a real method with. This is used internally.
'  * @param {Object} target - object on which the method to be stubbed is found
'  * @param {String} methodName - name of method to stub
'  * @param {integer} expectedInvocations - number of invocations we expect
'  * @param {Array} expectedArgs - array containing the arguments we expect the method to be invoked with
'  * @param {dynamic} returnValue - value that the stub method will return when invoked
'  * @returns {Object} - stub that was wired into the real method
'  */ 
function RBS_BTS_CreateFake(id, target, methodName, expectedInvocations = 1, expectedArgs =invalid, returnValue=invalid ) as object
    fake = {
        id : id,
        target: target,
        methodName: methodName,
        returnValue: returnValue, 
        isCalled: false,
        invocations: 0,
        invokedArgs: [invalid, invalid, invalid, invalid, invalid, invalid, invalid, invalid, invalid],
        expectedArgs: expectedArgs,
        expectedInvocations: expectedInvocations,
        callback: function (arg1=invalid,  arg2=invalid,  arg3=invalid,  arg4=invalid,  arg5=invalid,  arg6=invalid,  arg7=invalid,  arg8=invalid,  arg9 =invalid)as dynamic
            ? "FAKE CALLBACK CALLED FOR " ; m.methodName 
            m.invokedArgs = [arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9 ] 
            m.isCalled = true
            m.invocations++
            return m.returnValue
        end function
        }
    return fake
end function

' /**
'  * @memberof module:BaseTestSuite
'  * @name AssertMocks
'  * @function
'  * @instance
'  * @description Will check all mocks that have been created to ensure they were invoked the expected amount of times, with the expected args.
'  */ 
function RBS_BTS_AssertMocks() as void
    if (m.__mockId = invalid ) return
    lastId = int(m.__mockId)
    for each id in m.mocks
        mock = m.mocks[id]
        methodName = mock.methodName
        if (mock.expectedInvocations <> mock.invocations)
            m.MockFail(methodName, "Wrong number of calls. (" + stri(mock.invocations).trim() + " / " + stri(mock.expectedInvocations).trim() + ")")
            return
        else if (RBS_CMN_IsArray(mock.expectedArgs))
            for i = 0 to mock.expectedargs.count() -1
                value = mock.invokedArgs[i]
                expected = mock.expectedargs[i]
                if (not m.eqValues(value,expected))
                    m.MockFail(methodName, "Expected arg #" + stri(i).trim() + "  to be '" + RBS_CMN_AsString(expected) + "' got '" + RBS_CMN_AsString(value) + "')")
                    return
                end if
            end for
       end if
    end for
    
    m.CleanMocks()
end function

' /**
'  * @memberof module:BaseTestSuite
'  * @name CleanMocks
'  * @function
'  * @instance
'  * @description Cleans up all tracking data associated with mocks
'  */ 
function RBS_BTS_CleanMocks() as void
    if m.mocks = invalid return
    for each id in m.mocks
        mock = m.mocks[id]
        mock.target.__mocks = invalid
    end for
    m.mocks = invalid
end function

' /**
'  * @memberof module:BaseTestSuite
'  * @name CleanStubs
'  * @function
'  * @instance
'  * @description Cleans up all tracking data associated with stubs
'  */ 
function RBS_BTS_CleanStubs() as void
    if m.stubs = invalid return
    for each id in m.stubs
        stub = m.stubs[id]
        stub.target.__stubs = invalid
    end for
    m.stubs = invalid
end function


Function RBS_BTS_MockFail(methodName, message) as boolean
    if (m.currentResult.isFail) then return false ' skip test we already failed
    m.currentResult.AddResult("mock failure on '" + methodName + "' : "  + message)
    return false
End Function


'+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
'++ Fake Stub callback functions - this is required to get scope
'+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

function RBS_BTS_StubCallback0(arg1=invalid,  arg2=invalid,  arg3=invalid,  arg4=invalid,  arg5=invalid,  arg6=invalid,  arg7=invalid,  arg8=invalid,  arg9 =invalid)as dynamic
    fake = m.__Stubs["0"]
    return fake.callback(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
end function

function RBS_BTS_StubCallback1(arg1=invalid,  arg2=invalid,  arg3=invalid,  arg4=invalid,  arg5=invalid,  arg6=invalid,  arg7=invalid,  arg8=invalid,  arg9 =invalid)as dynamic
    fake = m.__Stubs["1"]
    return fake.callback(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
end function

function RBS_BTS_StubCallback2(arg1=invalid,  arg2=invalid,  arg3=invalid,  arg4=invalid,  arg5=invalid,  arg6=invalid,  arg7=invalid,  arg8=invalid,  arg9 =invalid)as dynamic
    fake = m.__Stubs["2"]
    return fake.callback(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
end function


function RBS_BTS_StubCallback3(arg1=invalid,  arg2=invalid,  arg3=invalid,  arg4=invalid,  arg5=invalid,  arg6=invalid,  arg7=invalid,  arg8=invalid,  arg9 =invalid)as dynamic
    fake = m.__Stubs["3"]
    return fake.callback(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
end function


function RBS_BTS_StubCallback4(arg1=invalid,  arg2=invalid,  arg3=invalid,  arg4=invalid,  arg5=invalid,  arg6=invalid,  arg7=invalid,  arg8=invalid,  arg9 =invalid)as dynamic
    fake = m.__Stubs["4"]
    return fake.callback(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
end function


function RBS_BTS_StubCallback5(arg1=invalid,  arg2=invalid,  arg3=invalid,  arg4=invalid,  arg5=invalid,  arg6=invalid,  arg7=invalid,  arg8=invalid,  arg9 =invalid)as dynamic
    fake = m.__Stubs["5"]
    return fake.callback(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
end function

'+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
'++ Fake Mock callback functions - this is required to get scope
'+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

function RBS_BTS_MockCallback0(arg1=invalid,  arg2=invalid,  arg3=invalid,  arg4=invalid,  arg5=invalid,  arg6=invalid,  arg7=invalid,  arg8=invalid,  arg9 =invalid)as dynamic
    fake = m.__mocks["0"]
    return fake.callback(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
end function

function RBS_BTS_MockCallback1(arg1=invalid,  arg2=invalid,  arg3=invalid,  arg4=invalid,  arg5=invalid,  arg6=invalid,  arg7=invalid,  arg8=invalid,  arg9 =invalid)as dynamic
    fake = m.__mocks["1"]
    return fake.callback(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
end function

function RBS_BTS_MockCallback2(arg1=invalid,  arg2=invalid,  arg3=invalid,  arg4=invalid,  arg5=invalid,  arg6=invalid,  arg7=invalid,  arg8=invalid,  arg9 =invalid)as dynamic
    fake = m.__mocks["2"]
    return fake.callback(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
end function


function RBS_BTS_MockCallback3(arg1=invalid,  arg2=invalid,  arg3=invalid,  arg4=invalid,  arg5=invalid,  arg6=invalid,  arg7=invalid,  arg8=invalid,  arg9 =invalid)as dynamic
    fake = m.__mocks["3"]
    return fake.callback(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
end function


function RBS_BTS_MockCallback4(arg1=invalid,  arg2=invalid,  arg3=invalid,  arg4=invalid,  arg5=invalid,  arg6=invalid,  arg7=invalid,  arg8=invalid,  arg9 =invalid)as dynamic
    fake = m.__mocks["4"]
    return fake.callback(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
end function


function RBS_BTS_MockCallback5(arg1=invalid,  arg2=invalid,  arg3=invalid,  arg4=invalid,  arg5=invalid,  arg6=invalid,  arg7=invalid,  arg8=invalid,  arg9 =invalid)as dynamic
    fake = m.__mocks["5"]
    return fake.callback(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
end function



'+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
'++ Utility functions! 
'+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

'*************************************************************
'** ripped and adapted from rodash - thanks @veeta!
'** used by get method - consider thsis private
'*************************************************************
Function RBS_BTS_rodash_pathsAsArray_(path)
    pathRE = CreateObject("roRegex", "\[([0-9]+)\]", "i")
    segments = []
    if type(path) = "String" or type(path) = "roString"
        dottedPath = pathRE.replaceAll(path, ".\1")
        stringSegments = dottedPath.tokenize(".")
        for each s in stringSegments
            if (Asc(s) >= 48) and (Asc(s) <= 57)
                segments.push(s.toInt())
            else
                segments.push(s)
            end if
        end for
    else if type(path) = "roList" or type(path) = "roArray"
        stringPath = ""
        for each s in path
            stringPath = stringPath + "." + Box(s).toStr()
        end for
        segments = m.pathAsArray_(stringPath)
    else
        segments = invalid
    end if
    return segments
End Function

' /**
'  * @memberof module:BaseTestSuite
'  * @name g
'  * @function
'  * @instance
'  * @description ripped and adapted from rodash - thanks @veeta!
'  * use this method to safely get anything. useful for when unit testing a collection
'  * or something and you're not sure if it's gonna crash!
'  * @param {dynamic} aa - node, array or assoArray
'  * @param {dynamic} subset - the items to check for
'  * @param {String} path -as string path to target field. Can use .0. or [0] index notation e.g. "children.0.title" or "children[0].title"
'  * @returns {dynamic} - matched item, on aa at path
' */

Function RBS_BTS_rodash_get_(aa, path, default=invalid)
    if type(aa) <> "roAssociativeArray" and type(aa) <> "roArray" and type(aa) <> "roSGNode" then return default
    segments = m.pathAsArray_(path)

    if (Type(path) = "roInt" or Type(path) = "roInteger" or Type(path) = "Integer")
        path = stri(path).trim()
    end if
        
    if segments = invalid then return default
    result = invalid

    while segments.count() > 0
        key = segments.shift()
        if (type(key) = "roInteger") 'it's a valid index
            if (aa <> invalid and GetInterface(aa, "ifArray") <> invalid)
                value = aa[key]
            else if (aa <> invalid and GetInterface(aa, "ifSGNodeChildren") <> invalid)
                value = aa.getChild(key)
            else if (aa <> invalid and GetInterface(aa, "ifAssociativeArray") <> invalid)
                key = tostr(key)
                if not aa.doesExist(key)
                    exit while
                end if
        
                value = aa.lookup(key)
            else 
                value = invalid
            end if
        else
            if not aa.doesExist(key)
                exit while
            end if
        
            value = aa.lookup(key)
        end if
        
        if segments.count() = 0
            result = value
            exit while
        end if
        
        if type(value) <> "roAssociativeArray" and type(value) <> "roArray" and type(value) <> "roSGNode"
            exit while
        end if
        aa = value
    end while

    if result = invalid then return default
        return result
End Function