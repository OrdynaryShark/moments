//
//  ContentView.swift
//  Moments
//
//  Created by Andrew on 26.11.2022.
//

import SwiftUI

struct ContentView: View {
    
    @State
    var isMemoCreatingShown = false
    
    @EnvironmentObject
    var store: MemosStore
    
    var body: some View {
        NavigationView {
            VStack(spacing: .zero) {
                ScrollView {
                    LazyVStack {
                        ForEach(store.memos.sorted(by: { $0.date > $1.date})) { memo in
                            MemoryCell(memo: memo).padding()
                        }
                    }
                }
                Button {
                    isMemoCreatingShown.toggle()
                } label: {
                    Text("Add memo")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(.blue)
                        .cornerRadius(10)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(.regularMaterial)
            }
            .navigationTitle("Memos")
        }
        .task {
            await store.loadMemos()
        }
        .sheet(isPresented: $isMemoCreatingShown) {
            CreateMemo {
                isMemoCreatingShown.toggle()
            }
        }
    }
}

struct CreateMemo: View {
    
    @EnvironmentObject
    var store: MemosStore
    
    @State
    var memoText: String = ""
    
    var onFinish: () -> Void
    
    var body: some View {
        NavigationView {
            Form {
                Section("Describe your memo") {
                    TextEditor(text: $memoText).frame(minHeight: 100)
                }
            }
            .toolbar {
                Button("Create") {
                    Task {
                        await createMemo()
                    }
                }
            }
            .navigationTitle("Create memo")
        }
    }
    
    func createMemo() async {
        await store.createMemo(
            text: memoText,
            date: .now
        )
        onFinish()
    }
    
}

struct MemoryCell: View {
    
    let memo: Memo
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                DateLabel(date: memo.date)
                Spacer()
            }
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    if !memo.text.isEmpty {
                        Text(memo.text)
                    }
                }
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal)
        }
        .frame(maxWidth: .infinity)
    }
    
}

struct DateLabel: View {
    
    let date: Date
    
    var body: some View {
        Text(date.formatted(date: .abbreviated, time: .standard))
            .foregroundColor(.gray)
            .padding(.horizontal, 8)
            .padding(.vertical, 2)
            .background(.thinMaterial)
            .cornerRadius(8)
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(MemosStore(memos: [
                Memo(id: UUID(), text: "Hello", date: .now),
                Memo(id: UUID(), text: "Hello", date: .now)
            ]))
    }
}
