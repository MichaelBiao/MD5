//
//  MD5.swift
//  MD5
//
//  Created by BiaoShu on 2016/12/26.
//  Copyright © 2016年 BiaoShu. All rights reserved.
//

import Foundation
let shift : [UInt32] = [7, 12, 17, 22, 5, 9, 14, 20, 4, 11, 16, 23, 6, 10, 15, 21]
let table: [UInt32] = (0 ..< 64).map { UInt32(0x100000000 * abs(sin(Double($0 + 1)))) }

func md5( message: [UInt8]) -> [UInt8] {
    var message = message
    let messageLenBits = UInt64(message.count) * 8
    message.append(0x80)
    while message.count % 64 != 56 {
        message.append(0)
    }
    
    var lengthBytes = [UInt8](repeating: 0, count: 8)
    lengthBytes.withUnsafeMutableBytes {
        $0.storeBytes(of: messageLenBits.littleEndian, as: UInt64.self)
    }
    message += lengthBytes
    
    var a : UInt32 = 0x67452301
    var b : UInt32 = 0xEFCDAB89
    var c : UInt32 = 0x98BADCFE
    var d : UInt32 = 0x10325476
    for chunkOffset in stride(from: 0, to: message.count, by: 64) {
        (UnsafePointer(message) + chunkOffset).withMemoryRebound(to: UInt32.self, capacity: 16) {
            chunk in
            
            let originalA = a
            let originalB = b
            let originalC = c
            let originalD = d
            for j in 0 ..< 64 {
                var f : UInt32 = 0
                var bufferIndex = j
                let round = j >> 4
                switch round {
                case 0:
                    f = (b & c) | (~b & d)
                case 1:
                    f = (b & d) | (c & ~d)
                    bufferIndex = (bufferIndex*5 + 1) & 0x0F
                case 2:
                    f = b ^ c ^ d
                    bufferIndex = (bufferIndex*3 + 5) & 0x0F
                case 3:
                    f = c ^ (b | ~d)
                    bufferIndex = (bufferIndex * 7) & 0x0F
                default:
                    assert(false)
                }
                let sa = shift[(round<<2)|(j&3)]
                let tmp = a &+ f &+ UInt32(littleEndian: chunk[bufferIndex]) &+ table[j]
                a = d
                d = c
                c = b
                b = b &+ (tmp << sa | tmp >> (32-sa))
            }
            a = a &+ originalA
            b = b &+ originalB
            c = c &+ originalC
            d = d &+ originalD
        }
    }
    var result = [UInt8](repeating: 0, count: 16)
    result.withUnsafeMutableBytes { ptr in
        ptr.storeBytes(of: a.littleEndian, toByteOffset: 0, as: UInt32.self)
        ptr.storeBytes(of: b.littleEndian, toByteOffset: 4, as: UInt32.self)
        ptr.storeBytes(of: c.littleEndian, toByteOffset: 8, as: UInt32.self)
        ptr.storeBytes(of: d.littleEndian, toByteOffset: 12, as: UInt32.self)
    }
    return result
}

func toHexString(bytes: [UInt8]) -> String {
    return bytes.map {String(format:"%02x",$0)}.joined()
}


