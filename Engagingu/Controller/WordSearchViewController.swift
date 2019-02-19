//
//  TestingWordSearchViewController.swift
//  Engagingu
//
//  Created by Raylene on 30/1/19.
//  Copyright © 2019 Raylene. All rights reserved.
//

import UIKit
//To extract the char from the string
extension String {
    
    func index(at position: Int, from start: Index? = nil) -> Index? {
        let startingIndex = start ?? startIndex
        return index(startingIndex, offsetBy: position, limitedBy: endIndex)
    }
    
    func character(at position: Int) -> Character? {
        guard position >= 0, let indexPosition = index(at: position) else {
            return nil
        }
        return self[indexPosition]
    }
}



class WordSearchViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UITextFieldDelegate, UICollectionViewDelegateFlowLayout{
    
    let grid_size: Int = 10
    
    var grid: [[String]] = [[String]](repeating: [String](repeating : "_" , count: 10), count: 10)
 
    var step_x : Int = 0  // placement occupied
    var step_y : Int = 0
    var x_position : Int = 0  //rdm starting position on grid
    var y_position: Int = 0
    var ending_x : Int = 0  //end position based on rdm starting position + moving in step_x/y direction
    var ending_y: Int = 0
    var new_position_x: Int = 0  //success position stored
    var new_position_y: Int = 0
    
    
    @IBOutlet weak var collectionGrid: UICollectionView!
    
    //tracking number of rows in UI Collection View
    var counter: Int = 0
    
    //to store the values
    var emptyDict: [String: Array<Int>] = [:]
    
    //textfield
    @IBOutlet weak var firstWord: UITextField!
    @IBOutlet weak var secondWord: UITextField!
    @IBOutlet weak var thirdWord: UITextField!
    @IBOutlet weak var fourthWord: UITextField!
    @IBOutlet weak var fifthWord: UITextField!
    
    
     //user types in correct word
    var correctList : Array<String> = []
    
    //user types in wrong word
    var wrongList: Array<String> = []
    
    //list from DB
    let list = ["gold", "maroon", "blue", "green", "brown"]
    
    
    //captalised list from DB --> empty array only in the main method then uppercased
    var capitalised_list: Array<String> = []
    
    //function to print the grid
    func print_grid(){
        for x in 0 ..< (grid_size){
            print (grid[x])
        }
    }
    
    // to return a random letter from A-Z
    let uppercaseLetters = (65...90).map {Character(UnicodeScalar($0))}
    func randomLetter() -> Character {
        return uppercaseLetters.randomElement()!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print_grid()
        //to dismiss keyboard when press return
        self.firstWord.delegate = self
        self.secondWord.delegate = self
        self.thirdWord.delegate = self
        self.fourthWord.delegate = self
        self.fifthWord.delegate = self
        
        //let list = ["gold", "maroon", "blue", "green", "brown"]
        
       // var capitalised_list = [String]()
        
         for i in list {
            let capital_word: String = i.uppercased()
            capitalised_list.append(capital_word)
        }
        
        print (capitalised_list)
        
        
        //horizontal and vertical only
        let orientations = ["rightleft", "updown"]
        
        for word in capitalised_list {
            let word_length: Int = word.count
            
            //Create new Key-value pair
             emptyDict.updateValue([], forKey: word)
            
            //In case out of room when trying to place a word
            var placed = false
            while !placed {
                let orientation = orientations.randomElement()
                //print(orientation)
                
                if orientation == "updown"{
                    step_x = 1
                    step_y = 0
                }
                if orientation == "rightleft"{
                    step_x = 0
                    step_y = 1
                }
                
                //choosing starting point for the word, with x and y coordinates
                x_position = Int(arc4random_uniform(UInt32(grid_size)))
                y_position = Int(arc4random_uniform(UInt32(grid_size)))
                
                //checking if the length of word is out of bounds
                ending_x = x_position + word.count*step_x
                ending_y = y_position + word.count*step_y
                
                if (ending_x < 0 || ending_x >= grid_size) {
                    continue                                  //choose another starting position on grid
                }
                if (ending_y < 0 || ending_y >= grid_size) {
                    continue

                }
                var failed: Bool = false
                
                //two things done here
                //first loop checks if the word can be place determine by
                //1. underscores
                //2. same character
                //if fails, then break out of this loop anc continue the bigger loop
                
                for i in 0 ..< word_length {
                    let character: String = String(word.character(at:i)!)
                    //i is a number
                    //to find the new position of every char on the grid
                    //whether it is occupied
                    new_position_x = x_position + i*step_x
                    new_position_y = y_position + i*step_y
                    
                    let character_at_new_position: String = grid[new_position_x][new_position_y]
                    if (character_at_new_position != "_") {
                        //space is occupied
                        //check for possibility of overlapping
                        if character_at_new_position == (character) {
                            continue
                        }
                        else {
                            failed = true
                            break
                        }
                    }
                   
                }
                if failed{
                    continue  //choose another starting position on grid
                }
                else {
                    //Word can be place on grid
                    for i in 0 ..< word_length {
                        let character: String = String(word.character(at:i)!)
                        new_position_x = x_position + i*step_x
                        new_position_y = y_position + i*step_y
                        grid[new_position_x][new_position_y] = character
                        placed = true
                        
                        //store every placing of each character of the word
                        emptyDict[word]?.append(new_position_x)
                        emptyDict[word]?.append(new_position_y)
                       
                        print(emptyDict)
                        
                    }
                }
             
            }
        }
        for x in 0 ..< grid_size {
            for y in 0 ..< grid_size {
                if grid[x][y] == "_" {
                    grid[x][y] = String(randomLetter())
                }
            }
        }
        //check
         print_grid()
    }
   
    //dismiss keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        //return rows
        return grid.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return columns
        return grid[section].count
        
    }
    
    //to set the width and height of every individual cell to confine to the width and height of the collectionView
    //so that it will appear to be centralised
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        print("w", (collectionView.frame.width)/CGFloat(grid_size))
        print("h", (collectionView.frame.height)/CGFloat(grid_size))
        
        return CGSize(width: (collectionView.frame.width)/CGFloat(grid_size), height: collectionView.frame.height/CGFloat(grid_size))
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? WordSearchTableViewCell, let columns = grid.first?.count{
         
            let item = indexPath.item
            
            let row : Int = counter
            let column : Int = Int(CGFloat(item).truncatingRemainder(dividingBy: CGFloat(columns)))
            
            //rowNum + 1 each time reaches last item of column
            if column == 9 {
                counter = counter + 1
            }
        
        //setCharacter
        cell.charLabel.text = grid[row][column]
        return cell
        }
        
        print("error")
        return UICollectionViewCell()
    }
    
    
   @IBAction func checkWordsSubmitted(_ sender: Any) {
        //store all textfield in array
        let enteredWords: Array<String> = [firstWord.text!.uppercased(), secondWord.text!.uppercased(), thirdWord.text!.uppercased(), fourthWord.text!.uppercased(), fifthWord.text!.uppercased()]
        //check if word in list is in the word user entered
        for word in enteredWords {
            if capitalised_list.contains(word) {
                correctList.append(word)
            }
        }
        //check the words that are missing by comparing correct list to the orginal list
        for word in capitalised_list {
            if !correctList.contains(word) {
                wrongList.append(word)
            }
        }
        print(wrongList)
        print(correctList)
        //highlight cell green
        if correctList.count > 0 {
            for word in correctList {
                let storageOfWordsPosition: Array<Int> = emptyDict[word]!
                for num in stride (from:0, to:storageOfWordsPosition.count, by:2){
                    //item is column, section is row
                    let cell = collectionGrid.cellForItem(at: IndexPath.init(item: storageOfWordsPosition[num+1], section: storageOfWordsPosition[num]))
                    cell?.backgroundColor = UIColor.green
                }
            }
        }
    //highlight cell red
        if wrongList.count > 0 {
            for word in wrongList {
                let storageOfWordsPosition: Array<Int> = emptyDict[word]!
                for num in stride (from:0, to:storageOfWordsPosition.count, by:2){
                    let cell = collectionGrid.cellForItem(at: IndexPath.init(item: storageOfWordsPosition[num+1], section: storageOfWordsPosition[num]))
                    cell?.backgroundColor = UIColor.red
                }
            }
        }
    }
    

    
}
