//
//  ContentView.swift
//  babyTracker2
//
//  Created by Micah Johsnon on 6/15/23.
//

import SwiftUI
//import MongoSwiftSync
//import MongoSwift
//import NIOPosix
import RealmSwift


let app = App(id: "babytracker-fzeej")
let ownerId = "123"



class Shopping1: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var cost: String = ""
    @Persisted var dateString: String = ""
    @Persisted var item: String = ""
    @Persisted var ownerId: String = ""
    @Persisted var size: String = ""
}

 
class Shopping: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var item: String = ""
    @Persisted var cost: String = ""
    @Persisted var size: String = ""
//    @Persisted var dateString: String = "\(Date())"
    @Persisted var dateString: String = dateFormatter()
    @Persisted var ownerId: String = ""
    convenience init( item: String, size: String, cost: String, ownerId: String ) {
        self.init()
        self.item = item
        self.ownerId = ownerId
        self.cost = cost
        self.size = size
       self.dateString = dateString
   }
}

class Feeding : Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var method: String = ""
    @Persisted var volume: Int = 0
    @Persisted var ownerId: String = ""
    @Persisted var dateString: String = dateFormatter()
    convenience init( method: String, volume: Int, ownerId: String) {
        self.init()
        self.method = method
        self.volume = volume
        self.ownerId = ownerId
        self.dateString = dateString
    }
}

class Todo: Object {
   @Persisted(primaryKey: true) var _id: ObjectId
   @Persisted var name: String = ""
   @Persisted var status: String = ""
   @Persisted var dateString: String = ""
   @Persisted var ownerId: String = ""
    convenience init(name: String, ownerId: String, dateString: String) {
       self.init()
       self.name = name
       self.ownerId = ownerId
   }
}

class Diaper: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var soiled: String = ""
    @Persisted var wipes: Int = 0
    @Persisted var ownerId: String = ""
    @Persisted var dateString: String = dateFormatter()
    convenience init( method: String, volume: Int, ownerId: String) {
        self.init()
        self.soiled = soiled
        self.wipes = wipes
        self.ownerId = ownerId
        self.dateString = dateString
    }
}

func deleteRealm() async {
    do {
//        let app = App(id: app)
        let user = try await app.login(credentials: Credentials.anonymous)
        var configuration = user.flexibleSyncConfiguration()
        _ = try Realm.deleteFiles(for: configuration)
    } catch {
        // handle error
        print("it's all effed up now")
    }
}

enum Collections {
    case feedings, shopping
}

struct GrowingButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: 200)
            .padding()
            .background(.blue)
            .foregroundStyle(.white)
//            .clipShape(Capsule())
//            .clipShape(RoundedRectangle().cornerRadius(radius:18, corners:[.topLeft,.bottomRight]))
            .clipShape(RoundedRectangle(cornerRadius: 15))
            
//            .clipShape(rec)
//            .fixedSize(horizontal: true, vertical: false)
//            .frame(minWidth: 500)
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.easeOut(duration: 0.5), value: configuration.isPressed)
    }
}


func dateFormatter() -> String {
    let originalFormatter = DateFormatter()
    originalFormatter.locale = Locale(identifier: "en_US_POSIX")
    originalFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZZ"
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    dateFormatter.dateFormat = "MMMM dd, yyyy"
//    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZZ"
    let timeFormatter = DateFormatter()
    timeFormatter.locale = Locale(identifier: "en_US_POSIX")
    timeFormatter.dateFormat = "HH:mma"
    timeFormatter.amSymbol = "am"
    timeFormatter.pmSymbol = "pm"
//    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXXXX"
    var dateString:String = "\(String(describing: dateFormatter.date(from: "\(Date())")))"
    let date = dateFormatter.string(from:Date())
    let time = timeFormatter.string(from: Date())
    dateString = dateFormatter.string(from:Date()) + " " +     timeFormatter.string(from: Date())
    dateString = date + " at " + time
    return dateString
}

class PurchaseClass: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
//    @Persisted var date: String = "\(Date())"
    @Persisted var date: String = "\(Date())"
    @Persisted var size: String = ""
    @Persisted var cost: String = ""
    @Persisted var ownerID: String
    convenience init(size : String, cost: String) {
        self.init()
        self.ownerID = ownerID
    }
}

func loginAsync() async -> User {
    do {
        let user = try await app.login(credentials: Credentials.anonymous)
        print("Successfully logged in user: \(user)")
        await openSyncedRealm(user: user)
        return user
    } catch {
        print("Error logging in: \(error.localizedDescription)")
        let user = try! await app.login(credentials: Credentials.anonymous)
        return user
    }
    
}

//func realmObeserver(option: String, object : realmo) {
//    if option == "open" {
//        let notificationToken = object.observe { (changes) in
//            switch changes {
//            case .initial: break
//                // Results are now populated and can be accessed without blocking the UI
//            case .update(_, let deletions, let insertions, let modifications):
//                // Query results have changed.
//                print("Deleted indices: ", deletions)
//                print("Inserted indices: ", insertions)
//                print("Modified modifications: ", modifications)
//            case .error(let error):
//                // An error occurred while opening the Realm file on the background worker thread
//                fatalError("\(error)")
//            }
//        }
//
//    } else if option == "close" {
//
//    }
//}


@MainActor
    func openPurchaseRealm() async {
        
    }
//struct PurchaseSet: Codable {
//    let date: Date
//    let size: String
//    let cost: String
//    let item: String


func login() -> User {
    var syncUser: User?
    app.login(credentials: Credentials.anonymous) { result in
        switch result {
        case .success(let user):
            syncUser = user
        case .failure(let error):
            print(error.localizedDescription)
        }
//        if let userObject = syncUser  {
//            print("userObject created")
//            return userObject
//        } else {
//            print("userObject Failure")
//        }
        
    }
    return syncUser._rlmInferWrappedType()
}
    

@MainActor
func useRealm(_ realm: Realm, _ user: User, _ entry: Dictionary<String, Any>? = nil, collection : Collections?) {
    print("collection = ",collection)
    // Add some tasks
//    switch entry {
//    case nil :  try! realm.write{realm.add(Shopping(item: "sleep", size: "any", cost: "everything", ownerId: user.id))}
//    default:  try! realm.write{realm.add(Shopping(item: entry?["item"] as! String, size: entry?["size"] as! String, cost: entry?["cost"] as! String, ownerId: user.id))}
//    }
//    let purchase = Shopping(item: "sleep", size: "any", cost: "everything", ownerId: user.id)
    print("useRealm Shopping")
    if let entry {
        print("ENTRY PRESENT")
        print(entry)
    }
//    let todo = Todo(name: "Do laundry", ownerId: user.id,dateString: "\(Date())")
//    let purchase = PurchaseClass(size: "big", cost: "a lot")
    switch collection {
    case .feedings:
        print("FEEDME")
        let targetObjectType = Feeding.self
        if let entry {
            let post = Feeding(method: entry["method"] as! String, volume: entry["volume"] as! Int, ownerId: user.id)
            print(post)
            try! realm.write{realm.add(Feeding(method: entry["method"] as! String, volume: entry["volume"] as! Int, ownerId: user.id))}
        } else {
            let post = Feeding(method: "bottle", volume: 0, ownerId: user.id)
            print(post)
            try! realm.write{realm.add(Feeding(method: "bottle", volume: 0, ownerId: user.id))}
        }
        let results = realm.objects(targetObjectType)
        let notificationToken = results.observe { (changes) in
            switch changes {
            case .initial:
                print("Initial")
                break
                // Results are now populated and can be accessed without blocking the UI
            case .update(_, let deletions, let insertions, let modifications):
                // Query results have changed.
                print("Deleted indices: ", deletions)
                print("Inserted indices: ", insertions)
                print("Modified modifications: ", modifications)
            case .error(let error):
                // An error occurred while opening the Realm file on the background worker thread
                fatalError("\(error)")
            }}
        var targetString = "\(targetObjectType)"
            queryRealm(realm: realm, objectType: targetString)
            notificationToken.invalidate()
//
//    case nil:
//        print("NIL FOOD")
//        let targetObjectType = Shopping.self
//        if let entry {
//            try! realm.write{realm.add(Shopping(item: entry["item"] as! String, size: entry["size"] as! String, cost: entry["cost"] as! String, ownerId: user.id))}
//        } else {
//            try! realm.write{realm.add(Shopping(item: entry?["item"] as! String, size: entry?["size"] as! String, cost: entry?["cost"] as! String, ownerId: user.id))}
//        }
//        let results = realm.objects(targetObjectType)
//        let notificationToken = results.observe { (changes) in
//            switch changes {
//            case .initial:
//                print("Initial")
//                break
//                // Results are now populated and can be accessed without blocking the UI
//            case .update(_, let deletions, let insertions, let modifications):
//                // Query results have changed.
//                print("Deleted indices: ", deletions)
//                print("Inserted indices: ", insertions)
//                print("Modified modifications: ", modifications)
//            case .error(let error):
//                // An error occurred while opening the Realm file on the background worker thread
//                fatalError("\(error)")
//            }}
//            queryRealm(realm: realm)
//            notificationToken.invalidate()
        
    default:
        print("DONT GIMME FOOD")
        print(collection)
        let targetObjectType = Shopping.self
        if let entry {
            print("entry for shopping is...",entry)
            let postMe = Shopping(item: entry["item"] as! String, size: entry["size"] as! String, cost: entry["cost"] as! String, ownerId: user.id)
            print(postMe)
            try! realm.write{realm.add(Shopping(item: entry["item"] as! String, size: entry["size"] as! String, cost: entry["cost"] as! String, ownerId: user.id))}
        } else {
            print(entry)
            try! realm.write{realm.add(Shopping(item: "blank", size: "blank", cost: "cost", ownerId: user.id))}
        }
        let results = realm.objects(targetObjectType)
        let notificationToken = results.observe { (changes) in
            switch changes {
            case .initial:
                print("Initial")
                break
                // Results are now populated and can be accessed without blocking the UI
            case .update(_, let deletions, let insertions, let modifications):
                // Query results have changed.
                print("Deleted indices: ", deletions)
                print("Inserted indices: ", insertions)
                print("Modified modifications: ", modifications)
            case .error(let error):
                // An error occurred while opening the Realm file on the background worker thread
                fatalError("\(error)")
            }}
        var targetString = "\(targetObjectType)"
            queryRealm(realm: realm,objectType: targetString)
            notificationToken.invalidate()
        }
        
    
//    if collection == Collections.feedings {
//        let targetObj = Feeding.self
//        if let entry {
//            print("feeding entry",entry)
//            let feed = Feeding(method: entry["method"] as! String, volume: entry["volume"] as! Int, ownerId: user.id)
//            try! realm.write {
//                realm.add(feed)
//            }
//        } else {
//            print("no entry")
//            let feed = Feeding(method: "bottle", volume: 0, ownerId: user.id)
//            try! realm.write {
//                realm.add(feed)
//            }
////            finish the feedings stuff
//        }
    //    print("Realm is located at:", realm.configuration.fileURL!)
    //    try! realm.write {
    ////        realm.add(todo)
    //        realm.add(purchase)
    //    }
    //    let todos = realm.objects(Todo.self)
//        let results = realm.objects(Feeding.self)
////    } else {
////        let targetObj = Shopping.self
////
////    }
//
//    if let entry {
//        print("entry",entry)
//        let purchase = Shopping(item: entry["item"] as! String, size: entry["size"] as! String, cost: entry["cost"] as! String, ownerId: user.id)
//        try! realm.write {
//            realm.add(purchase)
//        }
//    } else {
//        print("no entry")
//        let purchase = Shopping(item: "sleep", size: "any", cost: "everything", ownerId: user.id)
//        try! realm.write {
//            realm.add(purchase)
//        }
//    }
////    print("Realm is located at:", realm.configuration.fileURL!)
////    try! realm.write {
//////        realm.add(todo)
////        realm.add(purchase)
////    }
////    let todos = realm.objects(Todo.self)
//    let purchases = realm.objects(Shopping.self)
////    print(purchases)
//    let notificationToken = purchases.observe { (changes) in
//        switch changes {
//        case .initial:
//            print("Initial")
//            break
//            // Results are now populated and can be accessed without blocking the UI
//        case .update(_, let deletions, let insertions, let modifications):
//            // Query results have changed.
//            print("Deleted indices: ", deletions)
//            print("Inserted indices: ", insertions)
//            print("Modified modifications: ", modifications)
//        case .error(let error):
//            // An error occurred while opening the Realm file on the background worker thread
//            fatalError("\(error)")
//        }
//    }
//
//    queryRealm(realm: realm)
//    notificationToken.invalidate()
}


@MainActor
func useRealm1(_ realm: Realm, _ user: User) {
    // Add some tasks
    print("useRealm1 Todo")
    let todo = Todo(name: "Do laundry", ownerId: user.id,dateString: "\(Date())")
//    let purchase = PurchaseClass(size: "big", cost: "a lot")
//    let purchase = Shopping(item: "sleep", size: "any", cost: "everything", ownerId: "Big MJ")
//    print("Realm is located at:", realm.configuration.fileURL!)
    try! realm.write {
        realm.add(todo)
//        realm.add(purchase)
    }
    let todos = realm.objects(Todo.self)
//    let purchases = realm.objects(Shopping.self)
    print(todos)
    let notificationToken = todos.observe { (changes) in
        switch changes {
        case .initial:
            print("Initial")
            break
            // Results are now populated and can be accessed without blocking the UI
        case .update(_, let deletions, let insertions, let modifications):
            // Query results have changed.
            print("Deleted indices: ", deletions)
            print("Inserted indices: ", insertions)
            print("Modified modifications: ", modifications)
        case .error(let error):
            // An error occurred while opening the Realm file on the background worker thread
            fatalError("\(error)")
        }
    }
    notificationToken.invalidate()
}

@MainActor
func writeToLocalRealm(name:String) {
    let todo = Todo(name: name, ownerId: "String", dateString: "\(Date())")
    let shops = Shopping(item: "food", size: "lot", cost: "time", ownerId: "Big MJ")
    let realm = try! Realm()
    let todos = realm.objects(Todo.self)
    print("write to local",todos)
    try! realm.write {
        realm.add(todo)
        realm.add(shops)
        //    }
    }
    print("wrote to local")
}


func handleClientReset() {
    // Report the client reset error to the user, or do some custom logic.
    print("!! -- automatic client reset FAILED -- !!")
//    SyncSession.immediatelyHandleError(<#T##token: RLMSyncErrorActionToken##RLMSyncErrorActionToken#>, syncManager: <#T##RLMSyncManager#>)
}

@MainActor
func openSyncedRealm(user: User) async {
    print("openSyncedRealm")
    do {
        var config = user.flexibleSyncConfiguration(clientResetMode: .discardUnsyncedChanges())
//        var config = Realm.Configuration.defaultConfiguration
        config.objectTypes = [Todo.self,Shopping.self]
        app.syncManager.errorHandler = { error, session in
                guard let syncError = error as? SyncError else {
                    fatalError("Unexpected error type passed to sync error handler! \(error)")
                }
                switch syncError.code {
                case .clientResetError:
                    if let (path, clientResetToken) = syncError.clientResetInfo() {
                        handleClientReset()
                        SyncSession.immediatelyHandleError(clientResetToken, syncManager: app.syncManager)
                    }
                default:
                    // Handle other errors...
                    ()
                }
            }
//        config.syncConfiguration?.user.flexibleSyncConfiguration()
//        config.objectTypes = [Todo.self]
//        print("openSync0: config","\(config.objectTypes)")
        @AsyncOpen(appId: "babytracker-fzeej", timeout: 4000) var asyncOpen
        let realm = try await Realm(configuration: config, downloadBeforeOpen: .always)
        print("realm")
        let subscriptions = realm.subscriptions
        print("subscriptions - open 'realm'")
        
        try await subscriptions.update {
            subscriptions.append(
                QuerySubscription<Todo> {
                $0.ownerId == user.id
            })}
        print("tried subs")
        useRealm1(realm, user)
        print("todo")
        print("shopping")
//        try await useRealm1(realm, user)
        print("used realm")
    } catch {
        print("Error opening realm: \(error.localizedDescription)")
    }
}

@MainActor
func makeRealm(user: User, collection: Collections?) async -> Any {
//    let user = login()
    do {
        var config = user.flexibleSyncConfiguration(clientResetMode: .discardUnsyncedChanges())
        config.objectTypes = [Shopping.self,Todo.self,Feeding.self]
        app.syncManager.errorHandler = { error, session in
                guard let syncError = error as? SyncError else {
                    fatalError("Unexpected error type passed to sync error handler! \(error)")
                }
                switch syncError.code {
                case .clientResetError:
                    if let (path, clientResetToken) = syncError.clientResetInfo() {
                        handleClientReset()
                        SyncSession.immediatelyHandleError(clientResetToken, syncManager: app.syncManager)
                    }
                default:
                    // Handle other errors...
                    ()
                }
            }
//        print("configged opensync1 - \(config.objectTypes)")
//        print("shopping.self")
        @AsyncOpen(appId: "babytracker-fzeej", timeout: 4000) var asyncOpen
        let realm = try await Realm(configuration: config, downloadBeforeOpen: .always)
        let subscriptions = realm.subscriptions
        print("did something with subscriptions for 'realm1'")
        if collection == Collections.feedings {
            try await subscriptions.update {
                subscriptions.append(
                    QuerySubscription<Feeding> {
                        $0.ownerId == user.id
                    })
            }
        } else {
            try await subscriptions.update {
                subscriptions.append(
                    QuerySubscription<Shopping> {
                        $0.ownerId == user.id
                    })
            }
            
        }
        return realm
    } catch {
        print("Error opening realm: \(error.localizedDescription)")
        return "failed"
    }
}


@MainActor
func openSyncedRealm1(user: User, entry: Dictionary<String,Any>?=nil, collection: Collections? = nil) async -> Any {
    print("opened openSyncedRealm")
    if let entry {
        print("entry is....",entry)
    }
    do {
        var config = user.flexibleSyncConfiguration(clientResetMode: .discardUnsyncedChanges())
        config.objectTypes = [Shopping.self,Todo.self,Feeding.self]
        app.syncManager.errorHandler = { error, session in
                guard let syncError = error as? SyncError else {
                    fatalError("Unexpected error type passed to sync error handler! \(error)")
                }
                switch syncError.code {
                case .clientResetError:
                    if let (path, clientResetToken) = syncError.clientResetInfo() {
                        handleClientReset()
                        SyncSession.immediatelyHandleError(clientResetToken, syncManager: app.syncManager)
                    }
                default:
                    // Handle other errors...
                    ()
                }
            }
        print("configged opensync1 - \(config.objectTypes)")
        print("shopping.self")
        @AsyncOpen(appId: "babytracker-fzeej", timeout: 4000) var asyncOpen
        let realm = try await Realm(configuration: config, downloadBeforeOpen: .always)
        // You must add at least one subscription to read and write from a Flexible Sync realm
        print("remote config")
//        writeToLocalRealm(name: "BigMJ")
//        useRealm(realm, user)
        let subscriptions = realm.subscriptions
        print("did something with subscriptions for 'realm1'")
        if collection == Collections.feedings {
            try await subscriptions.update {
                subscriptions.append(
                    QuerySubscription<Feeding> {
                        $0.ownerId == user.id
                    })
            }
        } else {
            try await subscriptions.update {
                subscriptions.append(
                    QuerySubscription<Shopping> {
                        $0.ownerId == user.id
                    })
            }
            
        }
        //        let useRealm = try! Realm(realm: realm, user: user)
        print("updated subs -- shopping")
        if let entry {
            print("Entry",entry)
            try await useRealm(realm, user, entry, collection: collection)
        } else {
            try await useRealm(realm, user,collection: collection)
        }
        print("usedrealm")
        print("Realmedout")
        var objectType: String
        switch collection {
        case .feedings: objectType = "Feeding.self"
        case .shopping: objectType = "Shopping.self"
        default: objectType = "Shopping.self"
        }
        print("OPENSYNCEDREALM1 OBJECT TYPE:",objectType)
        return queryRealm(realm: realm, objectType: objectType)
        
        //        await useRealm
    } catch {
        print("Error opening realm: \(error.localizedDescription)")
        return "failed"
    }
       
    
}

func queryRealm(realm : Realm, objectType: String) -> Object {
//    var objectType1: RealmOptionalType
    //    switch objectType {
    //    case "Feeding.self": objectType1 = Feeding.self as! any RealmOptionalType
    //    default: objectType1 = Shopping.self as! any RealmOptionalType
    //    }
    //    var objectTypeUsed: AnyObject
    if objectType == "Feeding.Type" {
        let query = realm.objects(Feeding.self)
        print("OBJECT TYPE",objectType,"feed")
        let results = query//.where {$0.volume != 0}
//        print("Results.last: -> ",results.last,"\n\n",results.count,"\n",results.last?.dateString)
        print(results,query)
        if results.count >= 3 {
            let unwrappedResult = results[results.count-2]
            //            return results[results.count-2]}
            return unwrappedResult}
        if results.last == nil {
            let unwrappedResult = Feeding(method: "error", volume: 0, ownerId: login().id)
//            return results.last ?? Feeding(method: "error", volume: 0, ownerId: login().id)
            return unwrappedResult
        } else {
            var unwrappedResult: Feeding
//            if results.last != nil {
                unwrappedResult = results.last ?? Feeding(method: "error", volume: 0, ownerId: login().id)
                return unwrappedResult
        }
    } else {
        let query = realm.objects(Shopping.self)
        print("OBJECT TYPE",objectType,"shop")
        let results = query.where {$0.item != ""}
        print("Results.last: -> ",results.last,"\n\n",results.count,"\n",results[results.count-1].dateString,results.last?.dateString)
        //    print("Results[0] may be the latest one. -> \n",results[0])
        //    var i = 1
        //    for result in results.suffix(10) {
        //        print(i, result.item, result.dateString)
        //        i += 1
        //    }
        //    return "\(results.last)"
//        return results.last
//        return results[0]
        if results.count >= 3 {
            let unwrappedResult: Shopping = results[results.count-2]
            //            return results[results.count-2]}
            return unwrappedResult}
        else {
            let unwrappedResult: Shopping = (results.last ?? Shopping(item: "error", size: "error", cost: "error", ownerId: "error"))
//            return results.last as Shopping ?? Shopping(item: "error", size: "error", cost: "error", ownerId: "error")
            return unwrappedResult
        }
    }
}

func queryFeedRealm(realm : Realm) -> Feeding? {
    let query = realm.objects(Feeding.self)
    let results = query.where {$0.volume != 0}
    print("Results.last: -> ",results.last,"\n\n",results.count,"\n",results[results.count-1].dateString,results.last?.dateString)
//    print("Results[0] may be the latest one. -> \n",results[0])
//    var i = 1
//    for result in results.suffix(10) {
//        print(i, result.item, result.dateString)
//        i += 1
//    }
//    return "\(results.last)"
    return results.last
}


func realmTime() -> String {
    let realm = try! Realm()
    let todo = Todo(name: "Do laundry", ownerId: "123", dateString: "\(Date())")
    try! realm.write {
        realm.add(todo)
    }
    let todos = realm.objects(Todo.self)
    print(todos)
    let todosInProgress = todos.where {
        $0.status == "InProgress"
    }
    print("A list of all todos in progress: \(todosInProgress)")
    let result : String = "\(todos)"
//    return result
//}


//func observerWatch() {
    let notificationToken = todos.observe { (changes) in
        switch changes {
        case .initial: break
            // Results are now populated and can be accessed without blocking the UI
        case .update(_, let deletions, let insertions, let modifications):
            // Query results have changed.
            print("Deleted indices: ", deletions)
            print("Inserted indices: ", insertions)
            print("Modified modifications: ", modifications)
        case .error(let error):
            // An error occurred while opening the Realm file on the background worker thread
            fatalError("\(error)")
        }
    }
    notificationToken.invalidate()
    return result
}


struct PurchaseSet: Codable {
    let date: Date
    let size: String
    let cost: String
    let item: String
}

func dateToString(date: Date) -> String {
    let today = Date.now
    let dateFormatter = DateFormatter()
    let timeFormatter = DateFormatter()
    let dateFormat = "EEEE, MMM d, yyyy"
    let timeFormat = "HH:mm a"
//    dateFormatter.dateFormat = "HH:mm a E, on d MMM y"
    dateFormatter.dateFormat = dateFormat
//    timeFor
    let stringConstruct = dateFormatter.string(from: date)
//    let stringContstruct = timeFormat + " on " + dateFormat
    print(dateFormatter.string(from: today))
    print(stringConstruct)
    return stringConstruct
}



struct ContentView: View {
    
    @State var stringButton: String = "ClickMe"
    @State var stringChange: Bool = false
    @State var dummyText: String = "Result Placeholder"
    
//    let dbee = client.db("babylist")
    @State var clicked: Bool = false
    @State var showPurchases: Bool = false
    @State var showFeedings: Bool = false
    @State var showDiapers: Bool = false
    @State var selectedFlavor: Flavor = .chocolate
    enum Flavor: String, CaseIterable, Identifiable {
        case chocolate, vanilla, strawberry
        var id: Self { self }
    }

//    DIAPERS
    @State var diaperDirty: Soiled = .pee
    enum Soiled: String, CaseIterable, Identifiable {
        case pee, poop, both
        var id: Self { self }
    }
    @State var diaperPoop: Poop = .no
    enum Poop: String, CaseIterable, Identifiable {
        case yes, no
        var id: Self { self }
    }
    @State var diaperWipes: Wipes = .na
    enum Wipes: String, CaseIterable, Identifiable {
        case one, two, three, four, na
        var id: Self { self }
    }
    
    
// Purchases
    @State var purchaseItem: Bought = .diaper
    enum Bought:String, CaseIterable, Identifiable {
        case diaper, wipes, water, formula, other
        var id: Self {self}
    }
    @State var purchaseSize = ""
    @State var purchaseCost = ""
    
    
// Feedings
    @State var feedingsMethod: Apparatus = .bottle
    enum Apparatus:String, CaseIterable, Identifiable {
        case bottle, tiddy
        var id: Self {self}
    }
    @State var feedingsVolume: Int = 0
    @State var feedingsTiddy : Bool = false
    
    @State var collectionName = ""
    @State var labelText = "Select an option"
    
    @State var feedText: String = ""
    @State var diaperText: String = ""
    
    @FocusState private var focusedField: FormField?
    enum FormField {
        case purchaseItem, purchaseSize, purchaseCost
    }
    
    init () {
        self.showDiapers = false
        self.showFeedings = false
        self.showPurchases = false
    }
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Group {
                if clicked {
                    let ourString = String("Clicked it")
                    Text(ourString)
                    
                } else {
                    let ourString = String("Hey there, world!")
                    Text(ourString)
                    
                }
            }
            LazyVStack {
            Button("delete realm files")
            {
                Task{
                    try! await deleteRealm()
                }
            }
            
            Button("1 - ToDo. \(stringButton)") {
                clicked.toggle()
                Task {
                    let user1 = try await app.login(credentials: Credentials.anonymous)
                    //                    writeToLocalRealm(name: "Shiddddddddddddddd")
                    stringButton = "\(user1)"
                    print("logged in and made user",user1)
                    do {
                        ////                        let realm = try await Realm()
                        //                        let rerealm = try await openSyncedRealm1(user: user1)
                        try await openSyncedRealm(user: user1)
                        print("1.. we reaLmed") //}
                    } catch {
                        print("2.. realm ain't realming")
                    }
                    //                    writeToLocalRealm(name: "maneShid")
                    //                    try! await openSyncedRealm(user: user1)
                    //                    var syncUser : User?
                    
                    print("opened synced realm")
                }
                //                Task {
                //                    let user1 = try await app.login(credentials: Credentials.anonymous)
                //                    do {
                //                        try await openSyncedRealm(user: user1)
                //                    } catch {
                //                        print("we couldn't openSyncedRealm")
                //                    }
                //                }
            }
            .buttonStyle(GrowingButton())
            Button("2 - Shopping. \(stringButton)") {
                clicked.toggle()
                //                Text("\(realmTime())")
                //                print("login result",login())
                //                print(realmTime())ƒ
                Task {
                    let user1 = try await app.login(credentials: Credentials.anonymous)
                    //                    writeToLocalRealm(name: "Shiddddddddddddddd")
                    stringButton = "\(user1)"
                    print("logged in and made user",user1)
                    do {
                        ////                        let realm = try await Realm()
                        //                        let rerealm = try await openSyncedRealm1(user: user1)
                        try await openSyncedRealm1(user: user1)
                        print("1.. we reaLmed") //}
                    } catch {
                        print("2.. realm ain't realming")
                    }
                    //                    writeToLocalRealm(name: "maneShid")
                    //                    try! await openSyncedRealm(user: user1)
                    
                    
                    //                    var syncUser : User?
                    
                    print("opened synced realm")
                }
                //                Task {
                //                    let user1 = try await app.login(credentials: Credentials.anonymous)
                //                    do {
                //                        try await openSyncedRealm(user: user1)
                //                    } catch {
                //                        print("we couldn't openSyncedRealm")
                //                    }
                //                }
            }
            .buttonStyle(GrowingButton())
            
            Button("Diapers") {
                //                for var item in [showPurchases,showFeedings,showDiapers] {
                //                    item = false
                //                }
                showFeedings = false
                showPurchases = false
                showDiapers = true
                collectionName = ""
            }
            .buttonStyle(GrowingButton())
            ;
            Button("Feedings") {
                showDiapers = false
                showPurchases = false
                showFeedings = true
                collectionName = "feedings"
                Task{
                    let interimText = try! await queryRealm(realm: makeRealm(user: login(), collection: .feedings) as! Realm, objectType: "Feeding.Type") as! Feeding
                    let lastTime = interimText.dateString
                    let volume = interimText.volume
                    //                                        feedText = "\(interimText)"
                    if volume > 0 {
                        feedText = "Last feeding was \(volume) oz at \(lastTime)."
                    } else {
                        feedText = "Last feeding was at \(lastTime)"
                    }}
            }
            .buttonStyle(GrowingButton())
            Button("Purchases") {
                //                Task {
                //                    var queryResult = await mongoQuery(collection: "purchases")
                ////                    print("date", queryResult.date)
                //
                //                }
                showDiapers = false
                showFeedings = false
                showPurchases = true
                collectionName = "purchases"
                purchaseCost = ""
                purchaseSize = ""
                
                //                Task{
                //                    let resultSet = await mongoQuery(collection: collectionName)
                //                    let stringConstruction = ""
                //                    let todayDay = dateToString(date: resultSet.date)
                //                    print(todayDay)
                //                    labelText = "Last bought "+resultSet.item + " on " + todayDay
                //
                //                }
            }
            .buttonStyle(GrowingButton())}
            Group {
//                Text("Select an option")
                Text("\(labelText)")
                if showDiapers == true{
                    Form {
                        
                        //                        List {
                        Picker("Soiled Diaper", selection: $diaperDirty) {
                            Text("Pee").tag(Soiled.pee)
                            Text("Poop").tag(Soiled.poop)
                            Text("Both (Double Nasty)").tag(Soiled.both)
                        }
                        //                        }
                        //                        List {
                        Picker("Wipes Used", selection: $diaperWipes) {
                            Text("NA").tag(Wipes.na)
                            Text("1").tag(Wipes.one)
                            Text("2").tag(Wipes.two)
                            Text("3").tag(Wipes.three)
                            Text("4+").tag(Wipes.four)
                        }
                        var wipesInt: Int = 0
                        
                        Button("Submit") {
                            print(wipesInt)
                            switch diaperWipes {
                            case .na: wipesInt = 1
                            case .one: wipesInt = 1
                            case .two: wipesInt = 2
                            case .three: wipesInt = 3
                            case .four: wipesInt = 4
                            default: wipesInt = 1
                            }
                            print(diaperText)
                            var dirtyText: String
                            switch diaperDirty {
                            case .pee: dirtyText = "pee-soaked diaper"
                            case .poop: dirtyText = "shitty diaper"
                            case .both: dirtyText = "absolutely filthy, disgusting diaper"
                            default: dirtyText = "dirty diaper"
                            }
                            if wipesInt == 1 {
                                diaperText = "\(wipesInt) wipe was used for the \(dirtyText)."
                            } else {
                                diaperText = "\(wipesInt) wipes were used for the \(dirtyText)."
                            }}
                        Text("\(diaperText)")
                        

                    }
                }; if showPurchases == true{
//                    Text("\(await mongoQuery(collection:"purchases")).item" as String)
//                    let queryResult1 = await mongoQuery(collection:"purchases")
//                    Text("\(queryResult.item)")
                    
                    
                    Form{
                        ScrollView{
                            LazyVStack{
                                //                        List {
                                //                            Spacer()
                                Picker("Item Bought", selection: $purchaseItem) {
                                    Text("Diapers").tag(Bought.diaper)
                                    Text("Formula").tag(Bought.formula)
                                    Text("Wipes").tag(Bought.wipes)
                                    Text("Other").tag(Bought.other)
//                                        .focused($focusedField, equals: .purchaseItem)
                                    //                                diaper, wipes, water, formula, other
                                }                                    .focused($focusedField, equals: .purchaseItem)
//                                    .submitLabel(.next)
//                                    .focused { isFocused in if (!isFocused) {
//                                        focusedField = .purchaseSize
//                                    }}
//                                    .focused( isFocused in if (!isFocused) {
//                                        focusedField = .purchaseSize
//                                    })
                                
                                Spacer()
                                TextField("Package Size", text: $purchaseSize)
                                    
//                                    .tag(1)
                                    .focused($focusedField, equals: .purchaseSize)
                                    .submitLabel(.next)
                                    
                                
                                TextField("Cost",text: $purchaseCost)
                                    .submitLabel(.next)
                                    
                                    .focused($focusedField, equals: .purchaseCost)
                                //                        var labelTextPurchases: String
                                //                        Label(title: "\(labelTextPurchases)")
                                
                                Button("Submit",action: {
                                    let sendItem = "\(purchaseItem)"
                                    let sendCost = "\(purchaseCost)"
                                    let sendSize = "\(purchaseSize)"
                                    var purchaseDict = ["item":sendItem,"cost":sendCost,"size":sendSize]
                                    Task{let textTest = try await openSyncedRealm1(user: login(), entry: purchaseDict,collection: .shopping)
                                        
                                        print("Awaiting \(purchaseDict)")
                                        if textTest is String {
                                            dummyText = textTest as! String
                                        } else {
                                            print("testtext",textTest)
                                            var reTextTest = textTest as! Shopping
                                            if [reTextTest.size,reTextTest.cost].contains("") {
                                                dummyText = "blankety blank"
                                            } else {
                                                dummyText = "\(reTextTest.item) cost \(reTextTest.cost) for \(reTextTest.size) on \(reTextTest.dateString)."}
                                            //dummyText = "\(interimObject.item)"//,interimObject.cost,interimObject.size,interimObject.dateString)"
                                            
                                        }
                                            
                                    }
                                    
                                        
                                })
//                                purchaseCost = ""
//                                purchaseSize = ""
                                Text("\(dummyText)")
                                .padding(10)}
                            
                        }
                            //                        .padding(10)
                        
                        }
                    .onSubmit {
                        switch focusedField {
                        case .purchaseSize:
                            focusedField = .purchaseCost
                        case .purchaseItem:
                            focusedField = .purchaseSize
                        default:
                            focusedField = nil
                        }}
//                    .onSubmit {
//                        switch focusedField {
//                        case .purchaseItem:
//                            focusedField = .purchaseSize
//                        case .purchaseSize:
//                            focusedField = .purchaseCost
//                        default:
//                            focusedField = nil
//                        }
//                    }
                    
                }; if showFeedings == true{
                        let setRange = 0...10
                        
                        Form{
                            LazyVStack {
                                Picker("Feeding Method", selection: $feedingsMethod) {
                                    Text("Bottle").tag(Apparatus.bottle)
                                    Text("Tiddy").tag(Apparatus.tiddy)
                                }
                                
                                
                                //                        }
                                
                                Stepper("Volume of feeding: \(feedingsVolume) oz",value:$feedingsVolume,in: setRange)
                                Button("Submit",action: {
                                    print("Awaiting")
                                        let feedMethod = "\(feedingsMethod)"
                                        let feedVolume = feedingsVolume
                                    var feedDict = ["method":feedMethod, "volume":feedVolume] as [String : Any]
                                    Task{let textTest = try await openSyncedRealm1(user: login(), entry: feedDict, collection: .feedings)
                                            print("Awaiting \(feedDict)")
//                                            if textTest is String {
//                                                dummyText = textTest as! String
//                                            } else {
//                                                print("testtext",textTest)
//                                                var reTextTest = textTest as! Shopping
//                                                if [reTextTest.size,reTextTest.cost].contains("") {
//                                                    dummyText = "blankety blank"
//                                                } else {
//                                                    dummyText = "\(reTextTest.item) cost \(reTextTest.cost) for \(reTextTest.size) on \(reTextTest.dateString)."}
                                            }
                                    
                                    
                                    }
                                )
                                .padding(10)
                                Text("\(feedText)")
                            }}
                    }}
                //            Group {
                //                Button("Diapers") {
                //                    clearStates()
                //                    showDiapers = true
                //                };
                //                Button("Feedings");
                //                    clearStates() = true
                //                Button("Purchases")
                //                    clearStates() = true
                //            }
            }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
