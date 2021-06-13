import Foundation
import UIKit
import Kingfisher
import Photos

extension UIView {
    @objc class func fromNib(_ nibNameOrNil:String) ->  UIView {
        return  Bundle.main.loadNibNamed(nibNameOrNil, owner: self, options: nil)!.first as! UIView
    }
    
    func ClearColorShaddow(_ alpha:Float){
        
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowRadius = (self.frame.size.height)/2
        self.layer.shadowPath = CGPath(rect: CGRect(x: 0,y: 0, width: self.frame.width,height: self.frame.height), transform: nil)
        self.layer.shadowOpacity = alpha
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        
    }
    
    
    @IBInspectable var PPDashedBorder: UIColor {
        
        get{
            return self.PPBorderColor
        }
        set {
            let color = newValue.cgColor
            
            let shapeLayer:CAShapeLayer = CAShapeLayer()
            let frameSize = self.frame.size
            let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
            
            shapeLayer.bounds = shapeRect
            shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
            shapeLayer.fillColor = UIColor.clear.cgColor
            shapeLayer.strokeColor = color
            shapeLayer.lineWidth = 2
            shapeLayer.lineJoin = CAShapeLayerLineJoin.round
            shapeLayer.lineDashPattern = [6,3]
            shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 5).cgPath
            
            self.layer.addSublayer(shapeLayer)
        }
    }
    
    @IBInspectable var PPCorneredius:CGFloat{
        
        get{
            return layer.cornerRadius
        }
        set{
            self.layer.cornerRadius = newValue
            self.layer.masksToBounds = newValue > 0
        }
    }
    @IBInspectable var PPBorderWidth:CGFloat{
        
        get{
            return layer.borderWidth
        }
        set{
            self.layer.borderWidth = newValue
            self.layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var PPBorderColor:UIColor{
        
        get{
            return self.PPBorderColor
        }
        set{
            self.layer.borderColor = newValue.cgColor
            
        }
    }
    @IBInspectable var PPRoundDynamic:Bool{
        
        get{
            return false
        }
        set{
            if newValue == true {
                
                self.perform(#selector(UIView.AfterDelay), with: nil, afterDelay: 0.0)
            }
            
        }
        
    }
    @objc func AfterDelay(){
        
        let  Height =  self.frame.size.height
        self.layer.cornerRadius = Height/2;
        self.layer.masksToBounds = true;
        
        
    }
    @IBInspectable var PPRound:Bool{
        get{
            return false
        }
        set{
            if newValue == true {
                self.layer.cornerRadius = self.frame.size.height/2;
                self.layer.masksToBounds = true;
            }
            
        }
    }
    @IBInspectable var PPShadow:Bool{
        get{
            return false
        }
        set{
            if newValue == true {
                self.layer.masksToBounds = false
                self.layer.shadowColor = UIColor.gray.cgColor
                self.layer.shadowOffset = CGSize(width: 1.0, height: 0.0)
                self.layer.shadowOpacity = 0.5;
                
            }
            
        }
        
    }
    
    
    
    func roundMake() {
        self.layer.cornerRadius = self.frame.size.height/2;
        self.layer.masksToBounds = true;
    }
    
}

extension UILabel {
    
    @IBInspectable var FontAutomatic:Bool {
        get{
            return true
        }
        set{
            
            if newValue == true {
                
                let  height = (self.frame.size.height*SCREEN_HEIGHT)/568;
                self.font = UIFont(name:self.font.fontName, size:(height*self.font.pointSize)/self.frame.size.height )
            }
            
        }
        
    }
    
}
extension UITextView {
    
    @IBInspectable var FontAutomatic:Bool{
        get{
            return true
        }
        set{
            
            if newValue == true {
                
                let  height = (self.frame.size.height*SCREEN_HEIGHT)/568;
                self.font = UIFont(name:self.font!.fontName, size:(height*self.font!.pointSize)/self.frame.size.height )
            }
            
        }
        
    }
    
    @IBInspectable var Pedding:Bool{
        get{
            return true
        }
        set{
            
            if newValue == true {
                
                let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: self.frame.height))
                self.addSubview(paddingView)
            }
            
        }
        
    }
    
}
extension UITextField {
    
    @IBInspectable var FontAutomatic:Bool{
        get{
            return true
        }
        set{
            
            if newValue == true {
                
                let  height = (self.frame.size.height*SCREEN_HEIGHT)/568;
                self.font = UIFont(name:self.font!.fontName, size:(height*self.font!.pointSize)/self.frame.size.height )
            }
            
        }
        
    }
    
    func setBottomBorder(_ color:UIColor, height: CGFloat, paddingXAxis: CGFloat) {
        var view = self.viewWithTag(2525)
        if view == nil {
            DispatchQueue.main.async {
                view = UIView(frame:CGRect(x: paddingXAxis, y: self.frame.size.height - height, width:  self.frame.size.width - paddingXAxis, height: height))
                view?.backgroundColor = color
                view?.tag = 2525
                self .addSubview(view!)
            }
        }
    }
    func removeAddBottomBorder(_ color:UIColor, height: CGFloat, paddingXAxis: CGFloat) {
        var view = self.viewWithTag(2525)
        if view?.tag == 2525 {
            view?.removeFromSuperview()
        }
        DispatchQueue.main.async {
            view = UIView(frame:CGRect(x: paddingXAxis, y: self.frame.size.height - height, width:  self.frame.size.width - paddingXAxis, height: height))
            view?.backgroundColor = color
            view?.tag = 2525
            self .addSubview(view!)
        }
    }
    
    @IBInspectable var Pedding:Bool{
        get{
            return true
        }
        set{
            
            if newValue == true {
                
                let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: self.frame.height))
                self.leftView = paddingView
                self.leftViewMode = UITextField.ViewMode.always
                
            }
            
        }
        
    }
    
    @discardableResult
    func leftButton(image: UIImage?, width: CGFloat = 0, height: CGFloat = 0) -> UIButton {
        
        let btn = UIButton.init(type: .custom)
        btn.setImage(image, for: .normal)
        btn.frame = CGRect.init(x: 0, y: 0, width: width, height:  height)
        self.leftView = btn;
        self.leftViewMode = .always
        return btn
        
    }
    @discardableResult
    func rightButton(image: UIImage?, width: CGFloat = 0, height: CGFloat = 0) -> UIButton {
        
        let widthNew = (width == 0) ? self.frame.size.width : width
        let heightNew = (height == 0) ? self.frame.size.height : height
        
        let btn = UIButton.init(type: .custom)
        btn.setImage(image, for: .normal)
        btn.isUserInteractionEnabled = true
        btn.frame = CGRect.init(x:  (self.frame.size.width - self.frame.size.height), y: 0, width:widthNew, height:  heightNew)
        self.rightView = btn;
        self.rightViewMode = .always
        return btn
    }
    func removeRightViewImage(){
        self.rightView = nil;
        self.rightViewMode = .always
        
    }
    func leftpedding(){
        
        let btn = UIButton.init(type: .custom)
        btn.setImage(nil, for: .normal)
        btn.frame = CGRect.init(x: 0, y: 0, width:10, height:  self.frame.size.height)
        self.leftView = btn;
        self.leftViewMode = .always
        
        
    }
    
    
    
}
extension UIButton{
    
    @IBInspectable var FontAutomatic:Bool{
        get{
            return true
        }
        set{
            
            if newValue == true {
                
                let  height = (self.frame.size.height*SCREEN_HEIGHT)/568;
                self.titleLabel!.font = UIFont(name:self.titleLabel!.font!.fontName, size:(height*self.titleLabel!.font!.pointSize)/self.frame.size.height )!
            }
            
        }
        
    }
}



extension String{
    
    func encodeUrl() -> String{
        return self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
    }
    
    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }

    func heightOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.height
    }
    
    func isValidEmail() -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    func trim() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    func isValidName() -> Bool {
        
        if self.count > 0 {
            return true
        }
        return false
        
        
    }
    func isValidPassWord() -> Bool {
        
        if self.count > 1 {
            return true
        }
        return false
        
    }
    func isValidFullname() -> Bool {
        
        let emailRegEx = "^[A-Za-z]+(?:\\s[A-Za-z]+)"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
        
    }
    func isValidZipcode() -> Bool {
        
        if self.count == 5 || self.count == 6 {
            return true
        }
        return false
        
    }
    
    func isValidMobile() -> Bool {
        
        
        if self.count == 10 {
            return true
        }
        return false
        
    }
    
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [kCTFontAttributeName as NSAttributedString.Key: font], context: nil)
        return boundingBox.height
    }
    
    var length: Int {
        return count
    }
    
    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }
    
    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, length) ..< length]
    }
    
    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }
    
    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
    
    public func convertDateFormater(fromDateFormat: String, toDateFormat: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = fromDateFormat
        let date = dateFormatter.date(from: self)
        dateFormatter.dateFormat = toDateFormat
        return  dateFormatter.string(from: date ?? Date())
    }
    
    
    
}
extension UIScrollView{
    
    func AumaticScroller() {
        
        var contentRect = CGRect.zero
        for view in self.subviews{
            contentRect = contentRect.union(view.frame);
        }
        
        self.contentSize = contentRect.size;
    }
}

extension UIImage {
    
    func PPresizeImage(_ newWidth: CGFloat) -> UIImage {
        
        let scale = newWidth / self.size.width
        let newHeight = self.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        self.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    class func circleImage(diameter: CGFloat, color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: diameter, height: diameter), false, 0)
        let ctx = UIGraphicsGetCurrentContext()!
        ctx.saveGState()
        
        let rect = CGRect(x: 0, y: 0, width: diameter, height: diameter)
        ctx.setFillColor(color.cgColor)
        ctx.fillEllipse(in: rect)
        
        ctx.restoreGState()
        let img = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return img
    }
    
    class func textOnImage(text: String, textHeight: CGFloat, image: UIImage, imageViewWidth: CGFloat, imageViewHeight: CGFloat, font: UIFont, textColor: UIColor) -> UIImage {

        let scale = UIScreen.main.scale
        let size = CGSize(width: imageViewWidth, height: imageViewHeight)
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        
        let widthOfString = text.widthOfString(usingFont: font)
        
        let textFontAttributes = [
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.foregroundColor: textColor,
            ] as [NSAttributedString.Key : Any]
        image.draw(in: CGRect(x: 0, y: 0, width: imageViewWidth, height: imageViewHeight))
        
        let rect = CGRect(x: (imageViewWidth - widthOfString) / 2, y: (imageViewHeight - textHeight) / 2, width: widthOfString, height: textHeight)
        text.draw(in: rect, withAttributes: textFontAttributes)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}


extension UIImageView {
    
    public func setImageWithStatus(_ url:String?, _ placeholderImage:UIImage = UIImage.init(named: "bg")!, complition:@escaping (Bool, UIImage) -> Void) {
        
        self.kf.setImage(with: URL.init(string: url ?? ""), placeholder: placeholderImage, options: [.transition(.fade(1))], progressBlock: { (completed, total) in
            
        }) { (result: Result<RetrieveImageResult, KingfisherError>) in
            guard let source = try? result.get() else {
                complition(false,placeholderImage)
                return
            }
            complition(true,source.image)
        }
    }
    
    public func setImage(_ url:String?, _ placeholderImage:UIImage = UIImage.init(named: "petopia_trans_placeholder_icon")!) {
        self.kf.setImage(with: URL.init(string: url ?? ""), placeholder: placeholderImage)
    }
    
    public func setAlpha (_ alpha: CGFloat) {
        UIView.animate(withDuration: 0.5) {
            self.alpha = alpha
        }
    }
}

extension UIViewController {
    
    @IBAction func backPress(_ sender:UIButton?) {
        self.navigationController?.popViewController(animated: true)
    }

    open override func awakeFromNib() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    func setLeftAlignedTitle(title: String) {
        let container = UIView(frame: CGRect(x: 0, y: 0, width: 1000, height: 22))

        let label = UILabel()
        label.text = title
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(label)

        let leftButtonWidth: CGFloat = 55
        let rightButtonWidth: CGFloat = 75
        let width = view.frame.width - leftButtonWidth - rightButtonWidth
        let offset = (rightButtonWidth - leftButtonWidth) / 2

        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: container.topAnchor),
            label.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            label.centerXAnchor.constraint(equalTo: container.centerXAnchor, constant: -offset),
            label.widthAnchor.constraint(equalToConstant: width)
        ])


        self.navigationItem.titleView = container
    }

}
extension UIFont{
   
    static public func regularFont(_ size:CGFloat = 16) -> UIFont {
        return UIFont.init(name: "Nunito-Regular", size: size)!
    }
    static public func boldFont(_ size:CGFloat = 16) -> UIFont {
        return UIFont.init(name: "Nunito-Bold", size: size)!
    }
    static public func semiBoldFont(_ size:CGFloat = 16) -> UIFont {
        return UIFont.init(name: "Nunito-SemiBold", size: size)!
    }
}

extension UIColor {
    
    public class var headerViewBackgroundColor: UIColor
    {
        return UIColor(red: 255/255, green: 128/255, blue: 92/255, alpha: 1.0)
    }
    public class var mainViewBackgroundColor: UIColor
    {
        return UIColor(red: 242/255, green: 243/255, blue: 245/255, alpha: 1.0)
    }
    public class var borderColor: UIColor
    {
        return UIColor(red: 223/255, green: 232/255, blue: 243/255, alpha: 1.0)
    }
    public class var buttonBackgroundColor: UIColor
    {
        return UIColor(red: 252/255, green: 176/255, blue: 21/255, alpha: 1.0)
    }
    public class var blueColor: UIColor
    {
        return UIColor(red: 6/255, green: 60/255, blue: 228/255, alpha: 1.0)
    }
    public class var lightGreyColor: UIColor
    {
        return UIColor(red: 145/255, green: 155/255, blue: 165/255, alpha: 1.0)
    }
    public class var lightBlackColor: UIColor
    {
        return UIColor(red: 34/255, green: 50/255, blue: 58/255, alpha: 1.0)
    }
    public class var dividerLineColor: UIColor
    {
        return UIColor(red: 205/255, green: 219/255, blue: 235/255, alpha: 1.0)
    }
    public class var checkInColor: UIColor
    {
        return UIColor(named: "checkInColor")!
    }
    public class var checkOutColor: UIColor
    {
        return UIColor(named: "checkOutColor")!
    }
    
}

// An attributed string extension to achieve colors on text.
extension NSMutableAttributedString {
    
    func setColor(color: UIColor, forText stringValue: String, font: UIFont) {
        let range: NSRange = self.mutableString.range(of: stringValue, options: .caseInsensitive)
        self.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
        self.addAttribute(NSAttributedString.Key.font, value: font, range: range)
    }
}

public extension UIDevice {
    
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
        case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
        case "iPhone8,4":                               return "iPhone SE"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "iPad6,3", "iPad6,4", "iPad6,7", "iPad6,8":return "iPad Pro"
        case "AppleTV5,3":                              return "Apple TV"
        case "i386", "x86_64":                          return "Simulator"
        default:                                        return identifier
        }
    }
}

extension Array {
    func unique<T:Hashable>(by: ((Element) -> (T)))  -> [Element] {
        var set = Set<T>() //the unique list kept in a Set for fast retrieval
        var arrayOrdered = [Element]() //keeping the unique list of elements but ordered
        for value in self {
            if !set.contains(by(value)) {
                set.insert(by(value))
                arrayOrdered.append(value)
            }
        }
        return arrayOrdered
    }
}

@objc extension UIAlertController {
    
    @objc class func showAlertError(message:String){
        
        let alertController = UIAlertController(title: message, message:nil , preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        appDelegate.window?.rootViewController?.present(alertController, animated: true, completion: nil)
        
    }
    
    
    class func showAlert(message:String,complition:@escaping ()-> Void){
        
        let alertController = UIAlertController(title: message, message:nil , preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            complition()
        })
        alertController.addAction(defaultAction)
        appDelegate.window?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    @objc class func showAlert(title:String , message:String,complition:@escaping ()-> Void){
        
        let alertController = UIAlertController(title: title, message:message , preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            complition()
        })
        alertController.addAction(defaultAction)
        appDelegate.window?.rootViewController?.present(alertController, animated: true, completion: nil)
        
    }
    class func showAlert(message:String = "No",destructiveTitle:String,complition:@escaping ()-> Void){
        
        let alertController = UIAlertController(title: message, message:nil , preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "No", style: .default, handler: nil)
        let destructive = UIAlertAction(title: destructiveTitle, style: .destructive, handler: { (action) in
            complition()
        })
        alertController.addAction(defaultAction)
        alertController.addAction(destructive)
        appDelegate.window?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
    class func showAlert(message: String, firstTitle: String, secondTitle: String, firstTitleComplition:@escaping ()-> Void, secondTitleComplition:@escaping ()-> Void) {
        
        let alertController = UIAlertController(title: message, message:nil , preferredStyle: .alert)
        let cancelAction   = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let firstAction   = UIAlertAction(title: firstTitle, style: .default, handler: { (action) in
            firstTitleComplition()
        })
        let secondAction     = UIAlertAction(title: secondTitle, style: .default, handler: { (action) in
            secondTitleComplition()
        })
        alertController.addAction(firstAction)
        alertController.addAction(secondAction)
//        alertController.addAction(cancelAction)
        
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            alertController.popoverPresentationController?.sourceView = appDelegate.window
            alertController.popoverPresentationController?.sourceRect = (appDelegate.window?.rootViewController?.view.bounds)!
            alertController.popoverPresentationController?.permittedArrowDirections = .up
        default:
            break
        }
        appDelegate.window?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    class func showAlertWithCancel(message: String, firstTitle: String, secondTitle: String, firstTitleComplition:@escaping ()-> Void, secondTitleComplition:@escaping ()-> Void) {
        
        let alertController = UIAlertController(title: message, message:nil , preferredStyle: .alert)
        let cancelAction   = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let firstAction   = UIAlertAction(title: firstTitle, style: .default, handler: { (action) in
            firstTitleComplition()
        })
        let secondAction     = UIAlertAction(title: secondTitle, style: .default, handler: { (action) in
            secondTitleComplition()
        })
        alertController.addAction(firstAction)
        alertController.addAction(secondAction)
        alertController.addAction(cancelAction)
        
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            alertController.popoverPresentationController?.sourceView = appDelegate.window
            alertController.popoverPresentationController?.sourceRect = (appDelegate.window?.rootViewController?.view.bounds)!
            alertController.popoverPresentationController?.permittedArrowDirections = .up
        default:
            break
        }
        appDelegate.window?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
    class func showAlert(message: String, cameraTitle: String, galleryTitle: String, button :UIButton,cameraComplition:@escaping ()-> Void, galleryComplition:@escaping ()-> Void) {
        
        let alertController = UIAlertController(title: message, message:nil , preferredStyle: .actionSheet)
        let cancelAction   = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let cameraAction   = UIAlertAction(title: cameraTitle, style: .default, handler: { (action) in
            cameraComplition()
        })
        let galleryAction     = UIAlertAction(title: galleryTitle, style: .default, handler: { (action) in
            galleryComplition()
        })
        alertController.addAction(cameraAction)
        alertController.addAction(galleryAction)
        alertController.addAction(cancelAction)
        
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            alertController.popoverPresentationController?.sourceView = button
            alertController.popoverPresentationController?.sourceRect = (button.bounds)
            alertController.popoverPresentationController?.permittedArrowDirections = .up
        default:
            break
        }
        appDelegate.window?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
}

extension UIActivityIndicatorView {
    func makeLargeGray() {
        style = .whiteLarge
        color = .gray
    }
}

extension UISearchBar {
    
    var textField: UITextField {
        return self.value(forKey: "_searchField") as! UITextField
    }
    var cancelButton: UIButton {
        return self.value(forKey: "cancelButton") as! UIButton
    }
    
    func setCancelButton(font: UIFont = UIFont.boldFont(16), textColor: UIColor = .white) {
        self.cancelButton.titleLabel?.font = font
        self.cancelButton.setTitleColor(textColor, for: .normal)
    }
    
    func setTextField(placeHolderColor:UIColor = .gray,placeHolder:String = "Search",textColor:UIColor = .white,backgroundColor:UIColor = .black,
                      placeHolderFont:UIFont = UIFont.systemFont(ofSize: 12.0),
                      textFont:UIFont =  UIFont.systemFont(ofSize: 12.0) ){
        for item in self.subviews{
            for mainView in (item as UIView).subviews{
                mainView.backgroundColor = backgroundColor
                if mainView is UITextField{
                    let textField = mainView as? UITextField
                    if let _textF = textField{
                        _textF.text = ""
                        _textF.textColor = textColor
                        _textF.font      = textFont
                        _textF.attributedPlaceholder = NSMutableAttributedString.init(string: placeHolder, attributes: [NSAttributedString.Key.foregroundColor : placeHolderColor,
                                                                                                                        NSAttributedString.Key.font : placeHolderFont])
                    }
                }
            }
        }
    }
}

extension PHAsset {
    
    var image : UIImage {
        var thumbnail = UIImage()
        let imageManager = PHCachingImageManager()
        imageManager.requestImage(for: self, targetSize: CGSize(width: 750, height: 750), contentMode: .aspectFit, options: nil, resultHandler: { image, _ in
            thumbnail = image ?? UIImage()
        })
        return thumbnail
    }
}

extension Sequence {
    func group<U: Hashable>(by key: (Iterator.Element) -> U) -> [U:[Iterator.Element]] {
        return Dictionary.init(grouping: self, by: key)
    }
}

extension UICollectionView {
    func addShadowRadius() {
        self.contentInset = UIEdgeInsets.init(top: 0, left: 50, bottom: 0, right: 50)
        self.decelerationRate    = UIScrollView.DecelerationRate.fast
        self.layer.shadowColor   = UIColor.lightGray.cgColor
        self.layer.shadowOffset  = CGSize(width: 0, height: 1.0)
        self.layer.shadowRadius  = 1.0
        self.layer.shadowOpacity = 1.0
        self.layer.masksToBounds = false
    }
}

extension URL {
    func generateThumbnail() -> UIImage {
        let asset = AVAsset(url: self)
        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true
        var time = asset.duration
        time.value = 0
        let imageRef = try? generator.copyCGImage(at: time, actualTime: nil)
        let thumbnail = UIImage(cgImage: imageRef!)
        return thumbnail
    }
}

extension UITableView {
    public func scrollToBottom(animated: Bool = true) {
        guard let dataSource = dataSource else {
            return
        }
        
        let sections = dataSource.numberOfSections?(in: self) ?? 1
        let rows = dataSource.tableView(self, numberOfRowsInSection: sections-1)
        let bottomIndex = IndexPath(item: rows - 1, section: sections - 1)
        if bottomIndex.section < 0 {
            return
        }
        scrollToRow(at: bottomIndex,
                    at: .bottom,
                    animated: animated)
    }
}



extension URLRequest {
    
    /**
     Returns a cURL command representation of this URL request.
     */
    public var curlString: String {
        guard let url = url else { return "" }
        var baseCommand = "curl \(url.absoluteString)"
        
        if httpMethod == "HEAD" {
            baseCommand += " --head"
        }
        
        var command = [baseCommand]
        
        if let method = httpMethod, method != "GET" && method != "HEAD" {
            command.append("-X \(method)")
        }
        
        if let headers = allHTTPHeaderFields {
            for (key, value) in headers where key != "Cookie" {
                command.append("-H '\(key): \(value)'")
            }
        }
        
        if let data = httpBody, let body = String(data: data, encoding: .utf8) {
            command.append("-d '\(body)'")
        }
        
        return command.joined(separator: " \\\n\t")
    }
    
    init?(curlString: String) {
        return nil
    }
    
}
