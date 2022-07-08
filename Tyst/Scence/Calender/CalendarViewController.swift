//
//  CalenderViewController.swift
//  Tyst
//
//  Created by hb on 14/11/19.
//  Copyright © 2019 hb. All rights reserved.
//

import UIKit
import FSCalendar

class CalendarViewController: BaseViewControllerWithAd {
    
    //MARK: IBOutlet Constants
    @IBOutlet weak var calendarView: FSCalendar!
    @IBOutlet weak var btnCancle: UIButton!
    @IBOutlet weak var btnReset: UIButton!
    @IBOutlet weak var btnSubmit: WLButton!
    
    private var firstDate: Date?
    private var lastDate: Date?
    private var datesRange: [Date]?
    var updateDateDelegate: UpdateHomeDate?
    var isFrom = ""
    
    //MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Select Date"
        self.calendarView.allowsMultipleSelection = true
        self.changeColor(image: UIImage(named: "img_cross") ?? UIImage(), color: UIColor(named: "ButtonColor")!, button: btnCancle)
        if isFrom == "Home" {
            self.btnReset.isHidden = false
        }else {
            self.btnReset.isHidden = true
        }
        if isFrom == "Export" {
            self.btnSubmit.setTitle("Generate Log", for: .normal)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isFrom == "Home" {
            self.isFrom = ""
            WhiteLabelSessionHandler.shared.addCount = WhiteLabelSessionHandler.shared.addCount + 1
        }
    }
    
    //MARK: Class Instance
    class func instance() -> CalendarViewController? {
        return UIStoryboard(name: "Calendar", bundle: nil).instantiateViewController(withIdentifier: "CalendarViewController") as? CalendarViewController
    }
    
    //MARK: Class Methods
    
    /// Method used to set date range
    /// - Parameters:
    ///   - from: from date
    ///   - to: to date
    func datesRange(from: Date, to: Date) -> [Date] {
        if from > to { return [Date]() }
        
        var tempDate = from
        var array = [tempDate]
        
        while tempDate < to {
            tempDate = Calendar.current.date(byAdding: .day, value: 1, to: tempDate)!
            array.append(tempDate)
        }
        
        return array
    }
    
    /// Method used for convert date to string
    /// - Parameter myDate: date
    func getStringDate(myDate: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from:myDate)
        return dateString
    }
    
    
    
    //MARK: IBAction
    @IBAction func btnDismisssTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func btnSubmitAction(_ sender: Any) {
        if firstDate == nil {
            self.showTopMessage(message: AlertMessage.selectStartDate, type: .Error)
        }else if lastDate == nil {
            self.showTopMessage(message: AlertMessage.selectEndDate, type: .Error)
        }else {
            if isFrom == "Export" {
                self.addAnayltics(analyticsParameterItemID: "id-createstatement", analyticsParameterItemName: "click_createstatement", analyticsParameterContentType: "click_createstatement")
            }
            updateDateDelegate?.updateDate(startDate: self.getStringDate(myDate: firstDate ??  Date()), endDate: self.getStringDate(myDate: lastDate ?? Date()))
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func btnResetAction(_ sender: Any) {
        updateDateDelegate?.updateDate(startDate: "", endDate: "")
        self.dismiss(animated: true, completion: nil)
    }

}

//MARK: Calender Methods
extension CalendarViewController: FSCalendarDelegate, FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        if firstDate == nil {
            firstDate = date
            datesRange = [firstDate!]
            return
        }
        
        if firstDate != nil && lastDate == nil {
            // handle the case of if the last date is less than the first date:
            if date <= firstDate! {
                calendar.deselect(firstDate!)
                firstDate = date
                datesRange = [firstDate!]
                return
            }
            
            let range = datesRange(from: firstDate!, to: date)
            
            lastDate = range.last
            
            for d in range {
                calendar.select(d)
            }
            
            datesRange = range
            
            print("datesRange contains: \(datesRange!)")
            
            return
        }
        
        if firstDate != nil && lastDate != nil {
            for d in calendar.selectedDates {
                calendar.deselect(d)
            }
            lastDate = nil
            firstDate = nil
            datesRange = []
        }
    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        if firstDate != nil && lastDate != nil {
            for d in calendar.selectedDates {
                calendar.deselect(d)
            }
            lastDate = nil
            firstDate = nil
            datesRange = []
            print("datesRange contains: \(datesRange!)")
        }
    }
    
    func maximumDate(for calendar: FSCalendar) -> Date {
        return Date()
    }
    
}


