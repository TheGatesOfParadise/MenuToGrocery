# MenuToGrocery

It uses Edamam Recipe API to get recipes based on search criteria.
Add recipe to meal plan and/or favorite recipe list
Everytime a recipe is added to/deleted from a meal plan, its corresponding ingredients are added to/removed from grocery list. 
The 3 list - meal plan, favorite recipes and grocery list are persisted in Firestore so that next time user comes back previously saved data is retrieved.
The above 3 list can be emptied.  By emptying meal plan, grocery list is emptied too.  This is a one directional impact.  Emptying favorite recipes or grocery list does not have impact to other list.
After user seledct at least one recipe to the meal plan, user can consult with chatGPT to comment on the meal plan.

#Search screen#
     - search without any filter
     - search with fitler(s)
     - if non-empty search result comes back
     - if empty search result comes back
     - for each recipe, user can add/remove it to meal plan/favorite recipes
     - by clicking on individual recipe, ....

#Meal plan screen#

#Favorite recipe screen#

#Grocery list screen#
     
#Single recipe screen#

#ChatGPT half sheet#




==========================================================================================

#############
ToDo#############

7. check all ! 
18. get rid of error -- AppCheck failed: 'The operation couldn’t be completed. (com.apple.devicecheck.error error 1.)'
20. change a new firebase accout for 30 day no authentication?、



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

for scar:
- adviceview to full-sheet
- 

