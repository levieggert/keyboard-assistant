//
//  Created by Levi Eggert.
//  Copyright © 2019 Levi Eggert. All rights reserved.
//

import UIKit

class ViewSizeScrollViewController: UIViewController
{
    // MARK: - Properties
    
    private var keyboardAssistant: KeyboardAssistant!
    
    // MARK: - Outlets
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btRegisterAccount: UIButton!
    
    @IBOutlet weak var scrollViewBottomConstraint: NSLayoutConstraint!
    
    // MARK: - Life Cycle
    
    deinit
    {
        print("deinit: \(type(of: self))")
    }

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let useAutoKeyboardAssistant: Bool = false
        let allowToSetInputDelegates: Bool = true
        
        //let navigator: InputNavigator = InputNavigator.createDefaultNavigationController()
        let navigator: InputNavigator = InputNavigator.createWithKeyboardNavigation(shouldSetTextFieldDelegates: true)
        navigator.addInputItems(from: self)
        
        if (!allowToSetInputDelegates)
        {
            for item in navigator.inputItems
            {
                if let textField = item as? UITextField
                {
                    textField.delegate = self
                }
            }
        }
        
        if (useAutoKeyboardAssistant)
        {
            self.keyboardAssistant = KeyboardAssistant.createAutoScrollViewKeyboardAssistant(inputNavigator: navigator,
                                                                                             positionScrollView: self.scrollView,
                                                                                             positionConstraint: .viewBottomToTopOfKeyboard,
                                                                                             positionOffset: 30,
                                                                                             bottomConstraint: self.scrollViewBottomConstraint,
                                                                                             bottomConstraintLayoutView: self.view)
        }
        else
        {
            self.keyboardAssistant = KeyboardAssistant.createManualKeyboardAssistant(inputNavigator: navigator,
                                                                                     delegate: self,
                                                                                     bottomConstraint: self.scrollViewBottomConstraint,
                                                                                     bottomConstraintLayoutView: self.view)
        }
        
        self.keyboardAssistant.loggingEnabled = true
        self.keyboardAssistant.observer.loggingEnabled = true
        
        let items: [UIView] = InputNavigator.getInputItems(from: self)
        print(" --> total input items: \(items.count)")
        for item in items
        {
            if let textField = item as? UITextField
            {
                print("  placeholder: \(String(describing: textField.placeholder))")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        self.keyboardAssistant.start()
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        self.keyboardAssistant.stop()
    }
    
    // MARK: - Actions
    
    @IBAction func handleBack(barButtonItem: UIBarButtonItem)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func handleFilter(barButtonItem: UIBarButtonItem)
    {
        
    }
    
    @IBAction func handleRegisterAccount(button: UIButton)
    {
        self.keyboardAssistant.closeKeyboard()
        //self.keyboardAssistant.navigator.focusedItem = nil // Same as self.keyboardAssistant.closeKeyboard()
    }
}

// MARK: - UITextFieldDelegate

extension ViewSizeScrollViewController: UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {        
        _ = self.keyboardAssistant.navigator.textFieldShouldReturn(textField)
        
        return true
    }
}

// MARK: - KeyboardAssistantDelegate

extension ViewSizeScrollViewController: KeyboardAssistantDelegate
{
    func keyboardAssistantManuallyReposition(keyboardAssistant: KeyboardAssistant, toInputItem: UIView, keyboardHeight: CGFloat)
    {
        let constraint: KeyboardAssistant.RepositionConstraint = .viewBottomToTopOfKeyboard
        let offset: CGFloat = 20
        
        if (toInputItem == self.txtFirstName)
        {
            keyboardAssistant.reposition(scrollView: self.scrollView, toInputItem: self.txtLastName, constraint: constraint, offset: offset)
        }
        else if (toInputItem == self.txtLastName)
        {
            keyboardAssistant.reposition(scrollView: self.scrollView, toInputItem: self.txtEmail, constraint: constraint, offset: offset)
        }
        else if (toInputItem == self.txtEmail)
        {
            keyboardAssistant.reposition(scrollView: self.scrollView, toInputItem: self.txtPassword, constraint: constraint, offset: offset)
        }
        else if (toInputItem == self.txtPassword)
        {
            keyboardAssistant.reposition(scrollView: self.scrollView, toInputItem: self.btRegisterAccount, constraint: constraint, offset: offset)
        }
    }
}

