//
//  WaterVM.swift
//  HealthFlow
//
//  Created by Yaren Uyan on 20.12.2023.
//

import Foundation
import Firebase
import FirebaseFirestore

class WaterVM{
    var waterModel: WaterModel!
    var addedMl: Int! = 0{
        didSet{
            self.waterModel.millilitre = addedMl
        }
    }
    
    var totalMl: Int! = 0 {
        didSet{
            self.waterModel.totalMl = totalMl
            self.waterDelegate.setUpProgressView()
        }
    }
    
    var addedWaterArray: [WaterModel] = []
    var waterProgress: Double = 0
    var waterDelegate: WaterDelegate!
    var idealWaterIntake: Double? 
//    {
//        didSet{
//            self.waterModel.idealWater = idealWaterIntake
//        }
//    }
    var userModel: UserModel?
    var mainDelegate: MainVCDelegate?
    
    func formattedTime() -> String {
        guard let date = waterModel.date else {return ""}
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        return timeFormatter.string(from: date)
    }
    
    //    func formattedDate() -> String{
    //        guard let day = waterModel.day else {return ""}
    //        let dateFormatter = DateFormatter()
    //        dateFormatter.dateFormat = "yyyy-MM-dd"
    //        return dateFormatter.string(from: day)
    //    }
    
    func setWaterModel(ml: Int){
        self.addedMl = ml
        self.totalMl += self.addedMl
        
        let currentDate = Date()
        waterModel.date = currentDate
    }
    
    
    func calculateProgress() -> Double{
        var totalWater: Double = 0
        totalWater = Double(self.totalMl)
        guard let idealWaterIntake = self.idealWaterIntake else {return 0}
        waterProgress = (totalWater / idealWaterIntake)
        
        mainDelegate?.updateWaterIntakeLabel(intakeWater: Int(totalWater), idealIntakeWater: Int(idealWaterIntake))
        return waterProgress
        
    }
    
    func calculateIdealIntake(){
        guard let weight = userModel?.weight else {return}
        idealWaterIntake = (Double((weight / 8)) * 250)
    }
    
    
    //MARK: Firebase Logic
    func getWaterInfo(){
        getAddedWaterInfo { [weak self] res in
            switch res{
            case .success(let waterArray):
                self?.addedWaterArray = waterArray
            case .failure(let error):
                print(error)
            }
        }
    }

    func getAddedWaterInfo(completion: @escaping (Result<[WaterModel], Error>) -> Void){
        guard let user = Auth.auth().currentUser else { return }
        let uid = user.uid
        let db = Firestore.firestore()
        
        let waterEntriesCollectionRef = db.collection("water").document(uid).collection("waterEntries")
        let currentDate = Date()
        let startOfDay = Calendar.current.startOfDay(for: currentDate)
        let endOfDay = Calendar.current.date(byAdding: .day, value: 1, to: startOfDay)!
        
        waterEntriesCollectionRef
            .whereField("date", isGreaterThanOrEqualTo: startOfDay)
            .whereField("date", isLessThan: endOfDay)
            .order(by: "date", descending: true)
            
            .getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            for document in querySnapshot!.documents {
                print("Belge Verileri: \(document.data())")
                let water = WaterModel(data: document.data())
                self.addedWaterArray.append(water)
            }
            
            completion(.success(self.addedWaterArray))
        }
    }
    
    func getTotalMlFromFirebase(completion: @escaping (Int) -> Void) {
        guard let user = Auth.auth().currentUser else { return }
        let uid = user.uid
        let db = Firestore.firestore()
        
        let currentDate = Date()
        let startOfDay = Calendar.current.startOfDay(for: currentDate)
        let endOfDay = Calendar.current.date(byAdding: .day, value: 1, to: startOfDay)!
        
        let waterEntriesCollectionRef = db.collection("water").document(uid).collection("waterEntries")
        
        waterEntriesCollectionRef
            .whereField("date", isGreaterThanOrEqualTo: startOfDay)
            .whereField("date", isLessThan: endOfDay)
            .order(by: "date", descending: true)
            .limit(to: 1)
        
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("TotalMl Çekme Hatası: \(error.localizedDescription)")
                    completion(0)
                    return
                }
                
                if let document = querySnapshot?.documents.first {
                    do {
                        let water = try document.data(as: WaterModel.self)
                        if let totalMl = water.totalMl {
                            completion(totalMl)
                        } else {
                            completion(0)
                        }
                    } catch {
                        print("Veri çevrimi başarısız: \(error.localizedDescription)")
                        completion(0)
                    }
                } else {
                    completion(0)
                }
            }
    }
    
//    func getWeeklyTotalMl(completion: @escaping ([Double]) -> Void) {
//        guard let user = Auth.auth().currentUser else { return }
//        let uid = user.uid
//        let db = Firestore.firestore()
//
//        let waterEntriesCollectionRef = db.collection("water").document(uid).collection("waterEntries")
//
////        guard let startOfWeek = getStartOfWeek() else {return}
//        let currentDate = Date()
//        var calendar = Calendar.current
//        calendar.firstWeekday = 2
//        let today = calendar.startOfDay(for: currentDate)
//        let localDate = calendar.date(byAdding: .second, value: TimeZone.current.secondsFromGMT(), to: today)!
//
//        guard let startOfWeek = calendar.date(byAdding: .day, value: -(calendar.component(.weekday, from: localDate)), to: localDate) else {return}
//        let endOfWeek = calendar.date(byAdding: .day, value: 6, to: startOfWeek)!
//
//        var weeklyTotalMlValues: [Double] = []
//        let dispatchGroup = DispatchGroup()
//
//        for day in 0...6 {
//            let currentDate = calendar.date(byAdding: .day, value: day, to: startOfWeek) ?? localDate
//            let endOfDay = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: currentDate)!
//
//            dispatchGroup.enter()
//
//            waterEntriesCollectionRef
//                .whereField("date", isGreaterThanOrEqualTo: currentDate)
//                .whereField("date", isLessThanOrEqualTo: endOfDay)
//                .order(by: "date", descending: true)
//                .limit(to: 1)
//                .getDocuments { (querySnapshot, error) in
//
//                    if let document = querySnapshot?.documents.first,
//                        let dailyTotalMl = document.data()["totalMl"] as? Double {
//                        weeklyTotalMlValues.append(dailyTotalMl)
//
//                        print("Gün: \(day), Toplam Su Miktarı: \(dailyTotalMl) ml")
//
//                    } else {
//                        weeklyTotalMlValues.append(0)
//                    }
//
//                    dispatchGroup.leave()
//                }
//        }
//
//        dispatchGroup.notify(queue: .main) {
//            completion(weeklyTotalMlValues)
//        }
//    }
    
    func getWeeklyTotalMl(completion: @escaping ([Double]) -> Void) {
        guard let user = Auth.auth().currentUser else { return }
        let uid = user.uid
        let db = Firestore.firestore()

        let waterEntriesCollectionRef = db.collection("water").document(uid).collection("waterEntries")

        let currentDate = Date()
        var calendar = Calendar.current
        calendar.firstWeekday = 1
        let today = calendar.startOfDay(for: currentDate)
        let localDate = calendar.date(byAdding: .second, value: TimeZone.current.secondsFromGMT(), to: today)!

        guard let startOfWeek = calendar.date(byAdding: .day, value: -(calendar.component(.weekday, from: localDate) - 1), to: localDate) else { return }
        let endOfWeek = calendar.date(byAdding: .day, value: 6, to: startOfWeek)!

        var weeklyTotalMlValues: [Double] = []
        var resultsDictionary: [Int: Double] = [:] 

        let dispatchGroup = DispatchGroup()

        for day in 0...6 {
            let currentDate: Date
            if day > 0 {
                currentDate = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: calendar.date(byAdding: .day, value: day - 1, to: startOfWeek)!)!
            } else {
                currentDate = calendar.startOfDay(for: startOfWeek)
            }
            let endOfDay = calendar.date(byAdding: .day, value: 1, to: currentDate)!.addingTimeInterval(-1)
            print(currentDate)
            print(endOfDay)
            dispatchGroup.enter()

            DispatchQueue.global(qos: .background).async {
                waterEntriesCollectionRef
                    .whereField("date", isGreaterThanOrEqualTo: currentDate)
                    .whereField("date", isLessThanOrEqualTo: endOfDay)
                    .order(by: "date", descending: true)
                    .limit(to: 1)
                    .getDocuments { (querySnapshot, error) in
                        defer {
                            dispatchGroup.leave()
                        }

                        if let document = querySnapshot?.documents.first,
                            let dailyTotalMl = document.data()["totalMl"] as? Double {
                            resultsDictionary[day] = dailyTotalMl  // Sözlüğe ekleyin

                            print("Gün: \(day), Toplam Su Miktarı: \(dailyTotalMl) ml")

                        } else {
                            resultsDictionary[day] = 0
                            print("Gün: \(day), Toplam Su Miktarı: \(0) ml")
                        }
                    }
            }
        }

        dispatchGroup.notify(queue: .main) {
            let sortedResults = (0...6).map { resultsDictionary[$0] ?? 0 }
            completion(sortedResults)
        }
    }

    func addWaterToFirebase(waterMod: WaterModel){
        
        func waterModelToMap(waterModel: WaterModel) -> [String:Any]{
            return [
                "millilitre": waterModel.millilitre,
                "date": waterModel.date,
                "totalMl": waterModel.totalMl,
                "idealWater": waterModel.idealWater
            ]
        }
        
        if let user = Auth.auth().currentUser {
            let uid = user.uid
            let db = Firestore.firestore()
            
            let userDocRef = db.collection("water").document(uid).collection("waterEntries")
            
            userDocRef.addDocument(data: waterModelToMap(waterModel: waterMod)) { error in
                if let error = error {
                    print("Doküman oluşturma hatası: \(error.localizedDescription)")
                } else {
                    print("Doküman oluşturuldu!")
                    self.getWaterInfo()
                    self.waterDelegate.updateWaterModelArray()
                }
            }
        }
    }
    
    
}


extension Timestamp {
    func toDate() -> Date {
        return dateValue()
    }
}
