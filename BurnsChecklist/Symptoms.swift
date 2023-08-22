//
//  Symptoms.swift
//  BurnsChecklist
//
//  Created by robert on 8/21/23.
//

import Foundation

let symptoms: [(String, [(number: Int, question: String)])] = [
    ("Thoughts and Feelings", [
        (1, "Feeling sad or down in the dumps"),
        (2, "Feeling unhappy or blue"),
        (3, "Crying spells or tearfulness"),
        (4, "Feeling discouraged"),
        (5, "Feeling hopeless"),
        (6, "Low self-esteem"),
        (7, "Feeling worthless or inadequate"),
        (8, "Guilt or shame"),
        (9, "Criticizing yourself or blaming others"),
        (10, "Difficulty making decisions"),
    ]),
    ("Activities and Personal Relationships", [
        (11, "Loss of interest in family, friends or colleagues"),
        (12, "Loneliness"),
        (13, "Spending less time with family or friends"),
        (14, "Loss of motivation"),
        (15, "Loss of interest in work or other activities"),
        (16, "Avoiding work or other activities"),
        (17, "Loss of pleasure or satisfaction in life"),
    ]),
    ("Physical Symptoms", [
        (18, "Feeling tired"),
        (19, "Difficulty sleeping or sleeping too much"),
        (20, "Decreased or increased appetite"),
        (21, "Loss of interest in sex"),
        (22, "Worrying about your health"),
    ]),
    ("Suicidal Urges", [
        (23, "Do you have any suicidal thoughts?"),
        (24, "Would you like to end your life?"),
        (25, "Do you have a plan for harming yourself?"),
    ])
]
    
let levelOfDepression: [(icon: String, description: String, min: Int, max: Int)] = [
    ("😀", "No Depression", 0, 5),
    ("😐", "Normal but unhappy", 6, 10),
    ("😕", "Mild depression", 11, 25),
    ("☹️", "Moderate depression", 26, 50),
    ("😧", "Severe depression", 51, 75),
    ("😱", "Extreme depression", 76, 100),
]

let encouragements = [
    "It's OK to not feel OK.",
    "It's Okay to feel this way.",
    "You're not alone.",
    "You can move forward in the face of your depression.",
    "There is hope, even when your brain tells you there isn’t.\n          --John Green",
    "One day you will tell your story of how you overcame what you went through, and it will be someone else’s survival guide.\n          --Brené Brown",
    "It doesn’t matter how slow you go as long as you don’t stop.\n          --Confucius",
    "Life is like riding a bicycle. To keep your balance, you must keep moving.\n          --Albert Einstein",
    "The secret of health for both mind and body is not to mourn for the past, not to worry about the future, but to live the present moment wisely and earnestly.\n          --Buddha",
    "When one door closes another door opens; but we so often look so long and so regretfully upon the closed door, that we do not see the ones which open for us.\n          --Alexander Graham Bell",
    "It is never too late to be what you might have been.\n          --George Eliot",
    "And if today all you did was hold yourself together, i’m proud of you.",
    "You matter.",
    "You’re still you.",
    "You’re strong enough to get through this.",
    "This too shall pass.",
    "There is hope.",
    "It's OK to be human.",
    "May the strength of the past reflect in your future.",
    "It’s hard to see this right now, but it’s only temporary… Things will change. You won’t feel this way forever. Look to that day.",
    "There are ways to get through this difficult time.",
    "Depression is a real health issue that can be treated. You may be helped by talking to a doctor or counselor about how you’re feeling.",
    "It seems like you’re really struggling. Talking to a doctor or counselor about what you’re going through may be very helpful to you.",
]
