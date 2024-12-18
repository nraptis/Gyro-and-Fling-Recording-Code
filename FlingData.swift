//
//  FlingData.swift
//  Jiggle3
//
//  Created by Nicky Taylor on 12/17/24.
//

#if FLING_CAPTURE

import Foundation

struct FlingData {
    struct FlingChunk {
        var powerX: Float
        var powerY: Float
    }
    var chunks = [FlingChunk]()
    
    func save(fileBuffer: FileBuffer) {
        if chunks.count > 0 {
            fileBuffer.writeBool(true)
            fileBuffer.writeInt32(Int32(chunks.count))
            for chunkIndex in 0..<chunks.count {
                fileBuffer.writeFloat32(chunks[chunkIndex].powerX)
                fileBuffer.writeFloat32(chunks[chunkIndex].powerY)
            }
        } else {
            fileBuffer.writeBool(false)
        }
    }
    
    mutating func load(fileBuffer: FileBuffer) {
        chunks.removeAll()
        if let read = fileBuffer.readBool() {
            if read == true {
                if let chunkCount = fileBuffer.readInt32() {
                    let chunkCount = Int(chunkCount)
                    chunks.reserveCapacity(chunkCount)
                    for chunkIndex in 0..<chunkCount {
                        let powerX = fileBuffer.readFloat32() ?? 0.0
                        let powerY = fileBuffer.readFloat32() ?? 0.0
                        let chunk = FlingChunk(powerX: powerX, powerY: powerY)
                        chunks.append(chunk)
                    }
                }
            }
        }
    }
    
}


#endif
