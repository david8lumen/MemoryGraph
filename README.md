# MemoryGraph
This application builds a memory graph of the app on which it is running on. The final graph represents relations between the various type of objects.

# Limitations
* The current version does not support macOS apps and pure swift objects
* Actual for iOS SDK 14.4 and lower and it is not guaranteed that the further  SDK releases won't affect the application's stability
* NSMallocBlocks objects are not represented in the graph

# Resources
Some of the approaches were taken from but not limited to these sources:
* [FLEX](https://github.com/FLEXTool/FLEX) - a set of in-app debugging and exploration tools for iOS development
* [Heap Find](https://opensource.apple.com/source/lldb/lldb-112/examples/darwin/heap_find/heap_find.c.auto.html) - Apple's (C++) open-source heap find implementation
* [Valid Objective-C object](https://blog.timac.org/2016/1124-testing-if-an-arbitrary-pointer-is-a-valid-objective-c-object/) an explanation of how to verify arbitrary pointers are valid Objective-C objects
* [Meta-class in Objective-C](https://www.cocoawithlove.com/2010/01/what-is-meta-class-in-objective-c.html) Classes under the hood
* [Non-pointer isa](http://www.sealiesoftware.com/blog/archive/2013/09/24/objc_explain_Non-pointer_isa.html) an explanation of changes to the isa field on iOS for arm64
* [macOS Internals](https://www.amazon.com/Mac-OS-Internals-Approach-paperback/dp/0134426541) the book that dissects the internals of the macOS systems
