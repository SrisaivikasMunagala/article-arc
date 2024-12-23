import UIKit
import Social

class ShareViewController: SLComposeServiceViewController {
    override func isContentValid() -> Bool {
        return true
    }

    override func didSelectPost() {
        guard let content = extensionContext?.inputItems.first as? NSExtensionItem,
              let attachments = content.attachments else {
            self.extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
            return
        }
        
        for attachment in attachments {
            if attachment.hasItemConformingToTypeIdentifier("public.url") {
                attachment.loadItem(forTypeIdentifier: "public.url", options: nil) { (item, error) in
                    guard let sharedURL = item as? URL else {
                        self.extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
                        return
                    }
                    
                    // Save the shared URL in UserDefaults
                    if let sharedDefaults = UserDefaults(suiteName: "group.articlearc.share") {
                        sharedDefaults.set(sharedURL.absoluteString, forKey: "sharedLink")
                        sharedDefaults.synchronize()
                    }
                    
                    // Open the main app
                    if let appURL = URL(string: "articlearc://") {
                        self.extensionContext?.open(appURL, completionHandler: nil)
                    }
                }
            }
        }
        
        self.extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
    }
}
