//
//  ArticlesAPI.swift
//  IACC
//
//  Created by Ambrose Mbayi on 03/10/2023.
//

import Foundation

struct Article: Equatable {
    let id: UUID
    let title: String
    let author: String
}

class ArticleAPI {
    static var shared = ArticleAPI()
    
    /// for demo purpose, this method simulates an API rquest with a pre-defined response and delay
    ///
    func loadArticles(competion: @escaping(Result<[Article], Error>)-> Void ){
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
            competion(.success([
                Article(id: UUID(), title: "iOS Architecture 101", author: "Mike A"),
                Article(id: UUID(), title: "Refactoring 101", author: "Caio Z")
            ]))
        }
    }
}
