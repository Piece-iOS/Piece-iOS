//
//  APIResponseModel.swift
//  PCNetwork
//
//  Created by eunseou on 2/7/25.
//

struct APIResponse<T: Decodable>: Decodable {
    let status: String?
    let message: String?
    let data: T
}
