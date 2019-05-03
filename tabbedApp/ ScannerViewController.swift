//
//  ViewController.swift
//  QRReader
//
//  Created by Sebastian Hette on 17.07.2017.
//  Copyright © 2017 MAGNUMIUM. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

class ScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    // カメラやマイクの入出力を管理するオブジェクトを生成
    private let session = AVCaptureSession()
    
    
    @objc func backButtonPressed() {
        dismiss(animated: true, completion: nil)
        //        navigationController?.popViewController(animated: true)
    }
    
    func makeBackButton() -> UIButton {
        let backButtonImage = UIImage(named: "backbutton")?.withRenderingMode(.alwaysTemplate)
        let backButton = UIButton(type: .custom)
        backButton.setImage(backButtonImage, for: .normal)
        backButton.tintColor = .blue
        backButton.setTitle("  Back", for: .normal)
        backButton.setTitleColor(.blue, for: .normal)
        backButton.addTarget(self, action: #selector(self.backButtonPressed), for: .touchUpInside)
        return backButton
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        DispatchQueue.main.async {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "starter")
            self.present(newViewController, animated: true, completion: nil)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view, typically from a nib.
        
        // カメラやマイクのデバイスそのものを管理するオブジェクトを生成（ここではワイドアングルカメラ・ビデオ・背面カメラを指定）
        let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera],
                                                                mediaType: .video,
                                                                position: .back)
        
        // ワイドアングルカメラ・ビデオ・背面カメラに該当するデバイスを取得
        let devices = discoverySession.devices
        
        self.view.backgroundColor = .blue
        self.navigationItem.title = title
        self.navigationController?.navigationBar.barTintColor = .white
        
        //imagem para voltar
        let imageName = "close-icon"
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image!)
        
        imageView.frame = CGRect(x: 10, y: 20, width: 50, height: 50)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)
        view.addSubview(imageView)
        
        
        
        //　該当するデバイスのうち最初に取得したものを利用する
        if let backCamera = devices.first {
            do {
                // QRコードの読み取りに背面カメラの映像を利用するための設定
                let deviceInput = try AVCaptureDeviceInput(device: backCamera)
                
                if self.session.canAddInput(deviceInput) {
                    self.session.addInput(deviceInput)
                    
                    // 背面カメラの映像からQRコードを検出するための設定
                    let metadataOutput = AVCaptureMetadataOutput()
                    
                    if self.session.canAddOutput(metadataOutput) {
                        self.session.addOutput(metadataOutput)
                        
                        metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
                        metadataOutput.metadataObjectTypes = [.qr]
                        
                        // 背面カメラの映像を画面に表示するためのレイヤーを生成
                        let previewLayer = AVCaptureVideoPreviewLayer(session: self.session)
                        previewLayer.frame = self.view.bounds
                        previewLayer.videoGravity = .resizeAspectFill
                        self.view.layer.addSublayer(previewLayer)
                        
                        imageView.frame = CGRect(x: 10, y: 35, width: 50, height: 50)
                        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
                        imageView.isUserInteractionEnabled = true
                        imageView.addGestureRecognizer(tapGestureRecognizer)
                        view.addSubview(imageView)
                        
                        
                        //mira
                        let mainImage = UIImage(named:"aim")
                        let mainImageView = UIImageView(image:mainImage)
                        mainImageView.center = self.view.center
                        mainImageView.contentMode = .scaleAspectFit
                        self.view.addSubview(mainImageView)
                        
                        
                        // 読み取り開始
                        self.session.startRunning()
                    }
                }
            } catch {
                print("Error occured while creating video device input: \(error)")
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        for metadata in metadataObjects as! [AVMetadataMachineReadableCodeObject] {
            // QRコードのデータかどうかの確認
            if metadata.type != .qr { continue }
            
            // QRコードの内容が空かどうかの確認
            if metadata.stringValue == nil { continue }
            
            /*
             このあたりで取得したQRコードを使ってゴニョゴニョする
             読み取りの終了・再開のタイミングは用途によって制御が異なるので注意
             以下はQRコードに紐づくWebサイトをSafariで開く例
             */
            
            // URLかどうかの確認
            if let url = URL(string: metadata.stringValue!) {
                // 読み取り終了
                self.session.stopRunning()
                // QRコードに紐付いたURLをSafariで開く
                //UIApplication.shared.open(url, options: [:], completionHandler: nil)
                
                //Got Key
                UserDefaults.standard.set( metadata.stringValue! , forKey: "loginJSONValue")
                //Send next view
                DispatchQueue.main.async {
                    
                    let alertController = UIAlertController(title: "Alert", message: "Success", preferredStyle: .alert)
                    
                    let action1 = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
                        print("You've pressed default");
                        //go to storyboard
                        sleep(2)
                        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let newViewController = storyBoard.instantiateViewController(withIdentifier: "question")
                        self.present(newViewController, animated: true, completion: nil)
                    }
                    
                    
                    
                    alertController.addAction(action1)
                    
                    self.present(alertController, animated: true, completion: nil)
                    
                    
                }
                
                break
            }
        }
    }
}



