//
//  SearchVC.swift
//  GHRA
//
//  Created by Digitalrooar on 15/12/21.
//

import UIKit
import Kingfisher

class DashboardVC: UIViewController {
    
    @IBOutlet var searchVw: UISearchBar!
    @IBOutlet weak var tblVwProductList: UITableView!
    @IBOutlet weak var lblNoData: UILabel!
    
    private var search = UISearchController(searchResultsController: nil)
    
    var arrAllProducts: [Product]?
    var arrProducts: [Product]?
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        search.searchBar.delegate = self
        search.searchBar.sizeToFit()
        search.searchBar.tintColor = UIColor.black
        search.obscuresBackgroundDuringPresentation = false
        search.hidesNavigationBarDuringPresentation = true
        self.definesPresentationContext = true
        search.searchBar.placeholder = "Search products"
        self.navigationItem.searchController = search

        // Add Refresh Control
        refreshControl.attributedTitle = NSAttributedString(string: "")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tblVwProductList.addSubview(refreshControl)
        
        let allProducts = ProductDataModel.allProducts ?? []
        if allProducts.count == 0{
            getProductsApiCall()
        }else{
            arrAllProducts = allProducts
            arrProducts = allProducts
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        
        let allProducts = ProductDataModel.allProducts ?? []
        arrAllProducts = allProducts
        arrProducts = allProducts
        tblVwProductList.reloadData()
    }
    
    @objc func refresh(_ sender: AnyObject) {
       // Code to refresh table view
        arrProducts?.removeAll()
        tblVwProductList.reloadData()
        getProductsApiCall(isRefresh: true)
    }
    
    // MARK: - API CALL Products
    func getProductsApiCall(isRefresh:Bool = false){
        
        if !isRefresh{
            DispatchQueue.main.async{
                _ = MBProgressHUD.showHUDAddedTo(view: self.view, animated: true)
            }
        }
        
        AAPWebService.callGetApi(api: WebServices.get_products, parameters: nil, view_screen: self) { [self] (data,dict) in
            
            print(dict)
            
            refreshControl.endRefreshing()
            
            do {
                let productData = try JSONDecoder().decode([Product].self, from: data)
                
                arrProducts = productData
                ProductDataModel.allProducts = productData
               
                if arrProducts?.count ?? 0 > 0{
                    lblNoData.isHidden = true
                    tblVwProductList.reloadData()
                }else{
                    lblNoData.isHidden = false
                }
            }catch{
                self.view.makeToast("Error in JSON parsing")
            }
            
            DispatchQueue.main.async{
                _ = MBProgressHUD.hideHUDForView(view: self.view, animated: true)
            }
        }
    }
    
    @IBAction func btnLogoutction(_ sender: Any) {
        var actions: [(String, UIAlertAction.Style)] = []
        actions.append(("Log Out", UIAlertAction.Style.default))
        actions.append(("Cancel", UIAlertAction.Style.cancel))
        
        Alerts.showActionsheet(viewController: self, title: "VPM", message: "Are you sure you want to Log Out of this session?", actions: actions) { (index) in
            print("call action \(index)")
            if index == 0{
                if let Login_VC = self.storyboard?.instantiateViewController(withIdentifier: "RootNav"){
                    kUserDefultsRemove(key: PARAMETERS.token)
                    kUserDefultsRemove(key: "allProducts")
                    Login_VC.modalPresentationStyle = .overFullScreen
                    self.present(Login_VC, animated: false)
                    
                }
            }
        }
    }
}
extension DashboardVC: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrProducts?.count ?? 0 > 0{
            return arrProducts?.count ?? 0
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let productCell = tableView.dequeueReusableCell(withIdentifier: "ProductTblCell", for: indexPath) as! ProductTblCell
        
        let obj = arrProducts?[indexPath.row]
        
        if let url = URL(string: obj?.logoUrls?.first ?? ""){
            let resource = ImageResource(downloadURL: url)
            productCell.imgVwProductImage.kf.setImage(with: resource, placeholder: img_placeholder)
        }
        
        productCell.lblProductTitle.text = obj?.productName
        productCell.lblBrandName.text = obj?.brand?.brandName
        productCell.lblCountry.text = obj?.country?.name
        productCell.lblPrice.text = "\(String(describing: obj?.discountPercentage ?? 0.0))%"
        
//        if let url = URL(string: obj?.country?.flagURL ?? ""){
//            let resource = ImageResource(downloadURL: url)
//            productCell.imgVwCountryFlag.kf.setImage(with: resource, placeholder: img_placeholder)
//        }
        
        return productCell
    }
    

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let obj = arrProducts?[indexPath.row]

        // Delete Action
        let deleteQty = UIContextualAction(style: .destructive, title: "Delete") { (action, sourceView, completionHandler) in
            let index = self.arrAllProducts?.firstIndex(where: { product in
                return product.productID == obj?.productID
            })
            
            if index != nil{
                self.arrAllProducts?.remove(at: index!)
                ProductDataModel.allProducts = self.arrAllProducts
            }
            
            self.arrProducts?.remove(at: indexPath.row)
            self.tblVwProductList.deleteRows(at: [indexPath], with: .fade)
            completionHandler(true)
        }

        deleteQty.backgroundColor = UIColor.red

        // Edit Action
        let edit = UIContextualAction(style: .destructive, title: "Edit") { (action, sourceView, completionHandler) in
            if let UpdateProduct_VC = self.storyboard?.instantiateViewController(withIdentifier: "UpdateProductVC") as? UpdateProductVC{
                let index = self.arrAllProducts?.firstIndex(where: { product in
                    return product.productID == obj?.productID
                })
                UpdateProduct_VC.index = index ?? 0
                UpdateProduct_VC.objProduct = obj
                UpdateProduct_VC.arrAllProducts = self.arrAllProducts
                self.navigationController?.pushViewController(UpdateProduct_VC, animated: true)
            }
            completionHandler(true)
        }
        edit.backgroundColor = UIColor.black
        
        return UISwipeActionsConfiguration(actions: [deleteQty,edit])
        
    }
}
extension DashboardVC:UISearchBarDelegate{
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = true
        return true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        if arrProducts?.count ?? 0 > 0{
            self.tblVwProductList.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
        }
        searchBar.endEditing(true)
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
        
        self.lblNoData.isHidden = true
        arrProducts = self.arrAllProducts
        self.tblVwProductList.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmptyText(){
            if arrProducts?.count ?? 0 > 0{
                self.tblVwProductList.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
            }
            self.lblNoData.isHidden = true
            arrProducts = self.arrAllProducts
            self.tblVwProductList.reloadData()
        }else{
            
            DispatchQueue.main.async{
                self.arrProducts = self.arrAllProducts?.filter {
                    return $0.productName?.lowercased().contains(searchText.lowercased()) ?? false
                }
        
                self.lblNoData.isHidden = (self.arrProducts?.count ?? 0 > 0) ? true : false
                self.tblVwProductList.reloadData()
            }
        }
    }
}
