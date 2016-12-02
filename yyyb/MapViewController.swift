//
//  MapViewController.swift
//  yyyb
//
//  Created by admin on 2016/11/21.
//  Copyright © 2016年 norwaya. All rights reserved.
//

import UIKit

class MapViewController: UIViewController,MAMapViewDelegate, AMapLocationManagerDelegate {

    //MARK: - Properties
    
//    let showSegment = UISegmentedControl(items: ["Start", "Stop"])
   
    
    
//    let pointAnnotation = MAPointAnnotation()
    
    var mapView: MAMapView!
    lazy var locationManager = AMapLocationManager()
    
    //MARK: - Action Handle
    
    func configLocationManager() {
        locationManager.delegate = self
        
        locationManager.pausesLocationUpdatesAutomatically = false
        
        locationManager.allowsBackgroundLocationUpdates = true
    }
    
//    func showSegmentAction(sender: UISegmentedControl) {
//        if sender.selectedSegmentIndex == 1 {
//            
//            locationManager.stopUpdatingLocation()
//            
//            mapView.removeAnnotation(pointAnnotation)
//        }
//        else {
//            mapView.addAnnotation(pointAnnotation)
//            
//            locationManager.startUpdatingLocation()
//        }
//    }
    func addRecord(sender: UIButton){
        let vcInstance = self.storyboard?.instantiateViewController(withIdentifier: "add01")
        self.navigationController?.pushViewController(vcInstance!, animated: true)
    }
    func takePhoto(sender: UIButton){
        takePhotos()
    
    }
    //MARK: - AMapLocationManagerDelegate
    
    func amapLocationManager(_ manager: AMapLocationManager!, didFailWithError error: Error!) {
        let error = error as NSError
        NSLog("didFailWithError:{\(error.code) - \(error.localizedDescription)};")
    }
    
    var lockCenter = true
    func mapView(_ mapView: MAMapView!, mapDidMoveByUser wasUserAction: Bool) {
        lockCenter = false
//        self.gpsButton.isSelected = false
    }
    func amapLocationManager(_ manager: AMapLocationManager!, didUpdate location: CLLocation!, reGeocode: AMapLocationReGeocode?) {
        point.latitude = location.coordinate.latitude
        point.longitude = location.coordinate.longitude
        let address = reGeocode?.formattedAddress
        point.detailAddress = (address == nil ? "":address!)
//        NSLog("location:{lat:\(location.coordinate.latitude); lon:\(location.coordinate.longitude); accuracy:\(location.horizontalAccuracy); reGeocode:\(reGeocode?.formattedAddress)};");
        
//        pointAnnotation.coordinate = location.coordinate
//        mapView.centerCoordinate = location.coordinate
//        mapView.setZoomLevel(15.1, animated: true)
        
    }
    
    //MARK: - Life Cycle

    override func viewDidLoad() {
        print("view did load ")
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        self.title = "巡查定位"
        initToolBar()
        
        initMapView()
        initOtherView()
        configLocationManager()
        backAction()
//        mapView.addAnnotation(pointAnnotation)
        locationManager.startUpdatingLocation()
    }
    func backAction(){
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "返回", style: UIBarButtonItemStyle.done, target: self, action: #selector(test(sender:)))
    }
    func test(sender: UIBarButtonItem){
        //处理 未上传的 报告
        print("deal daily and express")
        self.navigationController?.popToRootViewController(animated: true)

    }
    var toolbar: UIToolbar!
    override func viewWillAppear(_ animated: Bool) {
        print("view will appear")
        super.viewWillAppear(animated)
        navigationController?.setToolbarHidden(false, animated: false)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("view did appear")
        super.viewDidAppear(animated)
        
        
    }
    
    func initMapView() {
        mapView = MAMapView(frame: view.bounds)
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.userTrackingMode = MAUserTrackingMode.follow
        view.addSubview(mapView)
    }
    var gpsButton: UIButton!
    func initOtherView(){
        
        toolbar = navigationController?.toolbar
        let zoomPannelView = self.makeZoomPannelView()
        zoomPannelView.center = CGPoint.init(x: self.view.bounds.size.width -  zoomPannelView.bounds.width/2 - 10, y: self.view.bounds.size.height - toolbar.bounds.height -  zoomPannelView.bounds.width/2 - 30)
        
        zoomPannelView.autoresizingMask = [UIViewAutoresizing.flexibleTopMargin , UIViewAutoresizing.flexibleLeftMargin]
        self.view.addSubview(zoomPannelView)
        
        gpsButton = self.makeGPSButtonView()
        gpsButton.center = CGPoint.init(x: gpsButton.bounds.width / 2 + 10, y:self.view.bounds.size.height - toolbar.bounds.height -  gpsButton.bounds.width / 2 - 20)
        self.view.addSubview(gpsButton)
        gpsButton.autoresizingMask = [UIViewAutoresizing.flexibleTopMargin , UIViewAutoresizing.flexibleRightMargin]
    }
    func makeGPSButtonView() -> UIButton! {
        let ret = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 40, height: 40))
        ret.backgroundColor = UIColor.white
        ret.layer.cornerRadius = 4
        
        ret.setImage(UIImage.init(named: "gpsStat1"), for: UIControlState.normal)
        ret.addTarget(self, action: #selector(self.gpsAction), for: UIControlEvents.touchUpInside)
        
        return ret
    }
    
    func makeZoomPannelView() -> UIView {
        let ret = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 53, height: 98))
        
        let incBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 53, height: 49))
        incBtn.setImage(UIImage.init(named: "increase"), for: UIControlState.normal)
        incBtn.sizeToFit()
        incBtn.addTarget(self, action: #selector(self.zoomPlusAction), for: UIControlEvents.touchUpInside)
        
        let decBtn = UIButton.init(frame: CGRect.init(x: 0, y: 49, width: 53, height: 49))
        decBtn.setImage(UIImage.init(named: "decrease"), for: UIControlState.normal)
        decBtn.sizeToFit()
        decBtn.addTarget(self, action: #selector(self.zoomMinusAction), for: UIControlEvents.touchUpInside)
        
        ret.addSubview(incBtn)
        ret.addSubview(decBtn)
        
        return ret
    }
    //MARK:- event handling
    func zoomPlusAction() {
        let oldZoom = self.mapView.zoomLevel
        self.mapView.setZoomLevel(oldZoom+1, animated: true)
    }
    
    func zoomMinusAction() {
        let oldZoom = self.mapView.zoomLevel
        self.mapView.setZoomLevel(oldZoom-1, animated: true)
    }
    
    func gpsAction() {
        if(self.mapView.userLocation.isUpdating && self.mapView.userLocation.location != nil) {
            self.mapView.setCenter(self.mapView.userLocation.location.coordinate, animated: true)
            self.gpsButton.isSelected = true
            mapView.userTrackingMode = MAUserTrackingMode.follow
        }
    }
//    func initToolBar() {
//        let flexble = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
//        
//        showSegment.addTarget(self, action: #selector(showSegmentAction(sender:)), for: .valueChanged)
//        showSegment.selectedSegmentIndex = 0
//        
//        setToolbarItems([flexble, UIBarButtonItem(customView: showSegment), flexble], animated: false)
//    }
    func initToolBar(){
        let flexble = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let one = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action:  #selector(addRecord(sender:)))
        let carema = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.camera, target: self, action: #selector(takePhoto(sender:)))
        setToolbarItems([flexble, one,flexble ,carema, flexble], animated: true)
        

    }
    //MARK: - MAMapVie Delegate
    
    func mapView(_ mapView: MAMapView!, viewFor annotation: MAAnnotation!) -> MAAnnotationView! {
        if annotation is MAPointAnnotation {
            let pointReuseIndetifier = "pointReuseIndetifier"
            
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: pointReuseIndetifier) as? MAPinAnnotationView
            
            if annotationView == nil {
                annotationView = MAPinAnnotationView(annotation: annotation, reuseIdentifier: pointReuseIndetifier)
            }
            
            annotationView?.canShowCallout  = false
            annotationView?.animatesDrop    = false
            annotationView?.isDraggable     = false
            annotationView?.image           = UIImage(named: "icon_location.png")
            
            return annotationView
        }
        
        return nil
    }
    override func viewWillDisappear(_ animated: Bool) {
        //save the current position
        
//        mapView.removeAnnotation(pointAnnotation)
        
        
        if self.isMovingFromParentViewController{
            locationManager.stopUpdatingLocation()
        }else{
            savePosition()
            locationManager.stopUpdatingLocation()
        }
        
    }
    
    var point = CurrentPoint()
    func savePosition(){
        if (point != nil){
            let dic =  UserDefaults.standard
            dic.set(point.latitude, forKey: "lat")
            dic.set(point.longitude, forKey: "lon")
            dic.set(point.detailAddress, forKey: "add")
            dic.synchronize()
//            print("\(dic.double(forKey: "lat")) - \(dic.double(forKey: "lon")) - \(dic.string(forKey: "add"))")
        }
    }
}
extension MapViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func takePhotos(){
        //判断相机是否可用 可以就调用
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = UIImagePickerControllerSourceType.camera
            
//            picker.allowsEditing = true  // 允许拍摄图片后编辑
            self.present(picker, animated: true, completion: nil)
        } else {
            print("can't find camera")
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("photo finished")
        UIImageWriteToSavedPhotosAlbum(info[UIImagePickerControllerOriginalImage] as! UIImage, nil, nil, nil)
        UIImageWriteToSavedPhotosAlbum(<#T##image: UIImage##UIImage#>, <#T##completionTarget: Any?##Any?#>, <#T##completionSelector: Selector?##Selector?#>, <#T##contextInfo: UnsafeMutableRawPointer?##UnsafeMutableRawPointer?#>)

        UIView.animate(withDuration: 0.001, animations: {
            picker.dismiss(animated: false, completion: {
                self.present(picker, animated: true, completion: nil)
            })
        })
        //        UIImageWriteToSavedPhotosAlbum(<#T##image: UIImage##UIImage#>, <#T##completionTarget: Any?##Any?#>, <#T##completionSelector: Selector?##Selector?#>, <#T##contextInfo: UnsafeMutableRawPointer?##UnsafeMutableRawPointer?#>)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("cancel imagepicker ")
        picker.dismiss(animated: true, completion: {
            print("dismiss picker")
        })

    }
}
class CurrentPoint: NSObject{
    var latitude: Double = 108.0
    var longitude: Double = 34.8
    var detailAddress: String = ""
    
}