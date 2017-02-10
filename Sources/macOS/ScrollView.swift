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
    static let scrolled = #selector(ScrollView.didScroll(notification:))
}

public class ScrollView: View {
    override var backingView: PlatformView {
        return scrollView
    }
    internal var contained: ScrollViewContained? {
        didSet {
            oldValue?.backingView.removeFromSuperview()
            oldValue?.removeFromParent()
            
            guard let contained = contained else {
                return
            }
            
            contained.backingView.translatesAutoresizingMaskIntoConstraints = false
            scrollView.documentView = contained.backingView
        }
    }
    
    internal var contentOffsetY: CGFloat {
        return scrollView.contentView.visibleRect.origin.y
    }
    private lazy var scrollView: NSScrollView = {
        let view = NSScrollView(frame: .zero)
        view.drawsBackground = false
        view.hasVerticalScroller = true
        view.automaticallyAdjustsContentInsets = false
        NotificationCenter.default.addObserver(self, selector: .scrolled, name: NSNotification.Name.NSScrollViewDidLiveScroll, object: nil)
        
        return view
    }()
    internal var contentSize: CGSize = .zero {
        didSet {
            guard let containedBacking = contained?.backingView else {
                return
            }
            containedBacking.frame.origin.x = max(0, (scrollView.frame.width - containedBacking.frame.width) / 2)
            contained?.backingView.frame.size = contentSize
        }
    }
    public var contentInset: EdgeInsets = NSEdgeInsetsZero
    public var verticallyCentered = false
    
    @objc fileprivate func didScroll(notification: NSNotification) {
        guard let object = notification.object as? NSScrollView, scrollView === object else {
            return
        }
        
        positionPresentedNode()
    }
    
    override func sizeChanged() {
        super.sizeChanged()
        
        positionPresentedNode()
    }
}
