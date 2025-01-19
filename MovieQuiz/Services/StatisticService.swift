import Foundation
protocol StatisticService {
    var totalAccuracy: Double { get }
    var gamesCount: Int { get }
    var bestGame: GameRecord { get }
    
    func store(correct count: Int, total amount: Int)
}
final class StatisticServiceImplementation: StatisticService {
    
    private let userDefaults = UserDefaults.standard
    
    private enum Keys: String {
        case correct, total, bestGame, gamesCount
    }
    var totalAccuracy: Double {
        get {
            userDefaults.double(forKey: "totalAccuracy")
        }
        set {
            userDefaults.set(newValue, forKey: "totalAccuracy")
        }
        
    }
    
    var gamesCount: Int {
        get {
            userDefaults.integer(forKey: "gamesCount")
        }
        set {
            userDefaults.set(newValue, forKey: "gamesCount")
        }
        
    }
    
    var bestGame: GameRecord {
        get {
            let correctCount = userDefaults.integer(forKey: "correct")
            let totalCount = userDefaults.integer(forKey: "total")
            let date = userDefaults.object(forKey: "date") as? Date ?? Date()
            return GameRecord(correct: correctCount, total: totalCount, date: date)
        }
        set {
            userDefaults.set(newValue.correct, forKey: "correct")
            userDefaults.set(newValue.total, forKey: "total")
            userDefaults.set(newValue.date, forKey: "date")
        }
    }
    
    func store(correct count: Int, total amount: Int) {
        let newRecord = GameRecord(correct: count, total: amount, date: Date())
        if newRecord.isBetterThan(bestGame) {
            bestGame = newRecord
        }
        gamesCount += 1
        totalAccuracy = (totalAccuracy + Double(count)) / (Double(amount))
    }
}
