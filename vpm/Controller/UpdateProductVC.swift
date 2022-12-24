//
//  UpdateProductVC.swift
//  vpm
//
//  Created by Nik Kumbhani on 24/12/22.
//

import UIKit

class UpdateProductVC: UIViewController {

    @IBOutlet weak var txtProductName: UITextField!
    @IBOutlet weak var txtBrand: UITextField!
    @IBOutlet weak var txtDiscount: UITextField!
    
    var objProduct: Product?
    var arrAllProducts: [Product]?
    var index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        displayData()
    }
    

    func displayData(){
        txtProductName.text = objProduct?.productName
        txtBrand.text = objProduct?.brand?.brandName
        txtDiscount.text = "\(objProduct?.discountPercentage ?? 0.0)"
    }
    
    // MARK: - Update Action
    @IBAction func btnUpdateAction(_ sender: Any) {
        
        self.view.endEditing(true)
        
        if txtProductName.text!.isEmptyText(){
            self.view.makeToast("Please enter product name")
            return
        }
        
        if txtBrand.text!.isEmptyText(){
            self.view.makeToast("Please enter brand name")
            return
        }
        
        if txtDiscount.text!.isEmptyText(){
            self.view.makeToast("Please enter discunt")
            return
        }
        
        arrAllProducts?[index].productName = txtProductName.text!
        arrAllProducts?[index].brand?.brandName = txtBrand.text!
        arrAllProducts?[index].discountPercentage = Double(txtDiscount.text!)
        
        ProductDataModel.allProducts = self.arrAllProducts
        self.view.makeToast("Product Ipdated Sucessfully")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.navigationController?.popViewController(animated: true)
        }
    }
}
