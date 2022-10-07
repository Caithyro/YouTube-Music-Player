//
//  NetworkService.swift
//  YouTube Music Player
//
//  Created by Дмитрий Куприенко on 07.10.2022.
//

import Foundation
import Alamofire

class NetworkService {
    
    static let shared = NetworkService()
    
    private var topPlaylistResponceDataArray: [PlaylistItems] = []
    private var topStatisticsResponceDataArray: [StatisticsItems] = []
    private var topPlaylistSnippetResponceDataArray: [PlaylistSnippetItems] = []
    private var bottomPlaylistResponceDataArray: [PlaylistItems] = []
    private var bottomStatisticsResponceDataArray: [StatisticsItems] = []
    private var bottomPlaylistSnippetResponceDataArray: [PlaylistSnippetItems] = []
    
    func fetchDataForTopGallery(playlistId: String, completion: @escaping(([PlaylistItems]) -> ())) {
        
        let requestFirstPageURLString = "https://youtube.googleapis.com/youtube/v3/playlistItems?part=snippet&maxResults=10&playlistId=\(playlistId)&key=AIzaSyC4i7YntmeRWeUesx5NA8__0t4FgIwN5ko"
        
        AF.request(requestFirstPageURLString).response { [self] playlistResponceData in
            
            do {
                
                self.topPlaylistResponceDataArray.removeAll()
                var indexForAppend = 0
                let jsonDecoder = JSONDecoder()
                let responceModel = try jsonDecoder.decode(PlaylistResponce.self, from: playlistResponceData.data!)
                for _ in responceModel.playlistItems! {
                    self.topPlaylistResponceDataArray.append(responceModel.playlistItems![indexForAppend])
                    indexForAppend += 1
                    completion(topPlaylistResponceDataArray)
                }
                indexForAppend = 0
            } catch {
                print(error)
            }
        }
    }
    
    func fetchSecondPageOfData(playlistId: String, nextPageToken: String, completion: @escaping(([PlaylistItems]) -> ())) {
        
        let requestSecondPageURLString = "https://youtube.googleapis.com/youtube/v3/playlistItems?part=snippet&pageToken=\(nextPageToken)&playlistId=\(playlistId)&key=AIzaSyC4i7YntmeRWeUesx5NA8__0t4FgIwN5ko"
        
        AF.request(requestSecondPageURLString).response { [self] playlistResponceData1 in
            
            do {
                
                var indexForAppend = 0
                let jsonDecoder = JSONDecoder()
                let secondPageResponceModel = try jsonDecoder.decode(PlaylistResponce.self, from: playlistResponceData1.data!)
                for _ in secondPageResponceModel.playlistItems! {
                    self.topPlaylistResponceDataArray.append(secondPageResponceModel.playlistItems![indexForAppend])
                    indexForAppend += 1
                }
                indexForAppend = 0
                completion(topPlaylistResponceDataArray)
            } catch {
                print(error)
            }
        }
    }
    
    func fetchDataForBottomGallery(playlistId: String, completion: @escaping(([PlaylistItems]) -> ())) {
        
        let requestFirstPageURLString = "https://youtube.googleapis.com/youtube/v3/playlistItems?part=snippet&playlistId=\(playlistId)&key=AIzaSyC4i7YntmeRWeUesx5NA8__0t4FgIwN5ko"
        
        AF.request(requestFirstPageURLString).response { [self] playlistResponceData in
            
            do {
                
                self.topPlaylistResponceDataArray.removeAll()
                var indexForAppend = 0
                let jsonDecoder = JSONDecoder()
                let responceModel = try jsonDecoder.decode(PlaylistResponce.self, from: playlistResponceData.data!)
                for _ in responceModel.playlistItems! {
                    self.bottomPlaylistResponceDataArray.append(responceModel.playlistItems![indexForAppend])
                    indexForAppend += 1
                }
                
                let requestSecondPageURLString = "https://youtube.googleapis.com/youtube/v3/playlistItems?part=snippet&pageToken=\( responceModel.nextPageToken!)&playlistId=\(playlistId)&key=AIzaSyC4i7YntmeRWeUesx5NA8__0t4FgIwN5ko"
                
                AF.request(requestSecondPageURLString).response { [self] playlistResponceData1 in
                    
                    do {
                        
                        indexForAppend = 0
                        let secondPageResponceModel = try jsonDecoder.decode(PlaylistResponce.self, from: playlistResponceData1.data!)
                        for _ in secondPageResponceModel.playlistItems! {
                            self.bottomPlaylistResponceDataArray.append(secondPageResponceModel.playlistItems![indexForAppend])
                            indexForAppend += 1
                        }
                        completion(bottomPlaylistResponceDataArray)
                        indexForAppend = 0
                    } catch {
                        print(error)
                    }
                }
            } catch {
                print(error)
            }
        }
    }
    
    func fetchViewsCountForTopGallery(videoID: String, completion: @escaping (([StatisticsItems]) -> ())) {
        
        let requestURLString = "https://youtube.googleapis.com/youtube/v3/videos?part=statistics&id=\(videoID)&key=AIzaSyC4i7YntmeRWeUesx5NA8__0t4FgIwN5ko"
        
        AF.request(requestURLString).response { [self] statisticsResponceData in
            
            do {
                
                self.topStatisticsResponceDataArray.removeAll()
                var indexForAppend = 0
                let jsonDecoder = JSONDecoder()
                let responceModel = try jsonDecoder.decode(StatisticsResponce.self, from: statisticsResponceData.data!)
                for _ in responceModel.statisticsItems! {
                    self.topStatisticsResponceDataArray.append(responceModel.statisticsItems![indexForAppend])
                    indexForAppend += 1
                }
                completion(topStatisticsResponceDataArray)
                
                indexForAppend = 0
            } catch {
                print(error)
            }
        }
    }
    
    func fetchViewsCountForBottomGallery(videoID: String, completion: @escaping (([StatisticsItems]) -> ())) {
        
        let requestURLString = "https://youtube.googleapis.com/youtube/v3/videos?part=statistics&id=\(videoID)&key=AIzaSyC4i7YntmeRWeUesx5NA8__0t4FgIwN5ko"
        
        AF.request(requestURLString).response { [self] statisticsResponceData in
            
            do {
                
                self.topStatisticsResponceDataArray.removeAll()
                var indexForAppend = 0
                let jsonDecoder = JSONDecoder()
                let responceModel = try jsonDecoder.decode(StatisticsResponce.self, from: statisticsResponceData.data!)
                for _ in responceModel.statisticsItems! {
                    self.bottomStatisticsResponceDataArray.append(responceModel.statisticsItems![indexForAppend])
                    indexForAppend += 1
                }
                completion(bottomStatisticsResponceDataArray)
                
                indexForAppend = 0
            } catch {
                print(error)
            }
        }
    }
    
    func fetchPlaylistNameForTopGallery(playlistID: String, completion: @escaping(([PlaylistSnippetItems]) -> ())) {
        
        let requestURLString = "https://youtube.googleapis.com/youtube/v3/playlists?part=snippet&id=\(playlistID)&key=AIzaSyC4i7YntmeRWeUesx5NA8__0t4FgIwN5ko"
        
        AF.request(requestURLString).response { [self] playlistSnippetResponceData in
            
            do {
                self.topPlaylistSnippetResponceDataArray.removeAll()
                var indexForAppend = 0
                let jsonDecoder = JSONDecoder()
                let responceModel = try jsonDecoder.decode(PlaylistSnippetItemsResponce.self, from: playlistSnippetResponceData.data!)
                for _ in responceModel.items! {
                    self.topPlaylistSnippetResponceDataArray.append(responceModel.items![indexForAppend])
                    indexForAppend += 1
                }
                completion(topPlaylistSnippetResponceDataArray)
                
                indexForAppend = 0
            } catch {
                print(error)
            }
        }
    }
    
    func fetchPlaylistNameForBottomGallery(playlistID: String, completion: @escaping(([PlaylistSnippetItems]) -> ())) {
        
        let requestURLString = "https://youtube.googleapis.com/youtube/v3/playlists?part=snippet&id=\(playlistID)&key=AIzaSyC4i7YntmeRWeUesx5NA8__0t4FgIwN5ko"
        
        AF.request(requestURLString).response { [self] playlistSnippetResponceData in
            
            do {
                self.topPlaylistSnippetResponceDataArray.removeAll()
                var indexForAppend = 0
                let jsonDecoder = JSONDecoder()
                let responceModel = try jsonDecoder.decode(PlaylistSnippetItemsResponce.self, from: playlistSnippetResponceData.data!)
                for _ in responceModel.items! {
                    self.bottomPlaylistSnippetResponceDataArray.append(responceModel.items![indexForAppend])
                    indexForAppend += 1
                }
                completion(bottomPlaylistSnippetResponceDataArray)
                
                indexForAppend = 0
            } catch {
                print(error)
            }
        }
    }
}
