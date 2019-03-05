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
    
    static let manager: SocketManager = SocketManager(socketURL: URL(string: InstanceDAO.serverIP)!, config: [.log(true), .compress])
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
            
            let jsonData = data as? [[String:String]]
            let msg = jsonData![0]
            let activity = Activity(team: msg["team"] ?? "team", hotspot: msg["hotspot"] ?? "hotspot", time: msg["time"] ?? "time")
            
            InstanceDAO.activityArr.append(activity)
            
            if(!InstanceDAO.isLeader){
                
                if let hotspot = msg["hotspot"]{
                    if let team = msg["team"] {
                        if team == InstanceDAO.team_id{
                            InstanceDAO.isFirstTime = false
                            InstanceDAO.completedList.append(hotspot)
                        }
                    }
                }
                
            }
                
            
        }
        
//        socket.on("notification") {data, ack in
//
//
//
//        }
        
//        socket.on("startTrail"){ data, ack in
//            
//            InstanceDAO.hasStartedTrail = true
//            
//        }
        
//        socket.onAny {print("Got event: \($0.event), with items: \($0.items!)")}
        
    }

}

