# olx-client

[![License](https://img.shields.io/cocoapods/l/ElasticTransition.svg?style=flat)](http://cocoapods.org/pods/ElasticTransition)
[![Platform](https://img.shields.io/cocoapods/p/ElasticTransition.svg?style=flat)](http://cocoapods.org/pods/ElasticTransition)

This is a iOS client written with Swift 3.0 which request data from OLX API. It lists latest published items.
This app provides support to iOS 9, so used SDK features are restricted by that.

Some implementation notes:


## Data

- CoreDataStack: It simplifies the access to Core Data framework. It also tries to mimic NSPersistentContainer class added in iOS 10, so when support to iOS 9 is cut, the transition will be much easier. It has two contexts: View context which is a read-only context used to present data in the UI and Background Context used to execute background operations (like mapping server responses with local objects and save operations).

- Core Data classes were generated using Xcode generator tool. I rather use [mogenerator](https://github.com/rentzsch/mogenerator). In the future NSManagedObject classes can be generated via [mogenerator](https://github.com/rentzsch/mogenerator) and modify the template to include basic operations like: find, count, isEmpty, etc.

- FileSystemHelper: Simplifies access to the file system.

## Networking

- OLXAPIManager: Requests data to OLX API and matches the response with the local data structure. It provides offline support via Core Data.

- For JSON/CoreData mapping I haven’t used any third party library like Gloss because I rather use optional binding, this can be automated in the future using [mogenerator](https://github.com/rentzsch/mogenerator).

- NetworkHelper: This class abstract the app from [Alamofire](https://github.com/Alamofire/Alamofire), so if in the future we move to another networking library, replace it will be very simple.

## View

- ItemsViewController: Presents the list of items using NSFetchedResultsController. It supports loading Next page and Pull to request, also Portrait and Landscape orientations and the cells height is updated to current content using Self-Sizing cells.

- UIRemoteImageView: It’s an UIImageView subclass where you can set a remote URL and the content will be download and cached automatically. If the image was already downloaded, the cache content will be presented. Cached images are stored in Caches folder. This class can be improved by adding custom styles for loading, no image and error states.
