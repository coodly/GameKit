/*
 * Copyright 2017 Coodly LLC
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

private extension Selector {
    static let tapped = #selector(View.tapped(recognizer:))
}

internal extension View {
    func attatchTapHandler() {
        let tap = UITapGestureRecognizer(target: self, action: .tapped)
        backingView.addGestureRecognizer(tap)
    }
    
    @objc fileprivate func tapped(recognizer: UITapGestureRecognizer) {
        guard acceptTouches else {
            return
        }
        
        let pointInView = recognizer.location(in: self.backingView)
        // flip the y value
        let converted = CGPoint(x: pointInView.x, y: size.height - pointInView.y)
        handleTap(at: converted)
    }
}
