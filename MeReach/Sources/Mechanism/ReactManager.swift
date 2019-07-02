//
//  ReactManager.swift
//  MeReach
//
//  Created by Marcos Kobuchi on 02/07/19.
//  Copyright © 2019 Marcos Kobuchi. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

/// This class contains shared resources from RxSwift and RxCocoa
class ReactManager {
    
    static let shared: ReactManager = ReactManager()
    
    let disposeBag: DisposeBag = DisposeBag()
    
    // avoid instantiation
    private init() {
    }
    
}
