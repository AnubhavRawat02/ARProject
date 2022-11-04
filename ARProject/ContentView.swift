//
//  ContentView.swift
//  ARProject
//
//  Created by Anubhav Rawat on 03/10/22.
//

// buttons like create new screen and load screen
// another type of button for saving screen and loading data
//placement of up and down buttons.
// all images of the same size
import SwiftUI
import RealityKit
import ARKit

extension ARView{
    
    
//    var objectSelected: String = ""
    
    struct Holder{
        static var computedProperty: AnchorEntity = AnchorEntity(plane: .horizontal)
    }
    
    var objectSelected: AnchorEntity{
        return Holder.computedProperty
    }
    
    
    func enableGesture(){
        let tapGestureRecogniser = UITapGestureRecognizer(target: self, action: #selector(handleTap(recogniser:)))
        self.addGestureRecognizer(tapGestureRecogniser)
    }
    
    @objc func handleTap(recogniser: UITapGestureRecognizer){
        let location = recogniser.location(in: self)
        
        if let anchor = self.entity(at: location){
            if let anchorEntity = anchor.anchor{
                print(anchorEntity.name)
                Holder.computedProperty = anchorEntity as! AnchorEntity
            }
        }else {
            Holder.computedProperty = AnchorEntity(plane: .horizontal)
        }
    }
}

//MARK: - editing z axis

struct SliderWithAr: View{
    
    @State var modelToPlace: String = ""
    @State var placeModel: Bool = false
    
    @State var moveUp: Bool = false
    @State var moveDown: Bool = false
    
    var body: some View{
        ZStack{
            ARViewContainer4(modelToPlace: $modelToPlace, placeModel: $placeModel, moveUp: $moveUp, moveDown: $moveDown)
            VStack{
                Spacer()
                HStack{
                    Spacer()
                    VStack(spacing: 20){
                        Button {
                            moveUp = true
                        } label: {
                            Text("up")
                        }
                        Button {
                            moveDown = true
                        } label: {
                            Text("down")
                        }
                    }
                }
                Spacer()
                HStack{
                    ForEach(modelNames, id: \.self){model in
                        VStack{
                            Image("\(model)").resizable().scaledToFit()
                            Text("\(model)")
                        }.onTapGesture {
                            modelToPlace = model
                            placeModel = true
                        }
                    }
                }
            }
        }
    }
}

struct ARViewContainer4: UIViewRepresentable{
    
//    @State var selectedObject: String = ""
    
    @Binding var modelToPlace: String
    @Binding var placeModel: Bool
    
    @Binding var moveUp: Bool
    @Binding var moveDown: Bool
    
    let arView = ARView(frame: .zero)
    
    func makeUIView(context: Context) -> some UIView {
        
        let conf = ARWorldTrackingConfiguration()
        conf.planeDetection = [.horizontal, .vertical]
        
        let model = try! ModelEntity.loadModel(named: "kiitChair.usdz")
        model.generateCollisionShapes(recursive: true)
        arView.installGestures(.all, for: model)
        
        let anchor = AnchorEntity(plane: .horizontal)
        anchor.addChild(model)
        anchor.name = "place anchor"
        arView.scene.anchors.append(anchor)
        
        arView.enableGesture()
        
        arView.session.run(conf)
        
        return arView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
        if placeModel{
            let conf = ARWorldTrackingConfiguration()
            conf.planeDetection = [.horizontal, .vertical]
            
            let model = try! ModelEntity.loadModel(named: modelData[modelToPlace]!)
            model.generateCollisionShapes(recursive: true)
            arView.installGestures(.all, for: model)
            
            let anchor = AnchorEntity(plane: .horizontal)
            anchor.addChild(model)
            anchor.name = "\(modelToPlace)"
            arView.scene.anchors.append(anchor)
            
            DispatchQueue.main.async {
                modelToPlace = ""
                placeModel = false
            }
        }
        
        if moveUp{
            
            let initObject = arView.scene.anchors[0]
            
            var objectNames: [String: AnchorEntity]{
                var objs: [String: AnchorEntity] = [:]
                for ob in arView.scene.anchors{
                    objs[ob.name] = (ob as! AnchorEntity)
                }
                
                return objs
            }
            
            if let obj = objectNames[arView.objectSelected.name]{
                
                obj.setPosition(SIMD3<Float>(x: Float(obj.position.x), y: Float(obj.position.y + 0.01), z: Float(obj.position.z)) , relativeTo: initObject)
                
                print("moving \(obj.name) up")
            }else{
                print("select an object first")
            }
            
            DispatchQueue.main.async {
                moveUp = false
            }
        }
        
        if moveDown{
            
            let initObject = arView.scene.anchors[0]
            
            var objectNames: [String: AnchorEntity]{
                var objs: [String: AnchorEntity] = [:]
                for ob in arView.scene.anchors{
                    objs[ob.name] = (ob as! AnchorEntity)
                }
                
                return objs
            }
            
            if let obj = objectNames[arView.objectSelected.name]{
                
                obj.setPosition(SIMD3<Float>(x: Float(obj.position.x), y: Float(obj.position.y - 0.01), z: Float(obj.position.z)) , relativeTo: initObject)
                
                print("moving \(obj.name) down")
            }else{
                print("select an object first")
            }
            
            DispatchQueue.main.async {
                moveDown = false
            }
        }
        
    }
}


//MARK: - main content view
struct ContentView : View {
    
    @StateObject private var datacontroller = DataController()
    
    var body: some View {
        ContentView2().environment(\.managedObjectContext, datacontroller.container.viewContext)
    }
}

//MARK: - secondary content view
struct ContentView2: View{
    
    @State var currentScreen = "home"
    @State var loadRoom = ""
    @State var roomName = ""
    
    var body: some View{
//        SliderWithAr()
//        TestingArContainer()
//        SliderView()
        if currentScreen == "home"{
            HomeScreen(currentScreen: $currentScreen, loadRoom: $loadRoom, roomname: $roomName)
        }else if currentScreen == "newscene"{
            NewContainer(currentScreen: $currentScreen, roomname: $roomName)
        }else{
            SavedContainer(sceneId: $loadRoom, currentScreen: $currentScreen)
        }
    }
}


//MARK: - home screen
struct HomeScreen: View{
    
    @Binding var currentScreen: String
    @Binding var loadRoom: String
    @Binding var roomname: String
    @State var presented: Bool = false
    
    func createRoom(name: String){
        roomname = name
        currentScreen = "newscene"
    }
    
    
    @Environment(\.managedObjectContext) var viewContext
    @FetchRequest(sortDescriptors: []) var rooms: FetchedResults<Room>
    
    var body: some View{
        ZStack{
            Color.gray.ignoresSafeArea()
            VStack{
                ScrollView(.vertical, showsIndicators: false){
                    VStack{
                        Text("Rooms")
                            .foregroundColor(.black)
                            .font(.system(size: 24))
                        ForEach(rooms, id: \.self){room in
                            ZStack{
                                Image("room")
                                    .resizable()
                                    .frame(width: 350, height: 70)
                                VStack{
                                    Spacer()
                                    ZStack{
                                        Color.gray.opacity(0.4)
                                        Text(room.name ?? "no name")
                                    }
                                    .frame(width: 100, height: 20)
                                }
                                
                            }
                            .cornerRadius(30)
                            .onTapGesture {
                                currentScreen = "oldroom"
                                loadRoom = "\(room.id!)"
                            }
                            
                        }
                    }
                }
                HStack{
                    Button {
                        presented = true
                    } label: {
                        HomeButton(buttonString: "create new")
                    }
                    
                    Button {
                        for r in rooms{
                            viewContext.delete(r)
                        }
                        do{
                            try viewContext.save()
                        }catch{
                            print(error.localizedDescription)
                        }
                    } label: {
                        HomeButton(buttonString: "delete all")
                    }

                }
            }
        }
        
        .sheet(isPresented: $presented) {
            SheetView(addroom: createRoom)
        }
    }
}

struct SheetView: View{
    
    @Environment(\.dismiss) var dismiss
    @State var roomname: String = ""
    var addroom: (String) -> ()
    
    var body: some View{
        VStack{
            TextField("roomname", text: $roomname)
            Button {
                addroom(roomname)
                DispatchQueue.main.async {
                    dismiss()
                }
            } label: {
                Text("create room")
            }

        }
    }
}



//MARK: - for loading saved rooms
struct SavedContainer: View{
    
    @Binding var sceneId: String
    @Binding var currentScreen: String
    
    @State var modelToplace: String = ""
    @State var placeModel: Bool = false
    
    @State var moveUp: Bool = false
    @State var moveDown: Bool = false
    
    @State var saveScreen: Bool = false
    @State var loadObjects: Bool = false
    
    var body: some View{
        ZStack{
            ArSavedViewContainer(modelToPlace: $modelToplace, placeModel: $placeModel, moveUp: $moveUp, moveDown: $moveDown, saveScreen: $saveScreen, loadObjects: $loadObjects, sceneId: $sceneId, currentScreen: $currentScreen)
            VStack{
                Spacer()
                
                HStack{
                    Spacer()
                    VStack(spacing: 40){
                        VStack(spacing: 30){
                            Button {
                                moveUp = true
                            } label: {
                                Image(systemName: "arrowtriangle.up.fill")
                                    .font(.system(size: 40))
                                    .foregroundColor(.pink)
                            }
                            
                            Button {
                                moveDown = true
                            } label: {
                                Image(systemName: "arrowtriangle.down.fill")
                                    .font(.system(size: 40))
                                    .foregroundColor(.pink)
                            }
                        }

                    }.padding(.trailing, 30)
                }
                
                Spacer()
                
                HStack(spacing: 30){
                    Button {
                        saveScreen = true
                    } label: {
                        ArButton(buttonString: "Save Screen")
                    }
                    Button {
                        loadObjects = true
                    } label: {
                        ArButton(buttonString: "Load Objects")
                    }


                }
                
                HStack{
                    ForEach(modelNames, id: \.self){model in
                        VStack{
                            Image("\(model)")
                                .resizable()
                                .frame(width: 100, height: 100)
                            Text("\(model)")
                        }.onTapGesture {
                            modelToplace = model
                            placeModel = true
                        }
                    }
                }
            }
        }
    }
}

struct ArSavedViewContainer: UIViewRepresentable{
    
    let arView = ARView(frame: .zero)
    
    @Binding var modelToPlace: String
    @Binding var placeModel: Bool
    
    @Binding var moveUp: Bool
    @Binding var moveDown: Bool
    
    @Binding var saveScreen: Bool
    @Binding var loadObjects: Bool
    @Binding var sceneId: String
    
    @Binding var currentScreen: String
    
    @Environment(\.managedObjectContext) var viewContext
    @FetchRequest(sortDescriptors: []) var rooms: FetchedResults<Room>
    
    var mainRoom: [FetchedResults<Room>.Element]{
        return rooms.filter { r in
            return sceneId == "\(r.id!)"
        }
    }
    
    func makeUIView(context: Context) -> some UIView {
        
        let conf = ARWorldTrackingConfiguration()
        conf.planeDetection = [.horizontal, .vertical]
        
        let model = try! ModelEntity.loadModel(named: "kiitChair.usdz")
        model.generateCollisionShapes(recursive: true)
        arView.installGestures(.all, for: model)
        
        let anchor = AnchorEntity(plane: .horizontal)
        anchor.addChild(model)
        anchor.name = "kiitChair"
        arView.scene.anchors.append(anchor)
        
        arView.enableGesture()
        
        arView.session.run(conf)
        
        return arView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
        if loadObjects{
            let conf = ARWorldTrackingConfiguration()
            conf.planeDetection = [.horizontal, .vertical]
            
            let initObject = arView.scene.anchors[0]
            for obj in mainRoom[0].models{
                let model = try! ModelEntity.loadModel(named: "\(obj.name!).usdz") //possible error
                model.generateCollisionShapes(recursive: true)
                arView.installGestures(.all, for: model)
                
                let anchor = AnchorEntity(plane: .horizontal)
                anchor.addChild(model)
                anchor.name = obj.name!
                anchor.setPosition(SIMD3<Float>(x: Float(obj.xcordinate), y: Float(obj.ycordinate) + 0.28, z: Float(obj.zcordinate)) , relativeTo: initObject)
                arView.scene.anchors.append(anchor)
            }
            
            arView.session.run(conf)
            DispatchQueue.main.async {
                loadObjects = false
            }
        }
        
        if saveScreen{
            
            let firstObject = arView.scene.anchors[0]
            var set : Set<ModelObject> = []
            
            for anc in arView.scene.anchors{
                let newobj = ModelObject(context: viewContext)
                newobj.id = UUID()
                newobj.name = anc.name
                newobj.room = mainRoom[0]
                newobj.xcordinate = Double(anc.position(relativeTo: firstObject).x)
                newobj.ycordinate = Double(anc.position(relativeTo: firstObject).y)
                newobj.zcordinate = Double(anc.position(relativeTo: firstObject).z)
                set.insert(newobj)
            }
            
            mainRoom[0].model = set
            DispatchQueue.main.async {
                saveScreen = false
                currentScreen = "home"
                do{
                    try viewContext.save()
                }catch{
                    print(error.localizedDescription)
                }
            }
        }
        
        if placeModel{
            let conf = ARWorldTrackingConfiguration()
            conf.planeDetection = [.horizontal, .vertical]
            
            let model = try! ModelEntity.loadModel(named: modelData[modelToPlace]!)
            model.generateCollisionShapes(recursive: true)
            arView.installGestures(.all, for: model)
            
            let anchor = AnchorEntity(plane: .horizontal)
            anchor.addChild(model)
            anchor.name = "\(modelToPlace)"
            arView.scene.anchors.append(anchor)
            
            DispatchQueue.main.async {
                modelToPlace = ""
                placeModel = false
            }
            
        }
        
        if moveUp{
            let initObject = arView.scene.anchors[0]
            
            var objectNames: [String: AnchorEntity]{
                var objs: [String: AnchorEntity] = [:]
                for ob in arView.scene.anchors{
                    objs[ob.name] = (ob as! AnchorEntity)
                }
                return objs
            }
            
            if let obj = objectNames[arView.objectSelected.name]{
                obj.setPosition(SIMD3<Float>(x: Float(obj.position.x), y: Float(obj.position.y + 0.01), z: Float(obj.position.z)), relativeTo: initObject)
                
                print("moving \(obj.name) up")
            }else{
                print("select an object first")
            }
            
            DispatchQueue.main.async {
                moveUp = false
            }
        }
        
        if moveDown{
            let initObject = arView.scene.anchors[0]
            
            var objectNames: [String: AnchorEntity]{
                var objs: [String: AnchorEntity] = [:]
                for ob in arView.scene.anchors{
                    objs[ob.name] = (ob as! AnchorEntity)
                }
                return objs
                
            }
            
            if let obj = objectNames[arView.objectSelected.name]{
                obj.setPosition(SIMD3<Float>(x: Float(obj.position.x), y: Float(obj.position.y - 0.01), z: Float(obj.position.z)) , relativeTo: initObject)
                
                print("moving \(obj.name) down")
            }else{
                print("select an object first")
            }
            
            DispatchQueue.main.async {
                moveDown = false
            }
        }
        
    }
}



//MARK: - for creating new rooms

struct NewContainer: View{
    
    @Binding var currentScreen: String
    @Binding var roomname: String
    
    @State var modelToPlace: String = ""
    @State var placeModel: Bool = false
    
    @State var moveUp: Bool = false
    @State var moveDown: Bool = false
    
    @State var saveScreen: Bool = false
    
    var body: some View{
        ZStack{
            ARNewViewContainer(currentScreen: $currentScreen, modelToPlace: $modelToPlace, placeModel: $placeModel, moveUp: $moveUp, moveDown: $moveDown, saveScreen: $saveScreen, roomname: $roomname).ignoresSafeArea()
            
            VStack{
                Spacer()
                HStack{
                    Spacer()
                    VStack(spacing: 30){
                        Button {
                            moveUp = true
                        } label: {
                            Image(systemName: "arrowtriangle.up.fill")
                                .font(.system(size: 40))
                                .foregroundColor(.pink)
                        }
                        
                        Button {
                            moveDown = true
                        } label: {
                            Image(systemName: "arrowtriangle.down.fill")
                                .font(.system(size: 40))
                                .foregroundColor(.pink) 
                        }


                    }
                }
                
                Spacer()
                Button {
                    saveScreen = true
                } label: {
                    ArButton(buttonString: "Save Screen")
                }
                
                HStack{
                    ForEach(modelNames, id: \.self){model in
                        VStack{
                            Image("\(model)")
                                .resizable()
//                                .scaledToFit()
                                .frame(width: 100, height: 100)
                            Text("\(model)")
                        }.onTapGesture {
                            modelToPlace = model
                            placeModel = true
                        }
                    }
                }

            }
        }
    }
}


struct ARNewViewContainer: UIViewRepresentable{
    
    @Binding var currentScreen: String
    
    @Binding var modelToPlace: String
    @Binding var placeModel: Bool
    
    @Binding var moveUp: Bool
    @Binding var moveDown: Bool
    
    @Binding var saveScreen: Bool
    @Binding var roomname: String
    
    @Environment(\.managedObjectContext) var viewContext
    
    let arView = ARView(frame: .zero)
    func makeUIView(context: Context) -> some UIView {
        
        let conf = ARWorldTrackingConfiguration()
        conf.planeDetection = [.horizontal, .vertical]
        
        let model = try! ModelEntity.loadModel(named: "kiitChair.usdz")
        model.generateCollisionShapes(recursive: true)
        arView.installGestures(.all, for: model)
        
        let anchor = AnchorEntity(plane: .horizontal)
        anchor.addChild(model)
        anchor.name = "kiitChair"
        arView.scene.anchors.append(anchor)
        
        arView.enableGesture()
        
        arView.session.run(conf)
        
        return arView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
        if placeModel{
            let conf = ARWorldTrackingConfiguration()
            conf.planeDetection = [.horizontal, .vertical]
            
            let model = try! ModelEntity.loadModel(named: "\(modelToPlace)")
            model.generateCollisionShapes(recursive: true)
            arView.installGestures(.all, for: model)
            
            let anchor = AnchorEntity(plane: .horizontal)
            anchor.addChild(model)
            anchor.name = modelToPlace
            arView.scene.anchors.append(anchor)
            
            DispatchQueue.main.async {
                modelToPlace = ""
                placeModel = false
            }
        }
        if moveUp{
            let initObject = arView.scene.anchors[0]
            
            var objectNames: [String: AnchorEntity]{
                var objs: [String: AnchorEntity] = [:]
                for ob in arView.scene.anchors{
                    objs[ob.name] = (ob as! AnchorEntity)
                }
                return objs
            }
            
            if let obj = objectNames[arView.objectSelected.name]{
                obj.setPosition(SIMD3<Float>(x: Float(obj.position.x), y: Float(obj.position.y + 0.01), z: Float(obj.position.z)), relativeTo: initObject)
                
                print("moving \(obj.name) up")
            }else{
                print("select an object first")
            }
            
            DispatchQueue.main.async {
                moveUp = false
            }
        }
        if moveDown{
            let initObject = arView.scene.anchors[0]
            
            var objectNames: [String: AnchorEntity]{
                var objs: [String: AnchorEntity] = [:]
                for ob in arView.scene.anchors{
                    objs[ob.name] = (ob as! AnchorEntity)
                }
                return objs
                
            }
            
            if let obj = objectNames[arView.objectSelected.name]{
                obj.setPosition(SIMD3<Float>(x: Float(obj.position.x), y: Float(obj.position.y - 0.01), z: Float(obj.position.z)) , relativeTo: initObject)
                
                print("moving \(obj.name) down")
            }else{
                print("select an object first")
            }
            
            DispatchQueue.main.async {
                moveDown = false
            }
        }
        if saveScreen{
            let firstObj = arView.scene.anchors[0]
            let room = Room(context: viewContext)
            
            var set: Set<ModelObject> = []
            for anc in arView.scene.anchors{
                let newobj = ModelObject(context: viewContext)
                newobj.name = anc.name
                newobj.id = UUID()
                newobj.room = room
                newobj.xcordinate = Double(anc.position(relativeTo: firstObj).x)
                newobj.ycordinate = Double(anc.position(relativeTo: firstObj).y)
                newobj.zcordinate = Double(anc.position(relativeTo: firstObj).z)
                set.insert(newobj)
            }
            
            room.name = roomname
            room.id = UUID()
            room.model = set
            
            DispatchQueue.main.async {
                saveScreen = false
                currentScreen = "home"
                do{
                    try viewContext.save()
                }catch{
                    print(error.localizedDescription)
                }
            }
        }
        
    }
}

struct ArButton: View{
    
    var buttonString: String
    
    var body: some View{
        ZStack{
            Color.orange
            Text(buttonString).foregroundColor(.white)
        }
        .frame(width: 160, height: 40)
        .cornerRadius(30)
    }
}

struct HomeButton: View{
    
    var buttonString: String
    
    var body: some View{
        ZStack{
            Color.blue
            Text(buttonString).foregroundColor(.white)
        }
        .frame(width: 160, height: 40)
        .cornerRadius(30)
    }
}

//MARK: - preview provider
#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
