#Create a simple array with square brackets
#standardSQL
CREATE OR REPLACE TABLE `array_struct_demo.array_restaurant_cuisine` AS (
SELECT "Cafe Pacific" AS name, "North York" AS location, ["European", "Casual", "Wine bar"] AS cuisine_array
UNION ALL
SELECT "Boston Pizza" AS name, "Toronto" AS location, ["Italian", "Pizza", "Fast-food"] AS cuisine_array
UNION ALL
SELECT "Spice on the Streets" AS name, "New York" AS location, ["Indian", "Casual", "Street-food"] AS cuisine_array
UNION ALL
SELECT "Sushi Bar" AS name, "LA" AS location, ["Japanese", "Sushi", "Casual"] AS cuisine_array);


# Break open an array with UNNEST
#standardSQL
SELECT name, location, cuisine
FROM `array_struct_demo.array_restaurant_cuisine`, UNNEST(cuisine_array) AS cuisine;



# Count the elements in an array with ARRAY_LENGTH
#standardSQL
SELECT name, ARRAY_LENGTH(cuisine_array) AS number_of_label
FROM `array_struct_demo.array_restaurant_cuisine`;

SELECT name,cuisine_array
FROM `array_struct_demo.array_restaurant_cuisine`
# Filter only restaurants contain "Casual" labels
WHERE "Casual" IN UNNEST(cuisine_array);



# Create a struct 


# Create a simple struct
#standardSQL
CREATE OR REPLACE TABLE `array_struct_demo.struct_restaurant_cuisine` AS (
SELECT "Cafe Pacific" AS name, "North York" AS location,
STRUCT(["European", "Casual", "Wine bar"] AS cuisine_array, "100 $" AS price_range, False AS has_delivery) AS basic_info
UNION ALL
SELECT "Boston Pizza" AS name, "Toronto" AS location,
STRUCT(["Italian", "Pizza", "Fast-food"] AS cuisine_array, "50 $" AS price_range, True AS has_delivery) AS basic_info
UNION ALL
SELECT "Spice on the Streets" AS name, "New York" AS location,
STRUCT(["Indian", "Casual"] AS cuisine_array, "50 $" AS price_range, True AS has_delivery) AS basic_info
UNION ALL
SELECT "Sushi Bar" AS name, "LA" AS location,
STRUCT(["Japanese", "Sushi", "Casual"] AS cuisine_array, "150 $" AS price_range, False AS has_delivery) AS basic_info);

# Filter casual restaurants with delivery service
WITH casual_delivery AS (
    SELECT 
        name, 
        location, 
        basic_info.price_range AS price_range, 
        cuisine
    FROM `array_struct_demo.struct_restaurant_cuisine`, 
    UNNEST(basic_info.cuisine_array) AS cuisine
    WHERE basic_info.has_delivery = TRUE
    AND "Casual" IN UNNEST(basic_info.cuisine_array)
)


#Regroup cuisine into array for final query result
SELECT 
  name, 
  location, 
  price_range, 
  ARRAY_AGG(cuisine) AS cuisine
FROM casual_delivery
GROUP BY name, location, price_range;





