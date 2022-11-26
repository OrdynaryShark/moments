import Foundation

struct Memo: Identifiable, Equatable, Codable {
    let id: UUID
    let text: String
    let date: Date
}

@MainActor
class MemosStore: ObservableObject {
    
    @Published
    var memos: [Memo] = []
    
    private let databaseUrl = FileManager
        .default
        .urls(for: .documentDirectory, in: .userDomainMask)
        .first!
        .appending(path: "memos.db")
    
    func createMemo(text: String, date: Date) async -> Void {
        var memos = memos
        
        memos.append(Memo(
            id: UUID(),
            text: text,
            date: date
        ))
        
        do {
            let encodedMemos = try JSONEncoder().encode(memos)
            try encodedMemos.write(to: databaseUrl)
        } catch {
            print(error)
        }
        
        self.memos = memos
    }
    
    func loadMemos() async {
        do {
            let dbContent = try Data(contentsOf: databaseUrl)
            memos = try JSONDecoder().decode([Memo].self, from: dbContent)
        } catch {
            print(error)
        }
    }
    
    init(memos: [Memo]) {
        self.memos = memos
    }
    
    convenience init() {
        self.init(memos: [])
    }
    
}
