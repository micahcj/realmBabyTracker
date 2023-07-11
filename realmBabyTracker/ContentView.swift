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

func dateFormatter() -> String {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZZ"
//    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXXXX"
    var dateString:String = "\(String(describing: formatter.date(from: "\(Date())")))"
    dateString = formatter.string(from:Date())
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
func useRealm(_ realm: Realm, _ user: User) {
    // Add some tasks
    print("useRealm0")
//    let todo = Todo(name: "Do laundry", ownerId: user.id,dateString: "\(Date())")
//    let purchase = PurchaseClass(size: "big", cost: "a lot")
    let purchase = Shopping(item: "sleep", size: "any", cost: "everything", ownerId: "Big MJ")
//    print("Realm is located at:", realm.configuration.fileURL!)
    try! realm.write {
//        realm.add(todo)
        realm.add(purchase)
    }
//    let todos = realm.objects(Todo.self)
    let purchases = realm.objects(Shopping.self)
    print(purchases)
    let notificationToken = purchases.observe { (changes) in
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
func useRealm1(_ realm: Realm, _ user: User) {
    // Add some tasks
    print("useRealm1")
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
//class Task: Object {
//    @Persisted(primaryKey: true) var _id: ObjectId
//    @Persisted var taskName: String
//    @Persisted var assignee: String?
//    @Persisted var completed: Bool
//    @Persisted var progressMinutes: Int
//    @Persisted var dueDate: Date
//}
//class Team: Object {
//    @Persisted(primaryKey: true) var _id: ObjectId
//    @Persisted var teamName: String
//}


//@MainActor
//func getRealmWithSingleSubscription() async throws -> Realm {
//    let realm = try await Realm(configuration: flexSyncConfig)
//    let subscriptions = realm.subscriptions
//    try await subscriptions.update {
//       subscriptions.append(
//          QuerySubscription<Team> {
//             $0.teamName == "Developer Education"
//          })
//    }
//    return realm
//}

//func openLocalRealm()
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
}

@MainActor
func openSyncedRealm(user: User) async {
    print("openSyncedRealm")
    do {
        var config = user.flexibleSyncConfiguration(clientResetMode: .discardUnsyncedChanges())
//        var config = Realm.Configuration.defaultConfiguration
        config.objectTypes = [Todo.self]
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
        let realm = try await Realm(configuration: config)
        print("realm")
        let subscriptions = realm.subscriptions
        print("subscriptions - open 'realm'")
        
        try await subscriptions.update {
            subscriptions.append(
                QuerySubscription<Todo> {
                $0.ownerId == user.id
            })}
        useRealm1(realm, user)
        print("todo")
//        try await subscriptions.update {
//            subscriptions.append(QuerySubscription<Shopping> {
//                $0.ownerId == user.id
//            })
//        }
        print("shopping")
        try await useRealm1(realm, user)
        print("used realm")
    } catch {
        print("Error opening realm: \(error.localizedDescription)")
    }
}



@MainActor
func openSyncedRealm1(user: User) async {
    print("opened openSyncedRealm")
    do {
        var config = user.flexibleSyncConfiguration(clientResetMode: .discardUnsyncedChanges())
//        var config = user.flexibleSyncConfiguration(initialSubscriptions: { subs in subs.append(
//                        QuerySubscription<Shopping> {
//                            $0.ownerId == user.id
//                        })
//                })
//        config.objectTypes = [Todo.self]
        
        // Pass object types to the Flexible Sync configuration
        // as a temporary workaround for not being able to add a
        // complete schema for a Flexible Sync app.
        config.objectTypes = [Shopping.self,Todo.self]
        
        print("configged opensync1 - \(config.objectTypes)")
        print("shopping.self")
        let realm = try await Realm(configuration: config)
        // You must add at least one subscription to read and write from a Flexible Sync realm
        print("remote config")
//        writeToLocalRealm(name: "BigMJ")
//        useRealm(realm, user)
        let subscriptions = realm.subscriptions
        print("did something with subscriptions for 'realm1'")
        try await subscriptions.update {
            subscriptions.append(
                QuerySubscription<Shopping> {
                    $0.ownerId == user.id
                })
        }
        //        let useRealm = try! Realm(realm: realm, user: user)
        
        useRealm(realm, user)
        print("usedrealm")
        
        //        await useRealm
    } catch {
        print("Error opening realm: \(error.localizedDescription)")
    }
        print("Realmedout")

}

 
class Shopping: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var item: String = "null"
    @Persisted var cost: String = ""
    @Persisted var size: String = ""
//    @Persisted var dateString: String = "\(Date())"
    @Persisted var dateString: String = dateFormatter()
    @Persisted var ownerId: String = ""
    convenience init(item: String, size: String, cost: String, ownerId: String) {
        self.init()
        self.item = item
        self.ownerId = ownerId
        self.cost = cost
        self.size = size
//       self.dateString = dateString
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
       self.dateString = dateString
   }
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
//func mongoPurchase() async -> [MongoCollection]{
//    let elg = MultiThreadedEventLoopGroup(numberOfThreads: 4)
//    let client = try! MongoClient("mongodb://192.168.0.120:27017", using: elg)
//    defer {
//        // clean up driver resources
//        try? client.syncClose()
//        cleanupMongoSwift()
//
//        // shut down EventLoopGroup
//        try? elg.syncShutdownGracefully()
//    }
//    let db = client.db("babylist")
//    let collection = db.collection("purchases")
//    let doc : BSONDocument = ["_id":100,"date":"Date()","item":"thing1","package_size":"52 of them thangs"]
//
////    let doc: BSONDocument= ["_id": 100, "date": "\(Date())", "item": "\(purchaseItem)", "package_size": "\(purchaseSize)", "cost":"\(purchaseCost)"]
//
//    do {
//        var result = try await collection.insertOne(doc)
//        print(result)
//        print(result?.insertedID ?? "")
//    } catch {
//        print("FAILURE  \(error)")}
//
//    print("iTried")
//    return collection
//}


//
//func dbInsert(doc : BSONDocument) -> BSON {
//    defer {
//        // free driver resources
//        cleanupMongoSwift()
//    }
//    print("dbInsert")
//    let client:MongoClient = try! MongoClient("mongodb://192.168.0.120:27017")
//    let db = client.db("babylist")
//    let collection = try db.collection("purchases")
////    let doc : BSONDocument = ["_id":100,"thing":"thing"]
////    let doc : BSONDocument
//    let result = try! collection.insertOne(doc)
//    return result?.insertedID ?? "" // prints `.int64(100)`
//}




//
//let elg = MultiThreadedEventLoopGroup(numberOfThreads: 4)
//let client = try! MongoClient("mongodb://192.168.0.120:27017", using: elg)
//let db = client.db("babylist")

//// use collection...
//func mongoPost(collection : String, doc : BSONDocument) async -> String {
//
//    let elg = MultiThreadedEventLoopGroup(numberOfThreads: 4)
//    let client = try! MongoClient("mongodb://192.168.0.120:27017", using: elg)
//
//    defer {
//        // clean up driver resources
//        try? client.syncClose()
//        cleanupMongoSwift()
//
//        // shut down EventLoopGroup
//        try? elg.syncShutdownGracefully()
//    }
//
//    let db = client.db("babylist")
//    let collection = try! await db.collection(collection)
//    //    let doc : BSONDocument = ["_id":100,"thing":"thing"]
//    //    let bsonArray = ["_id": 100, "date": "\(Date())", "item": "stuffTest"].map {BSON.int32($0))
//    let result = try! await collection.insertOne(doc)
//
//    print(result?.insertedID ?? "") // prints `.int64(100)`
//    var finish : String = "donedonedonedidit"
//
//    do {
//        //       var result = try await collection.insertOne(doc)
//        let finish : String = "\(result?.insertedID ?? "")"
//        return finish
//        //        print(result?.insertedID ?? "")
//    } catch {
//        let finish = "FAILURE  \(error)"
//        print(finish)
//        return finish
//        //        return result?.insertedID ?? ""}}
//   }}
    // use collection...
//
//
//func mongoQuery(collection:String) async -> PurchaseSet {
//    let elg = MultiThreadedEventLoopGroup(numberOfThreads: 4)
//    let client = try! MongoClient("mongodb://192.168.0.120:27017", using: elg)
//    defer {
//        // clean up driver resources
//        try? client.syncClose()
//        cleanupMongoSwift()
//        // shut down EventLoopGroup
//        try? elg.syncShutdownGracefully()
//    }
//    let db = client.db("babylist")
//    let collection = try! await db.collection(collection)
//    let query: BSONDocument = ["a": 1]
//    let options = FindOptions(limit:1,sort: ["date": -1])
////    for try! await doc in try! await collection.find(query, options: options)
////    let queryResult = try! await collection.find(query, options:options).flatMap{ cursor in cursor.toArray() }
//    let regex = BSONRegularExpression(pattern: ".*", options: "")
//    let requery : BSONDocument = ["date":["$ne":"null"]]
////    let testOptions : FindOptions(BSON ["limit":1])
//    let queryResult = try! await collection.find(requery, options:options)
//    let arrayResult = try! await queryResult.toArray()
////    print(arrayResult)
////    for doc in queryResult.forEach() {"\($0)"} {
//    print("query displayed: ",requery)
//    print("count",arrayResult.count)
//    var i = 0
//    for doc in arrayResult {
//        i += 1
//        print(i,"doc1",doc)
//        print("doc2",doc["date"])}
//
//    let resultDatetime =   (arrayResult[0]["date"])
////    let dateDecoder = BSONDecoder()
////    BSONDecoder.DateDecodingStrategy = .bsonDateTime
//    let resultSize = arrayResult[0]["size"]
//    let resultCost = arrayResult[0]["cost"]
//    let resultItem = arrayResult[0]["item"]
//    print(try! BSONDecoder().decode(PurchaseSet.self, from: arrayResult[0]))
//    let resultStruct = try! BSONDecoder().decode(PurchaseSet.self, from: arrayResult[0])
//    print(resultStruct)
//    print(resultStruct.date)
//
//    let resultDict : Dictionary = ["date":resultDatetime,"item":resultItem,"size":resultSize,"cost":resultCost]
////    return resultDict
//    print(resultDict)
//    return resultStruct
//}
//    func mongoMe() {
    
//    defer {
//        // clean up driver resources
//        try? client.syncClose()
//        cleanupMongoSwift()
//
//        // shut down EventLoopGroup
//        try? elg.syncShutdownGracefully()
//    }



struct ContentView: View {
    
    @State var stringButton: String = "ClickMe"
    @State var stringChange: Bool = false
    
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
    enum Wipes: Int, Identifiable {
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
    @State var feedingsVolume = 0
    @State var feedingsTiddy : Bool = false
    
    @State var collectionName = ""
    @State var labelText = "Select an option"
    
    
//    @State private var selectedFlavor: Flavor = .chocolate
//    let elg = MultiThreadedEventLoopGroup(numberOfThreads: 4)
//    let elg: MultiThreadedEventLoopGroup
//    let client: MongoClient
//    let db: MongoDatabase
//    let collection: MongoCollection<Decodable>
//    let client = try MongoClient("mongodb://192.168.0.120:27017", using: elg)

    
    init () {
        self.showDiapers = false
        self.showFeedings = false
        self.showPurchases = false
//        self.elg = MultiThreadedEventLoopGroup(numberOfThreads: 4)
//        self.client = try! MongoClient("mongodb://192.168.0.120:27017", using: elg)
//        self.db = client.db("babylist")
    }

//    func mongoMe() {
//
//        defer {
//            // clean up driver resources
//            try? client.syncClose()
//            cleanupMongoSwift()
//
//            // shut down EventLoopGroup
//            try? elg.syncShutdownGracefully()
//        }


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
            Button("1 - ToDo. \(stringButton)") {
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
            Button("Diapers") {
                //                for var item in [showPurchases,showFeedings,showDiapers] {
                //                    item = false
                //                }
                showFeedings = false
                showPurchases = false
                showDiapers = true
                collectionName = ""
            };
            Button("Feedings") {
                showDiapers = false
                showPurchases = false
                showFeedings = true
                collectionName = "feedings"
            }
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
//                Task{
//                    let resultSet = await mongoQuery(collection: collectionName)
//                    let stringConstruction = ""
//                    let todayDay = dateToString(date: resultSet.date)
//                    print(todayDay)
//                    labelText = "Last bought "+resultSet.item + " on " + todayDay
//
//                }
            }
            Group {
//                Text("Select an option")
                Text("\(labelText)")
                if showDiapers == true{
                    Form {

                        List {
                            Picker("Soiled Diaper", selection: $diaperDirty) {
                                Text("Pee").tag(Soiled.pee)
                                Text("Poop").tag(Soiled.poop)
                                Text("Both (Double Nasty)").tag(Soiled.both)
                            }
                        }
                        List {
                            Picker("Wipes Used", selection: $diaperWipes) {
                                Text("NA").tag(Wipes.na)
                                Text("1").tag(Wipes.one)
                                Text("2").tag(Wipes.two)
                                Text("3").tag(Wipes.three)
                                Text("4+").tag(Wipes.four)
                            }
                        }
                    }
                }; if showPurchases == true{
//                    Text("\(await mongoQuery(collection:"purchases")).item" as String)
//                    let queryResult1 = await mongoQuery(collection:"purchases")
//                    Text("\(queryResult.item)")
                    
                    Form{
                        
                        List {
                            Picker("Item Bought", selection: $purchaseItem) {
                                Text("Diapers").tag(Bought.diaper)
                                Text("Formula").tag(Bought.formula)
                                Text("Wipes").tag(Bought.wipes)
                                Text("Other").tag(Bought.other)
                                //                                diaper, wipes, water, formula, other
                            }
                        }
                        TextField("Package Size", text: $purchaseSize)
                        
                        TextField("Cost",text: $purchaseCost);
//                        var labelTextPurchases: String
//                        Label(title: "\(labelTextPurchases)")
                        Button("Submit",action: {
                            print("Awaiting")
//                            let itemBSON  = "\(purchaseItem)"
//
//                            let doc :BSONDocument = ["date":BSON.datetime(Date()),"item": BSON.string("\(purchaseItem)"),"size":BSON.string("\(purchaseSize)"),"cost":BSON.string("\(purchaseCost)")]
                            
                            //                            dbInsert(doc: doc)
//                            Task {
//
//
//                                await mongoPost(collection: "purchases",doc: doc)
//                                labelText = "Submitted \(purchaseItem) purchase"
//
//                            }
                        })
                        //                        .padding(10)
                    }}; if showFeedings == true{
                        let setRange = 0...6
                        Form{
                            List {
                            Picker("Feeding Method", selection: $feedingsMethod) {
                                Text("Bottle").tag(Apparatus.bottle)
                                Text("Tiddy").tag(Apparatus.tiddy)
                            }
                            
                            
                        }
                            
                            Stepper("Volume of feeding: \(feedingsVolume) oz",value:$feedingsVolume,in: setRange)
                            Button("Submit",action: {
                                print("Awaiting")
//                                let itemBSON  = "\(feedingsMethod)"
                                
//                                let doc :BSONDocument = ["date":BSON.datetime(Date()),"feedingMethod": BSON.string("\(feedingsMethod)"),"volume":BSON.string("\(feedingsVolume)")]
    //                            dbInsert(doc: doc)
//                                Task {
//                                    await mongoPost(collection: "feedings",doc: doc)
//                                }
                            })
                                .padding(10)
                            //                        Stepper(value: $feedingsVolume, in: [0,1,2,3,4,5]) {
                            //                        "Volume"}
                        }
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
