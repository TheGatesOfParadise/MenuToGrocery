# CS590 Final App - MenuToGrocery

This app uses Edamam Recipe API to get recipes based on search criteria.
Users can add recipes to their meal plan or favorites.
Everytime a recipe is added to/deleted from a meal plan, its corresponding ingredients are added to/removed from grocery list. 
The meal plan, favorite recipes, and grocery list are persisted in Firestore so that next time user comes back, previously saved data is retrieved.
The aforementioned lists can alos be emptied. By emptying the meal plan, the grocery list is emptied too.  This is a one directional impact. Emptying favorite recipes or grocery list does not impact other lists.
After the user selects at least one recipe to the meal plan, users can consult with chatGPT to comment on the meal plan.

#Search screen#

The search screen allows users to search for recipes from the Edamam Recipe Database. They can search with or without the cuisine and meal type filter. If the search is non-empty, a list of recipes come back. The recipes can be added to and removed from the meal plan and favorite recipes.

A recipe can be expanded by clicking on a recipe, that leads to Single recipe screen.

#Meal plan screen#

The meal plan screen holds the recipes users add to their meal plan. They are not categorized and ordered by recently added; users can remove the recipe once they are done. Individual recipes can be clicked on and viewed. The ChatGPT Advice button sits to the left of the title.
When a recipe is added to the meal plan, its ingredients are automatically added to the grocery list. When a recipe is removed, its ingredients are also removed from the grocery list.

#Favorite recipe screen#

The favorite recipes screen holds the recipes users like the most. It is sorted by cuisine type and can be emptied. The favorites screen do not affect the meal plan or the grocery list. Individual recipes can be clicked on and viewed.

#Grocery list screen#
The grocery list screen are all the ingredients from the user's meal plan that is automatically loaded. The list is sorted by type and can be checked off. Users can press on an ingredient to see what recipe it belongs to.
     
#Single recipe screen#

The single recipe screen contains a picture of the dish, cuisine, calories, prep time, and ingredients. At the top, users can add the recipe to their meal plan or their favorites. The instructions button at the bottom leads users to an external link. 

#ChatGPT advice half-sheet#

This half-sheet can be accessed from the meal plan screen by pressing on the sticky. Users can input their sex and age, then click on the button to receive information about their meal based on their information by ChatGPT. Advice will only be generated if at least one recipe is in the meal plan. 
