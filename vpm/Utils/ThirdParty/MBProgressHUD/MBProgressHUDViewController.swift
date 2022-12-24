//
//  ViewController.swift
//  MBProgressHUDForSwift
//

import UIKit
//import SwiftyGif

class MBProgressHUDViewController: UIViewController, MBProgressHUDDelegate {
    
    var HUD: MBProgressHUD?
    var expectedLength: Int64 = 0
    var currentLength: Int64 = 0
    
    @IBOutlet var buttons: [UIButton]!

    // MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        let content: UIView = self.view.subviews.first as! UIView
//        (buttons as NSArray).setValue(10.0, forKeyPath: "layer.cornerRadius")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func showSimple(_ ToView: UIWindow) {
        // The hud will dispable all input on the view (use the higest view possible in the view hierarchy)
        HUD = MBProgressHUD(view: ToView)
        ToView.addSubview(HUD!)
        
        // Constants.WebServices.REGISTER for HUD callbacks so we can remove it from the window at the right time
        HUD!.delegate = self
        
        // Show the HUD while the provide method  executes in a new thread
//        HUD!.showWhileExecuting({ [unowned self] () -> Void in
//            self.myTask()
//            }, animated: true)
    }

    
//    func removeHUD()
//    {
//    HUD?.removeFromSuperview()
//    }
    
    @IBAction func showWithLabel(_ sender: UIButton) {
        HUD = MBProgressHUD(view: self.navigationController!.view)
        self.navigationController!.view.addSubview(HUD!)
        
        HUD!.delegate = self
        HUD!.labelText = "Loading"
        
//        HUD!.showWhileExecuting({ [unowned self] () -> Void in
//            self.myTask()
//            }, animated: true)
    }
    
    @IBAction func showWithDetailsLabel(_ sender: UIButton) {
        HUD = MBProgressHUD(view: self.navigationController!.view)
        self.navigationController!.view.addSubview(HUD!)
        
        HUD!.delegate = self
        HUD!.labelText = "Loading"
        HUD!.detailsLabelText = "updating data"
        HUD!.square = true
        
        HUD!.showWhileExecuting({ [unowned self] () -> Void in
            self.myTask()
            }, animated: true)
    }
    
    @IBAction func showWithLabelDeterminate(_ sender: UIButton) {
        HUD = MBProgressHUD(view: self.navigationController!.view)
        self.navigationController!.view.addSubview(HUD!)
        
        // Set determinate mode
        HUD!.mode = MBProgressHUDMode.determinate
        
        HUD!.delegate = self
        HUD!.labelText = "Loading"
        
        // myProgressTask uses the HUD instance to update progress
        HUD!.showWhileExecuting({ [unowned self] () -> Void in
            self.myProgressTask()
            }, animated: true)
    }
    
//    @IBAction func showWithLabelAnnularDeterminate(sender: UIButton) {
//        HUD = MBProgressHUD(view: self.navigationController!.view)
//        self.navigationController!.view.addSubview(HUD!)
//
//        HUD!.mode = MBProgressHUDMode.AnnularDeterminate
//
//        HUD!.delegate = self
//        HUD!.labelText = "Loading"
//
//        // myProgressTask uses the HUD instance to update progress
//        HUD!.showWhileExecuting({ [unowned self] () -> Void in
//            self.myProgressTask()
//            }, animated: true)
//    }
    
//
    func showWithLabelAnnularDeterminate(_ imgvw : UIImageView)
    {
        HUD = MBProgressHUD(view: imgvw)
        imgvw.addSubview(HUD!)
        
        HUD!.mode = MBProgressHUDMode.annularDeterminate
        
        HUD!.delegate = self
        HUD!.labelText = "Loading"
        
//         myProgressTask uses the HUD instance to update progress
        HUD!.showWhileExecuting({ [unowned self] () -> Void in
            self.myProgressTask()
            }, animated: true)

    }

    
    
    @IBAction func showWithLabelDeterminateHorizontalBar(_ sender: UIButton) {
        HUD = MBProgressHUD(view: self.navigationController!.view)
        self.navigationController!.view.addSubview(HUD!)
        
        // Set determinate bar mode
        HUD!.mode = .determinateHorizontalBar;
        
        HUD!.delegate = self;
        
        // myProgressTask uses the HUD instance to update progress
        HUD!.showWhileExecuting({ [unowned self] () -> Void in
            self.myProgressTask()
            }, animated: true)
    }
    
    @IBAction func showWithCustomView(_ sender: UIButton) {
        HUD = MBProgressHUD(view: self.navigationController!.view)
        self.navigationController!.view.addSubview(HUD!)
        
        // The sample image is based on the work by http://www.pixelpressicons.com, http://creativecommons.org/licenses/by/2.5/ca/
        // Make the customViews 37 by 37 pixels for best results (those are the bounds of the build-in progress indicators)
        HUD!.customView = UIImageView(image: UIImage(named: "37x-Checkmark.png"))
        
        // Set custom view mode
        HUD!.mode = .customView;
        
        HUD!.delegate = self;
        HUD!.labelText = "Completed";
        
        HUD!.show(true)
        HUD!.hide(true, afterDelay:3)
    }
    
    @IBAction func showWithLabelMixed(_ sender: UIButton) {
        HUD = MBProgressHUD(view: self.navigationController!.view)
        self.navigationController!.view.addSubview(HUD!)
        
        HUD!.delegate = self
        HUD!.labelText = "Connecting"
        HUD!.minSize = CGSize(width: 135.0, height: 135.0)
        HUD!.showWhileExecuting({ [unowned self] () -> Void in
            self.myMixedTask()
            }, animated: true)
    }
    
    @IBAction func showUsingBlocks(_ sender: UIButton) {
        let hud: MBProgressHUD = MBProgressHUD(view: self.navigationController!.view)
        self.navigationController!.view.addSubview(hud)
        
        hud.labelText = "With a block";
        
        hud.showAnimated(true, whileExecutingBlock: { () -> Void in
            self.myTask()
        }) { () -> Void in
            hud.removeFromSuperview()
        }
    }
    
    @IBAction func showOnWindow(_ sender: UIButton) {
        HUD = MBProgressHUD(view: self.view.window!)
        self.view.window!.addSubview(HUD!)
        
        HUD!.delegate = self
        HUD!.labelText = "Loading"
        
        HUD!.showWhileExecuting({ [unowned self] () -> Void in
            self.myTask()
            }, animated: true)
    }
    
    @IBAction func showWithGradient(_ sender: UIButton) {
        HUD = MBProgressHUD(view: self.navigationController!.view)
        self.navigationController!.view.addSubview(HUD!)
        
        HUD!.dimBackground = true
        
        // Regiser for HUD callbacks so we can remove it from the window at the right time
        HUD!.delegate = self;
        HUD!.showWhileExecuting({ [unowned self] () -> Void in
            self.myTask()
            }, animated: true)
    }
    
    func showTextOnly(ToView: UIWindow, Message: String) {
        let hud: MBProgressHUD = MBProgressHUD.showHUDAddedTo(view: ToView, animated: true)
        
        // Configure for text only and offset down
        hud.mode = .text
        hud.detailsLabelText = Message
        hud.margin = 10.0
        hud.removeFromSuperViewOnHide = true
        
        hud.hide(true, afterDelay: 2)
    }
    
    @IBAction func showWithColor(_ sender: UIButton) {
        HUD = MBProgressHUD(view: self.navigationController!.view)
        self.navigationController!.view.addSubview(HUD!)
        
        // Set the hud to display with a color
        HUD!.color = UIColor(red: 0.23, green: 0.50, blue: 0.82, alpha: 0.90)
        HUD!.delegate = self;
        
        HUD!.showWhileExecuting({ [unowned self] () -> Void in
            self.myTask()
            }, animated: true)
    }
    
    @IBAction func showSimpleWithIndeterminatedRound(_ sender: UIButton) {
        // The hud will dispable all input on the view (use the higest view possible in the view hierarchy)
        HUD = MBProgressHUD(view: self.navigationController!.view)
        self.navigationController!.view.addSubview(HUD!)
        
        // Constants.WebServices.REGISTER for HUD callbacks so we can remove it from the window at the right time
        HUD!.delegate = self
        
        HUD!.mode = .annularIndeterminate
        
        // Show the HUD while the provide method  executes in a new thread
        HUD!.showWhileExecuting({ [unowned self] () -> Void in
            self.myTask()
            }, animated: true)
    }
    
    // MARK: - Execution code
    func myTask() {
        // Do something useful in here instead of sleeping...
        sleep(3)
    }
    
    func myProgressTask() {
        // This just incresses the progress indicator in a loop
        var progress: Float = 0.0
        while progress < 1.0 {
            progress += 0.01
            HUD!.progress = progress
            usleep(50000)
        }
    }
    
    func myMixedTask() {
        // Indeterminate mode
        sleep(2)
        // Switch to determinate mode
        HUD!.mode = .determinate
        HUD!.labelText = "Progress"
        var progress: Float = 0.0
        while progress < 1.0 {
            progress += 0.01
            HUD!.progress = progress
            usleep(50000)
        }
        // Back to indeterminate mode
        HUD!.mode = .indeterminate
        HUD!.labelText = "Cleaning up"
        sleep(2)
        // UIImageView is a UIKit class, we have to initialize it on the main thread
        var imageView: UIImageView?;
        DispatchQueue.main.sync {
            let image: UIImage? = UIImage(named: "37x-Checkmark.png")
            imageView = UIImageView(image: image)
        }
        HUD!.customView = imageView
        HUD!.mode = .customView
        HUD!.labelText = "Completed"
        sleep(2)
    }
    
    // MARK: - NSURLConnectionDelegate
    func connection(_ connection: NSURLConnection, didReceiveResponse response: URLResponse) {
        expectedLength = max(response.expectedContentLength, 1)
        currentLength = 0
        HUD!.mode = MBProgressHUDMode.determinate
    }
    
    func connection(_ connection: NSURLConnection, didReceiveData data: Data) {
        
        //currentLength += data.count
        currentLength = currentLength.advanced(by: data.count) // Swift 4
        
        HUD!.progress = Float(currentLength) / Float(expectedLength)
    }
    
    func connectionDidFinishLoading(_ connection: NSURLConnection) {
        HUD!.customView = UIImageView(image: UIImage(named: "37x-Checkmark.png"))
        HUD!.mode = .customView
        HUD!.hide(true, afterDelay: 2)
    }
    
    func connection(_ connection: NSURLConnection, didFailWithError error: NSError) {
        HUD!.hide(true)
    }
    
    // MARK: - MBProgressHUDDelegate
    func hudWasHidden(_ hud: MBProgressHUD) {
        HUD!.removeFromSuperview()
        HUD = nil
    }
    
    func HudWithLabel(_ view: UIView, displayString:String) -> MBProgressHUD {
        
        let hud: MBProgressHUD = MBProgressHUD(view: view)
        hud.removeFromSuperViewOnHide = true
        hud.labelText = displayString
        
        view.addSubview(hud)
        hud.show(true)
        
        return hud
    }

//    func GifLoader(view: UIView){
//        HUD = MBProgressHUD(view: view)
//        HUD?.color = UIColor.white.withAlphaComponent(0.5)
//        HUD?.backgroundColor = UIColor.black.withAlphaComponent(0.5)
//        view.addSubview(HUD!)
//
//        // Set an image view with a checkmark.
//        let gifmanager = SwiftyGifManager(memoryLimit:20)
//        guard let gif = try? UIImage(gifName: "loading_gif_logo.gif") else { return }
//        let imageview = UIImageView(gifImage: gif, manager: gifmanager)
////        imageview.contentMode = .scaleAspectFill
////        HUD!.labelText = NSLocalizedString(string, comment: "")
//        HUD!.labelColor = UIColor.red
//
//        imageview.frame = CGRect(x: 0 , y: 0, width: 90 , height: 90)
//
//        let views = UIView.init(frame: CGRect(x: 0 , y: 0, width: 89 , height: 90))
//        views.backgroundColor = UIColor.clear
//        views.addSubview(imageview)
//
//        HUD!.customView = views
//
//        // The sample image is based on the work by http://www.pixelpressicons.com, http://creativecommons.org/licenses/by/2.5/ca/
//        // Make the customViews 37 by 37 pixels for best results (those are the bounds of the build-in progress indicators)
////        HUD!.customView = UIImageView(image: UIImage(named: "37x-Checkmark.png"))
//
//        // Set custom view mode
//        HUD!.mode = .customView;
//
//        HUD!.delegate = self;
////        HUD!.labelText = "Completed";
//
//        HUD!.show(true)
//        HUD!.hide(true, afterDelay:3)
//    }
    
    // Increment currentLength in swift 4
    func increment<T: Strideable>(number: T) -> T {
        return number.advanced(by: 1)
    }
}

