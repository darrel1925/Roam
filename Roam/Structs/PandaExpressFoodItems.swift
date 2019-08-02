//
//  PandaExpressFoodItems.swift
//  Roam
//
//  Created by Kay Lab on 5/21/19.
//  Copyright © 2019 Darrel Muonekwu. All rights reserved.
//

import Foundation

struct PandaExpress {
    
    struct Plate {
        
        static let title = "Plates"

        static let header = ["Build Your Own Plate - 2 Half Sides",
                             "Build Your Own Plate - 1 Full Side"]
        static let description = ["Choose any 2 half sides and 2 entrees.",
                                  "Choose any 1 full side and 2 entrees."]
        static let price = 9.20
        
        struct Selection {
            
            struct Full {
                
                static let choices = ["Choose a full side", "Choose 1st entree", "Choose 2nd entree"]
                
                static let header = "Build Your Own Plate - 1 Full Side"
            }
            
            struct Half {
                
                static let choices = ["Choose a 1st half side", "Choose a 2nd half side", "Choose 1st entree", "Choose 2nd entree"]
                
                static let header = "Build Your Own Plate - 2 Half Sides"
            }
        }
    }
    
    struct BiggerPlate {
        
        static let title = "Bigger Plate"
        
        static let header = ["Build Your Own Bigger Plate - 2 Half Sides",
                             "Build Your Own Bigger Plate - 1 Full Side"]
        static let description = ["Choose any 2 half sides and 3 entrees.",
                                  "Choose any 1 full side and 2 entrees."]
        static let price = 10.95
        
        struct Selection {
            
            struct Full {
                
                static let choices = ["Choose a full side", "Choose 1st entree", "Choose 2nd entree", "Choose a 3rd entree"]
                
                static let header = "Build Your Own Bigger Plate - 1 Full Side"
            }
            
            struct Half {
                
                static let choices = ["Choose a 1st half side", "Choose a 2nd half side", "Choose 1st entree", "Choose 2nd entree", "Choose a 3rd entree"]
                
                static let header = "Build Your Own Bigger Plate - 2 Half Sides"
            }
        }
    }
    
    struct Bowl {
        
        static let title = "Bowl"
        
        static let header = ["Build Your Own Bowl - 2 Half Sides",
                             "Build Your Own Bowl - 1 Full Side"]
        static let description = ["Choose any 2 half sides and 1 entrees.",
                                  "Choose any 1 half side and 1 entrees."]
        static let price = 7.75
        
        struct Selection {
            
            struct Full {
                
                static let choices = ["Choose a full side", "Choose a full entree"]
                
                static let header = "Build Your Own Bowl - 1 Full Side"
            }
            
            struct Half {
                
                static let choices = ["Choose a 1st half side", "Choose a 2nd half side", "Choose an entree"]
                
                static let header = "Build Your Own Bowl - 2 Half Sides"
            }
        }
    }
    
    struct FamilyFeast {
        
        static let title = "Family Feast"
        
        static let header = ["Family Feast - 4 Half Sides",
                             "Family Feast - 2 Full Sides"]
        static let description = ["Choose any 4 large half sides and 3 entrees.",
                                  "Choose any 2 large full sides and 3 entrees."]
        static let price = 40.25
        
        struct Selection {
            
            struct Full {
                
                static let choices = ["Choose a full side", "Choose a 2nd full side", "Choose a 1st entree", "Choose a 2nd entree", "Choose a 3rd entree"]
                
                static let header = "Build Your Own Bowl - 2 Half Sides"
            }
            
            struct Half {
                
                static let choices = ["Choose a 1st half side", "Choose a 2nd half side", "Choose a 3rd half side", "Choose a 4th half side", "Choose a 1st entree", "Choose a 2nd entree", "Choose a 3rd entree"]
                
                static let header = "Build Your Own Bowl - 4 Half Sides"
            }
        }
    }
    
    struct SideOption {
        
        struct Half {
            
            static let name = ["Half Super Greens" , "Half Chow Mein", "Half White Steamed Rice", "Half Fried Rice"]
            
            static let price = [0.00, 0.00, 0.00, 0.00]
        }
        
        struct Full {
            
            static let name = ["Super Greens" , "Chow Mein", "White Steamed Rice", "Fried Rice"]
            
            static let price = [0.00, 0.00, 0.00, 0.00]
        }
    }
    
    struct EntreeOption {
        
        static let name = ["Super Greens", "String Bean Chicken Breast", "Kung Pao Chicken", "Grilled Teriyaki Chicken", "Beijing Beef", "Broccoli Beef", "SweetFire Chicken Breast", "Cream Cheese Rangoon", "Orange Chicken", "Chicken Egg Roll", "Veggie Spring Roll", "Mushroom Chicken", "Wok-Fired Shrimp", "Shanghai Angus Steak", "Honey Walnut Shrimp"]
        
        static let price = [0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 1.45, 1.45, 1.45]
    }
    
}
