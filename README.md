Friday tasks for SCARLETT:
1. finish this readme manual, each sentence might not be complete,  read and update it. 
2. based on this readme manual,  design script for video demo,  you need to cover all these functions with concrete test data so that your video steps are reproducible. 

==================================================================

# MenuToGrocery User Manual #

It uses Edamam Recipe API to get recipes based on search criteria.
Add recipe to meal plan and/or favorite recipe list
Everytime a recipe is added to/deleted from a meal plan, its corresponding ingredients are added to/removed from grocery list. 
The 3 list - meal plan, favorite recipes and grocery list are persisted in Firestore so that next time user comes back previously saved data is retrieved.
The above 3 list can be emptied.  By emptying meal plan, grocery list is emptied too.  This is a one directional impact.  Emptying favorite recipes or grocery list does not have impact to other list.
After user seledct at least one recipe to the meal plan, user can consult with chatGPT to comment on the meal plan.

#Search screen#
     - search without any filter
     - search with fitler(s)
     - if non-empty search result comes back, show a list of recipes
     - if empty search result comes back, a message is shown to notify users 
     - for each recipe, user can add/remove it to meal plan/favorite recipes
     - by clicking on individual recipe, goes to Single recipe screen

#Meal plan screen#
    - a list of recipes are put here as they are added. 
    - click on a recipe, goes to Single recipe screen
    - delete a recipe from meal plan
    - empty meal plan
    - consult chatGPT on meal plan

#Favorite recipe screen#
    - a list of recipes grouped by cuisine type
    - click on a recipe, goes to Single recipe screen
    - delete a recipe from favorite recipe list
    - empty favorite reicpe list

#Grocery list screen#
    - the grocery item is entered through meal plan,  when a recipe is added to meal plan, its ingredients are added to grocery list
    - it's not allowed to enter a new grocery item on this screen -- TODO: see if this function can be added
    - user can check/uncheck a grocery item to mark it as bought/not-bought
    - it's not allowed to delete grocery items on this screen -- TODO: see if this function can be added
    - empty grocery list  (if the meal plan is emptied, grocery list is emptied too)
    - by clickin on a grocery item, it goes to Single recipe screen.  This reminds users which recipe is associated with the grocery item
     
#Single recipe screen#
    - A detailed recipe screen is shown:  calroies, cuisine type, ingrdients...
    - Use can add/remove the recipe from meal plan or favorite recipe list
    - this screen is presented as full sheet invoked from all 4 screens above

#ChatGPT half sheet#
    - This screen is presented as half sheet from meal plan screen
    - It allows users to choose age and sex, then consult chatGPT on the meal plan




====================================================================================================

#############
ToDo#############

7. check all ! 
18. get rid of error -- AppCheck failed: 'The operation couldn’t be completed. (com.apple.devicecheck.error error 1.)'
20. change a new firebase accout for 30 day no authentication?、
21. hide keyboard when focus is not on textfield in search screen
22. check toggle function in grocery screen
23. add/remove a grocery item



#############
Done#############
1. search provide cuisine type choice, meal type
2. save recipe to meal plan and favorite list
0. provide save/unsave, love/unlove functions 
1. design meal plan structure and favorite list structure
3. generate grocery list
8. favorite/meal plan button -> on/off
9. grocery list can't get from mealplan, has to add one by one
10. mealplan recipe -> favorite,  Favorite recipe -> mealplan --- no need, do it in recipeView
11. delete/add grocery item, individual checkbox  -- check GamifiedToDo/ToDoDetails/ToDoDetailsView.swift, line 206
15. add drawer for instruction
4. save to firebase
6. added launch screen
12. instructions for recipe
17. chatgpt
21. remove a recipe, also remove its grocery
5. use NSCache to store image   -- no need
13. simplify recipe class  -- no need
14. update firebase by recipe/small item  -- done
19. next time image is not loading  -- no need to fix, since teacher is not going to run it
21. remove recipe has bugs
22. check grocery item -- tomato, 1st recipe, remove one item -- order changed. 
16. add loading wheel -- delete favorites, chatgpt response is slow


Firecard reference: https://www.kodeco.com/11609977-getting-started-with-cloud-firestore-and-swiftui#toc-anchor-003

