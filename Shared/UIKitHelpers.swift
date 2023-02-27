import UIKit
import SwiftUI

public extension UIView {
    /// Automatically find the closest parent view controller, if not provided and add the SwiftUI subview using `UIHostingController.
    /// If `frame` is set to nil the function returns `UIHostingController`'s `UIView` which can participate in Auto Layout.
    /// Otherwise,  the `frame` property is set on the UIView.
    func addSwiftUISubview<V: View>(
        _ view: V,
        frame: CGRect? = nil,
        parent: UIViewController? = nil
    ) -> UIView {
        let hostingController = UIHostingController(rootView: view)
        let uiView = hostingController.view!

        if let frame = frame {
            uiView.frame = frame
        } else {
            uiView.translatesAutoresizingMaskIntoConstraints = false
        }

        let parentViewController = parent ?? self.parentViewController!

        parentViewController.addChild(hostingController)
        addSubview(uiView)
        hostingController.didMove(toParent: parentViewController)

        return uiView
    }
}

extension UIResponder {
    /// Returns owning `UIViewController` of the `view`
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}

