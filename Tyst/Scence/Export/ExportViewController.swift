//
//  ExportViewController.swift
//  Tyst
//
//  Created by hb on 06/11/19.
//  Copyright (c) 2019 hb. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import CRRefresh
import MessageUI


protocol ExportDisplayLogic: class {
    func didReceiveLogs(response: [Export.ViewModel]?, message: String, success: String)
    func didReceiveCreateLog(message: String, success: String)
}

class ExportViewController: BaseViewControllerWithAd {
    
    //MARK: IBOutlet Constant
    var interactor: ExportBusinessLogic?
    var router: (NSObjectProtocol & ExportRoutingLogic & ExportDataPassing)?
    
    @IBOutlet weak var viewAd: UIView!
    @IBOutlet weak var lblNoRecord: UILabel!
    @IBOutlet weak var tblView: UITableView!
    
    var logList = [Export.ViewModel]()
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    
    private func setup() {
        let viewController = self
        let interactor = ExportInteractor()
        let presenter = ExportPresenter()
        let router = ExportRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    // MARK: View lifecycle
    /// Method is called when view loads
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLayout()
    }
    
    /// Method is called when view will appears
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewAd.isHidden = (UserDefaultsManager.getLoggedUserDetails()?.userInfo?[0].purchaseStatus?.booleanStatus() ?? false)
    }
    
    /// Method is called when view did appear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setAddMobView(viewAdd: self.viewAd)
    }
    
    // MARK: Class Methods
    // SetUpLayout initial
    func setUpLayout() {
        self.addAnayltics(analyticsParameterItemID: "id-exportscreen", analyticsParameterItemName: "click_exportscreen", analyticsParameterContentType: "click_exportscreen")
        self.navigationItem.title = AlertMessage.exportTitle
        self.tblView.delegate = self
        self.tblView.dataSource = self
        self.interactor?.getLogs(loader: true)
        tblView.cr.addHeadRefresh(animator: NormalHeaderAnimator(frame: tblView.frame)) {[weak self] in
            if self?.internetAvailable() ?? false {
                self?.interactor?.getLogs(loader: false)
            }else {
                self?.tblView.cr.endHeaderRefresh()
            }
            
        }
    }
    
    /// Method used for download CSV File
    /// - Parameter fileUrl: file url
    func downloadMyCSV(fileUrl: String) {
        let nameArray = fileUrl.components(separatedBy: "/")
        let name = nameArray.last
        let temp = name?.components(separatedBy: ".")
       
        let defaultSession = URLSession(configuration: .default)
        var dataTask: URLSessionDataTask?
        dataTask?.cancel()
        if var urlComponents = URLComponents(string: fileUrl) {
            guard let url = urlComponents.url else {
                return
            }
            
            dataTask =
                defaultSession.dataTask(with: url) { [weak self] data, response, error in
                    defer {
                        dataTask = nil
                    }
                    
                    if let error = error {
                        print(error)
                    } else if
                        let data = data,
                        let response = response as? HTTPURLResponse,
                        response.statusCode == 200 {
                        self?.sendEmail(data: data, fileName: temp?.first ?? "")
                    }
            }
            
            dataTask?.resume()
        }
    }
    
    /// Method Used for send emal
    /// - Parameters:
    ///   - data: data
    ///   - fileName: file name
    func sendEmail(data:Data?, fileName: String){
        if( MFMailComposeViewController.canSendMail() ) {
            DispatchQueue.main.async {
                let mailComposer = MFMailComposeViewController()
                 mailComposer.mailComposeDelegate = self
                 //mailComposer.setSubject("CSV")
                 //mailComposer.setMessageBody("My body message", isHTML: true)
                 if let fileData = data {
                     mailComposer.addAttachmentData(fileData, mimeType: "application/csv", fileName: "\(fileName).csv")
                }
                self.present(mailComposer, animated: true, completion: nil)
                     return
            }
        }
    }
    
    //MARK: IBAction
    @IBAction func btnAddLogAction(_ sender: UIButton) {
        if let customPopUp = CalendarViewController.instance() {
            customPopUp.updateDateDelegate = self
            customPopUp.isFrom = "Export"
            self.present(customPopUp, animated: true, completion: nil)
        }
    }
    

}

//MARK: TableView Methods
extension ExportViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.logList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ExportCell.cellId, for: indexPath) as! ExportCell
        cell.setData(data: self.logList[indexPath.row])
        cell.buttonDownloadTapAction = {
            if self.internetAvailable() {
                self.addAnayltics(analyticsParameterItemID: "id-exportstatement", analyticsParameterItemName: "click_exportstatement", analyticsParameterContentType: "click_exportstatement")
                self.downloadMyCSV(fileUrl: self.logList[indexPath.row].logFile ?? "")
            }
        }
        return cell
    }
    
    
}

//MARK: API Response
extension ExportViewController: ExportDisplayLogic {
    
    func didReceiveCreateLog(message: String, success: String) {
        if success == "1" {
            self.interactor?.getLogs(loader: true)
        }else {
            self.showTopMessage(message: message, type: .Error)
        }
    }
    
    func didReceiveLogs(response: [Export.ViewModel]?, message: String, success: String) {
        self.tblView.cr.endHeaderRefresh()
        if success == "1" {
            if let resp = response {
                self.logList = resp
                lblNoRecord.text = ""
                lblNoRecord.isHidden = true
                self.tblView.reloadData()
            }
        } else {
            self.logList.removeAll()
            lblNoRecord.text = message
            lblNoRecord.isHidden = false
            self.tblView.reloadData()
        }
    }
}

//MARK: Custom Protocol UpdateHome data
extension ExportViewController: UpdateHomeDate {
    func updateDate(startDate: String, endDate: String) {
        let request = CreateLogs.Request(startDate: startDate, endDate: endDate)
        interactor?.generateLogs(request: request)
    }
}

//MARK: Custom Protocol mail composer delegate
extension ExportViewController: MFMailComposeViewControllerDelegate {
    
    public override func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?){
        self.dismiss(animated: true, completion: nil)
    }
}
