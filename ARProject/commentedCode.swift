//
//  commentedCode.swift
//  ARProject
//
//  Created by Anubhav Rawat on 22/10/22.
//

import Foundation


//MARK: - arview controller for provided scenes

//following code is for arviewcontroller working perfectly for saved rooms. 

//struct SavedArContainer: View{
//    @Binding var sceneid: String
//    @Binding var currentScreen: String
//    @State var saveScene: Bool = false
//    @State var placeObject: Bool = false
//    @State var loadObjects: Bool = false
//
//    var body: some View{
//        ZStack{
//            ARViewContainer(sceneid: $sceneid, currentScreen: $currentScreen, saveScreen: $saveScene, placeObject: $placeObject, loadObjects: $loadObjects)
//            VStack{
//                Spacer()
//                HStack{
//                    Button {
//                        placeObject = true
//                    } label: {
//                        Text("place your item")
//                    }
//                    Button {
//                        saveScene = true
//                    } label: {
//                        Text("save the scene")
//                    }
//
//                }
//                Button {
//                    loadObjects = true
//                } label: {
//                    Text("load all objects")
//                }
//
//            }
//        }
//    }
//}
//
//struct ARViewContainer: UIViewRepresentable {
//    @Binding var sceneid: String
//    @Binding var currentScreen: String
//    @Binding var saveScreen: Bool
//    @Binding var placeObject: Bool
//    @Binding var loadObjects: Bool
//
//    @State var toynumber: Int = 1
//
//    @Environment(\.managedObjectContext) var viewContext
//    @FetchRequest(sortDescriptors: []) var rooms: FetchedResults<Room>
//
////    room which is to be loaded
//    var mainroom: [FetchedResults<Room>.Element]{
//        return rooms.filter{r in
//            return sceneid == "\(r.id!)"
//        }
//    }
//
//    func makeUIView(context: Context) -> ARView {
//        let arView = ARView(frame: .zero)
//        let conf = ARWorldTrackingConfiguration()
//        conf.planeDetection = [.horizontal, .vertical]
//
//        let model = try! ModelEntity.loadModel(named: "toy_drummer.usdz")
//        model.generateCollisionShapes(recursive: true)
//        arView.installGestures(.all ,for: model)
//
//        let anchor = AnchorEntity(plane: .horizontal)
//        anchor.addChild(model)
//        anchor.name = "place anchor"
//        arView.scene.anchors.append(anchor)
//
//        arView.session.run(conf)
//
//        return arView
//    }
//
//    func updateUIView(_ uiView: ARView, context: Context) {
//        if placeObject{
//            do{
//                let conf = ARWorldTrackingConfiguration()
//                conf.planeDetection = [.horizontal, .vertical]
//
//                let model = try ModelEntity.loadModel(named: "toy_dummer.usdz")
//                model.generateCollisionShapes(recursive: true)
//                uiView.installGestures(.all, for: model)
//
//                let anchor = AnchorEntity(plane: .horizontal)
//                anchor.addChild(model)
//                anchor.name = "toy number \(toynumber)"
//                uiView.scene.anchors.append(anchor)
//
//            }catch{
//                print(error.localizedDescription)
//            }
//            DispatchQueue.main.async {
//                placeObject = false
//                toynumber = toynumber + 1
//            }
//        }
//        if saveScreen{
//            let firstobject = uiView.scene.anchors[0]
////            let room = Room(context: viewContext )
//            var set : Set<ModelObject> = []
//
//            for anc in uiView.scene.anchors{
//                let newobj = ModelObject(context: viewContext)
//                newobj.id = UUID()
//                newobj.name = anc.name
//                newobj.room = mainroom[0]
//                newobj.xcordinate = Double(anc.position(relativeTo: firstobject).x)
//                newobj.ycordinate = Double(anc.position(relativeTo: firstobject).y)
//                newobj.zcordinate = Double(anc.position(relativeTo: firstobject).z)
//                set.insert(newobj)
//            }
//            mainroom[0].model = set
//
//            DispatchQueue.main.async {
//                saveScreen = false
//                currentScreen = "home"
//                do{
//                    try viewContext.save()
//                }catch{
//                    print(error.localizedDescription)
//                }
//            }
//        }
//        if loadObjects{
//
//            let conf = ARWorldTrackingConfiguration()
//            conf.planeDetection = [.horizontal, .vertical]
//
//            let initObject = uiView.scene.anchors[0]
//            for obj in mainroom[0].models{
//                let model = try! ModelEntity.loadModel(named: "toy_drummer.usdz")
//                model.generateCollisionShapes(recursive: true)
//                uiView.installGestures(.all, for: model)
//
//                let anchor = AnchorEntity(plane: .horizontal)
//                anchor.addChild(model)
//                anchor.name = obj.name!
//                anchor.setPosition(SIMD3<Float>(x: Float(obj.xcordinate), y: Float(obj.ycordinate) + 0.28, z: Float(obj.zcordinate)) , relativeTo: initObject)
//                uiView.scene.anchors.append(anchor)
//            }
//
//            uiView.session.run(conf)
//
//            DispatchQueue.main.async {
//                loadObjects = false
//            }
//        }
//    }
//
//}\



//MARK: - slider test view

//struct SliderView: View{
//
//    @State var sliderValue: Float = 0.0
//
//    var body: some View{
//        Slider(value: $sliderValue, in: 0...10)
//            .onChange(of: sliderValue) { newValue in
//                print(sliderValue)
//            }
//    }
//}


//MARK: - testing arscene

//testing to edit the y axis with slider. never worked because of some state changing during view update BS.

//struct TestingArContainer: View{
//
//    @State var modelToPlace: String = ""
//    @State var placeModel: Bool = false
////    @State var showSlider: Bool = false
//
//
//    @State var sliderValue: Float = 5.0
//    @State var tapOccured: Bool = false
//    @State var editzaxis: Bool = false
//    @State var modeltoedit: String = ""
//    @State var show: Bool = false
//
//
//    var body: some View{
//        ZStack{
//            ARViewContainer3(modelToPlace: $modelToPlace, placeModel: $placeModel, tapOccured: $tapOccured, editzaxis: $editzaxis, sliderValue: $sliderValue, modelToEdit: $modeltoedit, show: $show).ignoresSafeArea()
//                .onTapGesture {
//                    tapOccured = true
////                    showSlider = true
//                    print("tap")
//                }
//            HStack{
//                Spacer()
//                Slider(value: $sliderValue, in: 0...10)
//            }.padding(.trailing, 30)
//
//
//            if show{
//                Text("showing")
//            }
//
//
//            VStack{
//                Text("selected Object: \(modeltoedit)")
//
//                Spacer()
//
//
//                HStack{
//                    ForEach(modelNames, id: \.self){model in
//                        VStack{
//                            Image("\(model)").resizable().scaledToFit()
//                            Text("\(model)")
//                        }.onTapGesture {
//                            modelToPlace = model
//                            placeModel = true
//                        }
//                    }
//                }
//            }
//
//        }
//    }
//}
//
//
//struct ARViewContainer3: UIViewRepresentable{
//
//    @Binding var modelToPlace: String
//    @Binding var placeModel: Bool
//
//
//    @Binding var tapOccured: Bool
//    @Binding var editzaxis: Bool
//    @Binding var sliderValue: Float
//    @Binding var modelToEdit: String
//    @Binding var show: Bool
//
//
//    let arView = ARView(frame: .zero)
//
//    func someRandomFunc(){
//        print("inside the arviewcontroller 3")
//    }
//
//
//    func makeUIView(context: Context) -> ARView {
//
//
////        let arView = ARView(frame: .zero)
//        let conf = ARWorldTrackingConfiguration()
//        conf.planeDetection = [.horizontal, .vertical]
//
//        let model = try! ModelEntity.loadModel(named: "kiitChair.usdz")
//        model.generateCollisionShapes(recursive: true)
//        arView.installGestures(.all ,for: model)
//
//        let anchor = AnchorEntity(plane: .horizontal)
//        anchor.addChild(model)
//        anchor.name = "place anchor"
//        arView.scene.anchors.append(anchor)
//
//        arView.enableGesture()
//
//        arView.session.run(conf)
//
//        return arView
//    }
//
//    func updateUIView(_ uiView: UIViewType, context: Context) {
//
//        if placeModel{
//            let conf = ARWorldTrackingConfiguration()
//            conf.planeDetection = [.horizontal, .vertical]
//
//            let model = try! ModelEntity.loadModel(named: modelData[modelToPlace]!)
//            model.generateCollisionShapes(recursive: true)
//            uiView.installGestures(.all, for: model)
//
//            let anchor = AnchorEntity(plane: .horizontal)
//            anchor.addChild(model)
//            anchor.name = "\(modelToPlace)"
//            uiView.scene.anchors.append(anchor)
//            DispatchQueue.main.async {
//                placeModel = false
//                modelToPlace = ""
//            }
//        }
//
//        if editzaxis{
//
//            print("hey___________")
//
//            DispatchQueue.main.async {
//                editzaxis = false
//                tapOccured = false
//            }
//        }
//
//        if tapOccured{
//
//            var objectNames: [String: AnchorEntity]{
//                var objs: [String: AnchorEntity] = [:]
//                for ob in uiView.scene.anchors{
//                    objs[ob.name] = (ob as! AnchorEntity)
//                }
//                return objs
//            }
//
//            if let obj = objectNames[uiView.objectSelected.name]{
//                print(obj.name)
//            }else{
//                print("no object selected")
//            }
//            DispatchQueue.main.async {
//                tapOccured = false
//                editzaxis = true
//            }
//        }
//    }
//
//
//}



//MARK: - arview controller for new scenes


//working ar container for creating new rooms and saving them


//struct NewArContainer: View{
//
//    @State var placeObject: Bool = false
//    @State var saveScene: Bool = false
//    @Binding var currentScreen: String
//
//    var body: some View{
//        ZStack{
//            ARViewContainernew(placeObject: $placeObject, saveScene: $saveScene, currentScreen: $currentScreen)
//            VStack{
//                Spacer()
//                HStack{
//                    Button {
//                        placeObject = true
//                    } label: {
//                        Text("place your item")
//                    }
//
//                    Button {
//                        saveScene = true
//                    } label: {
//                        Text("save the scene")
//                    }
//
//                }.foregroundColor(.blue)
//            }
//        }
//    }
//}
//
//struct ARViewContainernew: UIViewRepresentable {
//    @Binding var placeObject: Bool
//    @Binding var saveScene: Bool
//    @Binding var currentScreen: String
//    @State var toynumber: Int = 1
//
//    @Environment(\.managedObjectContext) var viewContext
//
//    func makeUIView(context: Context) -> ARView {
//
//        let arView = ARView(frame: .zero)
//        let conf = ARWorldTrackingConfiguration()
//        conf.planeDetection = [.horizontal, .vertical]
//
//        let model = try! ModelEntity.loadModel(named: "sofa.usdz")
//        model.generateCollisionShapes(recursive: true)
//        arView.installGestures(.all ,for: model)
//
//        let anchor = AnchorEntity(plane: .horizontal)
//        anchor.addChild(model)
//        anchor.name = "place anchor"
//        arView.scene.anchors.append(anchor)
//
//        arView.session.run(conf)
//        return arView
//    }
//
//    func updateUIView(_ uiView: ARView, context: Context) {
//        if placeObject{
//            do{
//                let conf = ARWorldTrackingConfiguration()
//                conf.planeDetection = [.horizontal, .vertical]
//
//                let model = try ModelEntity.loadModel(named: "toy_drummer.usdz")
//                model.generateCollisionShapes(recursive: true)
//                uiView.installGestures(.all ,for: model)
//
//                let anchor = AnchorEntity(plane: .horizontal)
//                anchor.addChild(model)
//                anchor.name = "toy number \(toynumber)"
//                uiView.scene.anchors.append(anchor)
//
//                uiView.session.run(conf)
//            }catch{
//                print(error.localizedDescription)
//            }
//            DispatchQueue.main.async {
//                placeObject = false
//                toynumber = toynumber + 1
//            }
//        }
//        if saveScene{
//
//            let firstObj = uiView.scene.anchors[0]
//            let room = Room(context: viewContext)
//            var set :Set<ModelObject> = []
//            for anc in uiView.scene.anchors{
//                let newobj = ModelObject(context: viewContext)
//                newobj.name = anc.name
//                newobj.id = UUID()
//                newobj.room = room
//                newobj.xcordinate = Double(anc.position(relativeTo: firstObj).x)
//                newobj.ycordinate = Double(anc.position(relativeTo: firstObj).y)
//                newobj.zcordinate = Double(anc.position(relativeTo: firstObj).z)
//                set.insert(newobj)
//            }
//            room.name = "some room"
//            room.id = UUID()
//            room.model = set
//
//
//            DispatchQueue.main.async {
//                saveScene = false
////                change screen
//                currentScreen = "home"
//                do{
//                    try viewContext.save()
//                }catch{
//                    print(error.localizedDescription)
//                }
//            }
//        }
//    }
//
//}
