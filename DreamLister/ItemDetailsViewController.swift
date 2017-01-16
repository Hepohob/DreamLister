//
//  ItemDetailsViewController.swift
//  DreamLister
//
//  Created by Aleksei Neronov on 15.01.17.
//  Copyright © 2017 Aleksei Neronov. All rights reserved.
//

import UIKit
import CoreData

class ItemDetailsViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var storePicker: UIPickerView!
    @IBOutlet weak var titleField: CustomTextField!
    @IBOutlet weak var priceField: CustomTextField!
    @IBOutlet weak var detailsField: CustomTextField!
    @IBOutlet weak var pickImage: UIImageView!
    @IBOutlet weak var typeSegments: UISegmentedControl!
    
    var stores = [Store]()
    var types = [ItemType]()
    var itemToEdit: Item?
    var imagePicker: UIImagePickerController!

    
    @IBAction func savePressed(_ sender: UIButton) {
        var item: Item!
        let picture = Image(context: context)
        picture.image = pickImage?.image
        
        if itemToEdit == nil {
            item = Item(context: context)
        } else {
            item = itemToEdit
        }
        
        item.toImage = picture

        if let title = titleField.text {
            item.title = title
        }
        if let price = priceField.text {
            item.price = (price as NSString).doubleValue
        }
        if let details = detailsField.text {
            item.details = details
        }
        item.toStore = stores[storePicker.selectedRow(inComponent: 0)]
        item.toItemType = types[typeSegments.selectedSegmentIndex]
        ad.saveContext()
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func deletePressed(_ sender: UIBarButtonItem) {
        if itemToEdit != nil {
            context.delete(itemToEdit!)
            ad.saveContext()
        }
        _ = navigationController?.popViewController(animated: true)
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        if let topItem = self.navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "",
                                                        style: .plain,
                                                        target: nil,
                                                        action: nil)
        }
        storePicker.delegate = self
        storePicker.dataSource = self
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
//        let store = Store(context: context)
//        store.name = "Best buy"
//        let store2 = Store(context: context)
//        store2.name = "Tesla dealer"
//        let store3 = Store(context: context)
//        store3.name = "Frys electronics"
//        let store4 = Store(context: context)
//        store4.name = "Tafget"
//        let store5 = Store(context: context)
//        store5.name = "Amazon"
//        let store6 = Store(context: context)
//        store6.name = "Mediamarkt"
//        
//        ad.saveContext()

//        let type0 = ItemType(context: context)
//        type0.type = typeSegments.titleForSegment(at: 0)
//        let type1 = ItemType(context: context)
//        type1.type = typeSegments.titleForSegment(at: 1)
//        let type2 = ItemType(context: context)
//        type2.type = typeSegments.titleForSegment(at: 2)
//        let type3 = ItemType(context: context)
//        type3.type = typeSegments.titleForSegment(at: 3)
//        ad.saveContext()
        
        getStores()
        getTypes()
        
        if itemToEdit != nil {
            loadItemData()
        }
    }

    //MARK: picker delegates and datasources
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let store = stores[row]
        return store.name
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return stores.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // update when selected
    }

    //MARK: Coredata store/read
    
    func getStores() {
        let fetchRequest: NSFetchRequest<Store> = Store.fetchRequest()
        do {
            self.stores = try context.fetch(fetchRequest)
            self.storePicker.reloadAllComponents()
        } catch {
            // handle error
            let error = error as NSError
            print(error)
        }
    }
    
    func getTypes() {
        let fetchRequest: NSFetchRequest<ItemType> = ItemType.fetchRequest()
        do {
            self.types = try context.fetch(fetchRequest)
        } catch {
            // handle error
            let error = error as NSError
            print(error)
        }
    }
    
    func loadItemData() {
        if let item = itemToEdit {
            titleField.text = item.title
            priceField.text = "\(item.price)"
            detailsField.text = item.details
            pickImage.image = item.toImage?.image as? UIImage
            
            if let type = item.toItemType {
                var index = 0
                repeat {
                    let t = types[index]
                    if let typeString = t.type as String? {
                        if typeString == type.type {
                            typeSegments.selectedSegmentIndex = index
                            break
                        }
                        index += 1
                    }
                } while (index < types.count)
            }
            
            if let store = item.toStore {
                var index = 0
                repeat {
                    let s = stores[index]
                    if s.name == store.name {
                        storePicker.selectRow(index,
                                                inComponent: 0,
                                                animated: false)
                        break
                    }
                    index += 1
                } while (index < stores.count)
            }
            
        }
    }
    
    @IBAction func addImage(_ sender: UIButton) {
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            pickImage.image = image
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func typeSelected(_ sender: UISegmentedControl) {
        
    }
    
}
