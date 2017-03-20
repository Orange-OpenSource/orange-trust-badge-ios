/*
 *
 * OrangeTrustBadge
 *
 * File name:   TrustBadgeDelegate.swift
 * Created:     17/03/2017
 * Created by:  Sylvain CAMUS
 *
 * Copyright 2017 Orange
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import Foundation

public protocol TrustBadgeDelegate: class {

    /// Gets the localized string for a wording key.
    /// - Parameters:
    ///   - key: The wording key to localize.
    /// - Returns:
    /// The localized string or `nil` to use the default localized string.
    func localizedTrustBadgeString(forKey key: String) -> String?
}

public extension TrustBadgeDelegate {

    func localizedTrustBadgeString(forKey key: String) -> String? {
        return nil
    }
}
