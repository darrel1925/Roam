//
//  WendysFoodItems.swift
//  Roam
//
//  Created by Kay Lab on 5/21/19.
//  Copyright © 2019 Darrel Muonekwu. All rights reserved.
//

import Foundation

struct Wendys {
    
    struct Hamburgers {
        
        static let title = "Hamburgers"
        
        static let header = ["Dave's Single®", "Dave's Double®", "Dave's Triple®", "Baconator®", "Son of Baconator®", "Jr. Bacon Cheeseburger", "Jr. Cheeseburger Deluxe", "Jr. Cheeseburger", "Double Stack™", "Jr. Hamburger", "Barbecue Cheeseburger Single", "Barbecue Cheeseburger Double", "Barbecue Cheeseburger Triple", "S'Awesome Bacon Cheeseburger Single", "S'Awesome Bacon Cheeseburger Double", "S'Awesome Bacon Cheeseburger Triple", "Peppercorn Mushroom Melt Single", "Peppercorn Mushroom Melt Double", "Peppercorn Mushroom Melt Triple"]
        
        static let description = [
            "It's our classic the way Dave intended! A juicy quarter pound of fresh, never frozen beef decorated with premium toppings all between a warm toasted bun.",
            "Oh yeah, you're seeing double. That's two fresh, never frozen beef patties with the freshest toppings on a warm toasted bun.",
            "When hunger strikes, this is where you turn. With three quarter pound fresh, never-frozen beef patties and our premium toppings, there's no way you can walk away hungry.",
            "Here's to the carnivores. Two 1/4 lb patties with six strips of bacon. There's not a single veggie to get in the way.",
            "Two juicy patties of 100% fresh, never frozen beef topped with strips of oven-cooked Applewood smoked bacon. Without a single veggie to get in the way, it's a perfectly-sized meaty masterpiece.",
            "Fresh, never frozen beef, Applewood smoked bacon, American cheese, crisp lettuce, tomato, and mayo. It’s a favorite of bacon lovers everywhere.",
            "Fresh, never frozen beef topped with cheese, pickles, onions, tomatoes, crisp lettuce, ketchup, and mayo. It’s big flavor at a junior price.",
            "Fresh, never frozen beef topped with cheese, pickles, onion, ketchup, and mustard on a toasted bun. It’s done just right, and just the right size.",
            "Two patties of fresh, never frozen beef with cheese, ketchup, mustard, pickle, and onion. It’s double the fresh beef, stacked with deliciousness.",
            "Fresh, never frozen beef topped with pickles, onion, ketchup, and mustard on a toasted bun. It’s done just right, and just the right size.",
            "A quarter-pound of fresh, never-frozen beef, crispy fried onions and American cheese, covered in sweet and smoky barbecue sauce all on a toasted bun. This stampede of flavor is the best barbecue hamburger in the west–or north or south or east for that matter.",
            "A half-pound of fresh, never-frozen beef, crispy fried onions and American cheese, covered in sweet and smoky barbecue sauce all on a toasted bun. This stampede of flavor is the best barbecue hamburger in the west–or north or south or east for that matter.",
            "Three quarters of a pound of fresh, never-frozen beef, crispy fried onions and American cheese, covered in sweet and smoky barbecue sauce all on a toasted bun. This stampede of flavor is the best barbecue hamburger in the west–or north or south or east for that matter.",
            "A quarter-pound of fresh, never frozen beef, three strips of Applewood-smoked bacon, melted American cheese, crisp lettuce, onion, and pickle, all covered in our signature sweet, smoky, tangy sauce. A masterpiece signed with S’Awesome.",
            "A half-pound of fresh, never frozen beef, three strips of Applewood-smoked bacon, melted American cheese, crisp lettuce, onion, and pickle, all covered in our signature sweet, smoky, tangy sauce. A masterpiece signed with S’Awesome.",
            "Three quarters of a pound of fresh, never frozen beef, three strips of Applewood-smoked bacon, melted American cheese, crisp lettuce, onion, and pickle, all covered in our signature sweet, smoky, tangy sauce. A masterpiece signed with S’Awesome.",
            "A quarter-pound of fresh, never-frozen beef, rich, roasted mushrooms, peppercorn aioli, crispy fried onions and asiago cheese on a warm bun. Made to make mushroom lovers melt.",
            "A half-pound of fresh, never-frozen beef, rich, roasted mushrooms, peppercorn aioli, crispy fried onions and asiago cheese on a warm bun. Made to make mushroom lovers melt.",
            "Three quarters of a pound of fresh, never-frozen beef, rich, roasted mushrooms, peppercorn aioli, crispy fried onions and asiago cheese on a warm bun. Made to make mushroom lovers melt."
            ]
        
        static let price = [5.45, 7.01, 9.74, 8.96, 6.75, 2.27, 2.20, 1.81, 3.24, 1.55, 6.10, 7.66, 10.39, 6.75, 8.31, 11.04, 7.40, 8.96, 11.69]
    }
    
    struct Chcicken {
        
        static let title = "Chicken"
        
        static let header = ["Spicy Chicken Sandwich", "Homestyle Chicken Sandwich", "Asiago Ranch Chicken Club", "Grilled Chicken Sandwich", "Chicken Tenders", "Crispy Chicken BLT", "Crispy Chicken Sandwich", "Grilled Chicken Wrap", "Spicy Chicken Wrap", "4 PC Crispy Chicken Nuggets", "6 PC Crispy Chicken Nuggets", "10 PC Crispy Chicken Nuggets"]
        
        static let description = [
            "A juicy chicken breast marinated and breaded in our unique, fiery blend of peppers and spices to deliver more flavor inside and out, cooled down with crisp lettuce, tomato, and mayo. It’s the original spicy chicken sandwich, and the one you crave.",
            "A juicy, lightly-breaded chicken breast, crisp lettuce and tomato, and just enough mayo, all on a toasted bun. It’s extra comfy comfort food.",
            "A juicy, lightly breaded chicken breast taken over the top with thick Applewood smoked bacon, Asiago cheese, creamy ranch sauce, crisp lettuce, and tomato, all on a toasted bun. A club favorite that’s anything but boring.",
            "Herb-marinated grilled chicken breast topped with smoky honey mustard, crisp spring mix, and tomato, served on a warm toasted bun. See if it isn’t the best chicken sandwich you’ve ever had.",
            "Crispy breading outside, tender all-white meat inside. They’re everything a chicken tender should be except better. For something even better than better, dip them in a Side of S’Awesome,™ or any one of our six dipping sauces.",
            "Juicy white meat, lightly breaded and seasoned, topped with Applewood smoked bacon, crisp lettuce, tomato, cheese, and mayo. A classic taste, perfectly reinvented.",
            "Juicy white meat, lightly breaded and seasoned, topped with crisp lettuce, and mayo. More than delicious, and just the right size.",
            "Herb-marinated grilled chicken breast wrapped in a flour tortilla with crisp spring mix, shredded cheddar cheese, and smoky honey mustard. It’s a handful of flavor.",
            "Juicy chicken breast marinated and breaded in our unique, fiery blend of peppers and spices to deliver more flavor inside and out, wrapped in a tortilla with crisp lettuce, shredded cheddar cheese, and ranch sauce. It’s a whole handful of hot.",
            "100% white-meat chicken breaded to crispy perfection and served with your choice of 6 dipping sauces including Buttermilk Ranch, Creamy Sriracha, BBQ, Sweet & Sour, Honey Mustard, or Side of S’Awesome™. They’re trending in our restaurants and Twitter feed alike.",
            "100% white-meat chicken breaded to crispy perfection and served with your choice of 6 dipping sauces including Buttermilk Ranch, Creamy Sriracha, BBQ, Sweet & Sour, Honey Mustard, or Side of S’Awesome™. They’re trending in our restaurants and Twitter feed alike.",
            "100% white-meat chicken breaded to crispy perfection and served with your choice of 6 dipping sauces including Buttermilk Ranch, Creamy Sriracha, BBQ, Sweet & Sour, Honey Mustard, or Side of S’Awesome™. They’re trending in our restaurants and Twitter feed alike."
            ]
        
        static let price = [6.10, 6.10, 7.79, 6.10, 4.80, 2.72, 1.68, 2.59, 2.59, 1.55, 2.20, 4.80]
    }
 
    struct FreshMadeSalad {
        
        static let title = "Fresh-Made Salads"
        
        static let header = ["Taco Salad", "Apple Pecan Chicken Salad", "Spicy Chicken Caesar Salad", "Caesar Side Salad", "Garden Side Salad", "Harvest Chicken Salad", "Southwest Avocado Chicken Salad"]
        
        static let description = [
            "Made fresh daily with Wendy’s signature lettuce blend, shredded cheddar cheese, diced tomatoes, salsa, sour cream, tortilla chips, and our famous, hearty chili. A fresh twist on Taco Tuesday (or any other day for that matter). Nutrition and allergen information is inclusive of all ingredients in this salad.",
            "Made fresh daily with Wendy’s signature lettuce blend, crisp red and green apples, dried cranberries, roasted pecans, crumbled blue cheese, and grilled chicken breast hot off the grill, all topped with Marzetti® Simply Dressed® Pomegranate Vinaigrette. An unbeatable pick. Nutrition and allergen information is inclusive of all ingredients in this salad including two packets of dressing on the full-size salad and one packet on the half, which come on the side.",
            "Made fresh daily with hand-chopped romaine lettuce, grape tomatoes, a three cheese blend of Parmesan, Asiago, and Romano, croutons, and crispy, spicy chicken breast, all topped with creamy Marzetti® Simply Dressed® Caesar dressing. Hot is cool again. Nutrition and allergen information is inclusive of all ingredients in this salad including two packets of dressing for the full-size salad and one packet for the half, which come on the side.",
            "Made fresh daily with hand-chopped romaine lettuce, grape tomatoes, a three cheese blend of Parmesan, Asiago, and Romano, and croutons, all topped with a creamy Marzetti® Simply Dressed® Caesar dressing. Just the right size to satisfy.",
            "Made fresh daily with Wendy’s signature lettuce blend, cheddar cheese, tomatoes, and croutons, all topped with Marzetti® Simply Dressed® Ranch dressing. It’s the salad that goes with anything. Nutrition and allergen information is inclusive of all ingredients in this salad including one packet of dressing, which comes on the side.",
            "Made fresh daily with Wendy’s signature lettuce blend, diced red and green apples, dried cranberries, feta cheese, brown sugar walnuts, Applewood smoked bacon, and grilled chicken breast hot off the grill, all topped with Marzetti® Simply Dressed® Apple Cider Vinaigrette. It’s one bountiful Harvest. Nutrition and allergen information is inclusive of all ingredients in this salad including two packets of dressing on the full-size salad and one packet on the half, which come on the side.",
            "Made fresh daily with Wendy’s signature lettuce blend, crisp red and green apples, dried cranberries, roasted pecans, crumbled blue cheese, and grilled chicken breast hot off the grill, all topped with Marzetti® Simply Dressed® Pomegranate Vinaigrette. An unbeatable pick. Nutrition and allergen information is inclusive of all ingredients in this salad including two packets of dressing on the full-size salad and one packet on the half, which come on the side."
        ]
        
        static let price = [7.01, 7.01, 7.01, 2.33, 2.33, 7.14, 7.01]
    }
}
