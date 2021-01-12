//
//  Functions.swift
//  ReAnimation
//

import Foundation

enum Functions {

    static func packToArray<T, R>(_ function: @escaping (T) -> R) -> ((T) -> [R]) {
        { argument in
            [function(argument)]
        }
    }

    static func packToArray<T, R>(_ function: @escaping (T) -> (R, R)) -> ((T) -> [R]) {
        { argument in
            let result = function(argument)
            return [result.0, result.1]
        }
    }
}
