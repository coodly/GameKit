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

import SpriteKit

public class ScrollView: View, UIScrollViewDelegate {
    private lazy var scrollView: ShadowScrollView = {
        let scroll = ShadowScrollView()
        scroll.attached = self
        return scroll
    }()
    
    override internal var backingView: PlatformView {
        return scrollView
    }

    internal var contained: ScrollViewContained? {
        didSet {
            oldValue?.backingView.removeFromSuperview()
            oldValue?.removeFromParent()
            
            guard let contained = contained else {
                return
            }
            
            scrollView.addSubview(contained.backingView)
        }
    }
    internal var contentOffsetY: CGFloat {
        return scrollView.contentOffset.y
    }
    internal var contentSize: CGSize = .zero {
        didSet {
            scrollView.contentSize = contentSize
            
            if verticallyCentered {
                let spacing = max(0, (backingView.frame.size.height - contentSize.height) / 2)
                scrollView.contentInset = UIEdgeInsetsMake(spacing, 0, spacing, 0)
            }
            
            guard let containedBacking = contained?.backingView else {
                return
            }
            containedBacking.frame.origin.x = max(0, (scrollView.frame.width - containedBacking.frame.width) / 2)
            contained?.backingView.frame.size = contentSize
        }
    }
    public var contentInset: EdgeInsets = .zero
    internal var presentationInset: EdgeInsets = .zero {
        didSet {
            scrollView.contentInset = presentationInset
            scrollView.scrollIndicatorInsets = presentationInset
        }
    }
    public var verticallyCentered = false
    
    public override func positionChildren() {
        super.positionChildren()

        contained?.presentationWidth = size.width
        positionPresentedNode()
    }
    
    public override func set(color: SKColor, for attribute: Appearance.Attribute) {
        // no op
    }
    
    internal func scroll(to point: CGPoint, animated: Bool) {
        let saneYOffset = min(point.y, scrollView.contentSize.height - scrollView.bounds.height)
        scrollView.setContentOffset(CGPoint(x: 0, y: saneYOffset), animated: animated)
    }
    
    public func present(_ contained: ScrollViewContained) {
        self.contained = contained
        contained.scrollView = self
        contained.anchorPoint = .zero
        contentSize = contained.size
        addChild(contained)
        
        contained.inflate()
        positionPresentedNode()
    }
    
    internal func positionPresentedNode() {
        guard let contained = contained else {
            return
        }
        
        let offset = contentOffsetY
        let nextPosition = CGPoint(x: (size.width - contained.size.width) / 2, y: -contained.size.height + size.height + offset)
        
        let moveAction = SKAction.move(to: nextPosition, duration: 0)
        
        let notifyAction = SKAction.run() {
            let bottomPoint = self.translatePointToContent(CGPoint(x: 0, y: 0))
            let topPoint = self.translatePointToContent(CGPoint(x: 0, y: self.size.height))
            
            var visible = CGRect.zero
            visible.origin = CGPoint(x: 0, y: bottomPoint.y)
            visible.size = CGSize(width: self.contained!.size.width, height: topPoint.y - bottomPoint.y)
            
            var bounds = CGRect.zero
            bounds.size = self.contained!.size
            
            let intersection = visible.intersection(bounds)
            
            // Sanity check on macOS. Exiting fullscreen gave invalid intersection
            if CGSize.zero.equalTo(intersection.size) {
                return
            }
            
            self.contained!.scrolledVisible(to: intersection)
        }
        
        let sequence = SKAction.sequence([moveAction, notifyAction])
        contained.run(sequence)
    }
    
    private func translatePointToContent(_ point: CGPoint) -> CGPoint {
        return contained!.convert(point, from: parent!)
    }
    
    public func contentSizeChanged() {
        var insets = contentInset
        let presentationInset = contained!.presentationInsets()
        
        insets.top += presentationInset.top
        insets.bottom += presentationInset.bottom
        insets.left += presentationInset.left
        insets.right += presentationInset.right
        
        self.presentationInset = insets
        
        positionPresentedNode()
    }
    
    public func setContentOffset(_ offset: CGPoint, animated: Bool) {
        let saneYOffset = max(offset.y, 0)
        scroll(to: CGPoint(x: offset.x, y: saneYOffset), animated: animated)
    }
}
