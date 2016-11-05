
//  Copyright (c) 2016, Yuji
//  All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this
//  list of conditions and the following disclaimer.
//  2. Redistributions in binary form must reproduce the above copyright notice,
//  this list of conditions and the following disclaimer in the documentation
//  and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
//  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
//  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
//  The views and conclusions contained in the software and documentation are those
//  of the authors and should not be interpreted as representing official policies,
//  either expressed or implied, of the FreeBSD Project.
//
//  Created by yuuji on 9/5/16.
//  Copyright © 2016 yuuji. All rights reserved.
//


import struct Foundation.Data

public protocol SXService {
    var supportingMethods: SendMethods { get set }
    func recevied(data: Data, from connection: SXQueue) throws -> Bool
    func exceptionRaised(_ exception: Error, on connection: SXQueue)
}

public protocol SXStreamService : SXService {
    func accepting(socket: inout SXClientSocket)
    func connectionWillTerminate(_ connection: SXQueue)
    func connectionDidTerminate(_ connection: SXQueue)
}

open class SXConnectionService: SXStreamService {
    
    open func exceptionRaised(_ exception: Error, on connection: SXQueue) {}

    open var supportingMethods: SendMethods = [.send, .sendfile, .sendto]
    open func connectionDidTerminate(_ connection: SXQueue) {}
    open func connectionWillTerminate(_ connection: SXQueue) {}
    open func accepting(socket: inout SXClientSocket) {}
    
    open func recevied(data: Data, from connection: SXQueue) throws -> Bool {
        return try self.dataHandler(data, connection)
    }
    
    open var dataHandler: (Data, SXQueue) throws -> Bool
    
    public init(handler: @escaping (Data, SXQueue) throws -> Bool) {
        self.dataHandler = handler
    }
}



