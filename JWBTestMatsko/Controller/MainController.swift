//
//  MainController.swift
//  JWBTestMatsko
//
//  Created by Mykola Matsko on 3/17/18.
//  Copyright © 2018 Mykola Matsko. All rights reserved.
//

import UIKit

class MainController: UITableViewController, PopupDelegate, LoginDelegate {
    
    var token: String = ""
    var mydata: String = ""
    var myArray = [String : Int]()
    
    
    
    func accessTokenStored(value: String) {
        token = value
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPopup" {
            let popup = segue.destination as! PopupController
            popup.delegatePop = self
        }
        
        if segue.identifier == "toLogin" {
            let login = segue.destination as! LoginController
            login.delegateLog = self
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "identifier")
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return myArray.count
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "identifier", for: indexPath)
        
        let key = Array(self.myArray.keys)[indexPath.row]
        let value = Array(self.myArray.values)[indexPath.row]
        cell.textLabel?.text = String("\" \(key) \" - \(value) times")
        
        return cell
    }
    
    func getTextFromLocale(code: String) {
        
    print("Token: ", token)
        
        let urlComponents = NSURLComponents(string: "http://apiecho.cf/api/get/text/")!
        
        urlComponents.queryItems = [ NSURLQueryItem(name: "locale", value: code) as URLQueryItem ]
        
        guard let url = URL(string: (urlComponents.url?.absoluteString)!) else { return }
        
        let session = URLSession.shared
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "GET"
        
//        let access = token
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        session.dataTask(with: request as URLRequest) { (data, response, error) in
            if let response = response as? HTTPURLResponse {
                print(response)
                if response.statusCode == 200 {
                    if let data = data {
                        do {
                            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] {
                                print(json)
                                if let dataJson = json["data"] as? String {
                                    
//                                    self.mydata = dataJson
                                    self.countSymbols(data: dataJson)
                                }
                            }
                        } catch {
                            print(error)
                        }
                        
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                }
            }
            
            }.resume()
    }
    
    func countSymbols(data: String) {
        
        let value = data.lowercased()
        var arrayOfSymbols = [Character]()
        
        for character in value {
            if arrayOfSymbols.contains(character){
                continue
            } else {
                arrayOfSymbols.append(character)
            }
        }
        
        var namesOfCharacter = [String: Int]()
        var count = 0
        for item in arrayOfSymbols {
            for letter in value {
                if item == letter {
                    count += 1
                }
            }
            if item == " " {
                namesOfCharacter["space"] = count
            } else {
                namesOfCharacter[String(item)] = count
            }
            count = 0
        }
        
        print(namesOfCharacter)
        myArray = namesOfCharacter
    }
    
    @objc func handleLogout() {
        
        
        guard let url = URL(string: "http://apiecho.cf/api/logout/") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response)
            }
            
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)
                } catch {
                    print(error)
                }
            }
            }.resume()
        
        let loginController = LoginController()
        present(loginController, animated: true, completion: nil)
    }
}
