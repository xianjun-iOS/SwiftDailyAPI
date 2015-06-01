//
//  DailyAPISpecs.swift
//  SwiftDailyAPI
//
//  Created by Nicholas Tian on 27/05/2015.
//  Copyright (c) 2015 nickTD. All rights reserved.
//

import Quick
import Nimble
import SwiftDailyAPI

class DailyAPISpecs: QuickSpec {
  override func spec() {
    let api = DailyAPI(userAgent: "SwiftDailySpec")

    it("loads latest daily") {
      var latestDaily: LatestDaily? = nil

      api.latestDaily { latestDailyFromAPI in
        latestDaily = latestDailyFromAPI
      }

      expect(latestDaily).toEventuallyNot(beNil(), timeout: 10)
      expect(latestDaily!.date).toEventuallyNot(beNil(), timeout: 10)
      expect(latestDaily!.news).toEventuallyNot(beEmpty(), timeout: 10)
      expect(latestDaily!.topNews).toEventuallyNot(beEmpty(), timeout: 10)
    }

    it("loads daily news for a date") {
      var daily: Daily? = nil
      let date = NSDate.dateFromString("20150525", format: "yyyyMMdd")!

      api.daily(forDate: date) { dailyFromAPI in
        daily = dailyFromAPI
      }

      expect(daily).toEventuallyNot(beNil(), timeout: 10)
      expect(daily!.date).toEventually(equal(date), timeout: 10)
      expect(daily!.news).toEventuallyNot(beEmpty(), timeout: 10)
    }

    it("loads news for a newsId") {
      var news: News? = nil
      let newsId = 4770416

      api.news(newsId) { newsFromAPI in
        news = newsFromAPI
      }

      expect(news).toEventuallyNot(beNil(), timeout: 10)
      expect(news!.newsId).toEventually(equal(newsId), timeout: 10)
      expect(news!.title).toEventuallyNot(beNil(), timeout: 10)
      expect(news!.body).toEventuallyNot(beNil(), timeout: 10)
    }

    it("loads news extra for a newsId") {
      var newsExtra: NewsExtra? = nil
      let newsId = 4770416

      api.newsExtra(newsId) { newsExtraFromAPI in
        newsExtra = newsExtraFromAPI
      }

      expect(newsExtra).toEventuallyNot(beNil(), timeout: 10)
      expect(newsExtra!.popularity).toEventually(beGreaterThanOrEqualTo(0), timeout: 10)
      expect(newsExtra!.shortComments).toEventually(beGreaterThanOrEqualTo(0), timeout: 10)
      expect(newsExtra!.longComments).toEventually(beGreaterThanOrEqualTo(0), timeout: 10)
      expect(newsExtra!.comments).toEventually(beGreaterThanOrEqualTo(0), timeout: 10)
    }

    it("loads short comments") {
      var comments: Comments? = nil
      let newsId = 4772308 // `Comments.comments` won't be empty

      let request = api.shortComments(newsId) { commentsFromAPI in
        comments = commentsFromAPI
      }

      expect(request.request.URLString).to(contain("short"))
      expect(comments).toEventuallyNot(beNil(), timeout: 10)
      expect(comments!.comments).toEventuallyNot(beEmpty(), timeout: 10)
    }

    it("loads long comments") {
      var comments: Comments? = nil
      let newsId = 4772308 // `Comments.comments` won't be empty

      let request = api.longComments(newsId) { commentsFromAPI in
        comments = commentsFromAPI
      }

      expect(request.request.URLString).to(contain("long"))
      expect(comments).toEventuallyNot(beNil(), timeout: 10)
      expect(comments!.comments).toEventuallyNot(beEmpty(), timeout: 10)
    }

    it("loads all comments") {
      var shortComments: Comments? = nil
      var longComments: Comments? = nil
      let newsId = 4772308 // `Comments.comments` won't be empty

      let (shortCommentsRequest, longCommentsRequest) = api.comments(newsId, shortCommentsHandler: { shortCommentsFromAPI in
          shortComments = shortCommentsFromAPI
        }, longCommentsHandler: { longCommentsFromAPI in
          longComments = longCommentsFromAPI
      })

      expect(shortCommentsRequest.request.URLString).to(contain("short"))
      expect(longCommentsRequest.request.URLString).to(contain("long"))
      expect(shortComments).toEventuallyNot(beNil(), timeout: 10)
      expect(longComments).toEventuallyNot(beNil(), timeout: 10)
    }
  }
}
