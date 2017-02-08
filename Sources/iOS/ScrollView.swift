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

public class ScrollView: View, UIScrollViewDelegate {
    private lazy var shadowScroll: UIScrollView = {
        let scroll = UIScrollView()
        scroll.delegate = self
        return scroll
    }()
    
    override internal var reference: PlatformView {
        return shadowScroll
    }

    internal var contained: ScrollViewContained?
    internal var contentOffsetY: CGFloat {
        return scrollView?.contentOffset.y ?? 0
    }
    private var scrollView: UIScrollView? {
        return reference as? UIScrollView
    }
    internal var contentSize: CGSize = .zero {
        didSet {
            scrollView?.contentSize = contentSize
        }
    }
    public var contentInset: EdgeInsets = .zero {
        didSet {
            scrollView?.contentInset = contentInset
            scrollView?.scrollIndicatorInsets = contentInset
        }
    }
    
    override func sizeChanged() {
        super.sizeChanged()
        
        positionPresentedNode()
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        positionPresentedNode()
    }
}
