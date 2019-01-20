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
        
        socket.on("connect") {data, ack in

            print("SOCKET BODY FROM randomconnect")
            print(data)
            print(ack)
            
            //            guard let cur = data[0] as? Double else { return }
            //
            //            self.socket.emitWithAck("canUpdate", cur).timingOut(after: 0) {data in
            //                self.socket.emit("update", ["amount": cur + 2.50])
            //            }
            //
            //            ack.with("Got your currentAmount", "dude")
        }
        
        socket.onAny {print("Got event: \($0.event), with items: \($0.items!)")}
        
    }

}

