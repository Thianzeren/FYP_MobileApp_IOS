//
//  SocketHandler.swift
//  Engagingu
//
//  Created by Nicholas on 19/1/19.
//  Copyright © 2019 Raylene. All rights reserved.
//

import Foundation
import SocketIO

class SocketHandler {
    
    static let manager: SocketManager = SocketManager(socketURL: URL(string: "http://54.255.245.23:3000")!, config: [.log(true), .compress])
    static var socket: SocketIOClient =  manager.defaultSocket

    
    static func connectSocket(){
        
        socket.connect()
        
    }
    
    static func getSocket() -> SocketIOClient{
        
        return socket
        
    }
    
    static func addHandlers() {
        
        socket.on(clientEvent: .connect) {data, ack in
            print("socket connected")
        }
        
        socket.on("activityFeed") {data, ack in

            print("SOCKET BODY FROM activityFeed")
            print(data)
            
            do{
                let jsonData = data as? [[String:String]]
                let msg = jsonData![0]
                let activity = Activity(team: msg["team"] ?? "team", hotspot: msg["hotspot"] ?? "hotspot", time: msg["time"] ?? "time")
                
                InstanceDAO.activityArr.append(activity)
                
            }catch let jsonErr{
                
                print("Error serializing json:", jsonErr)
            }
        }
        
        socket.onAny {print("Got event: \($0.event), with items: \($0.items!)")}
        
    }

}

