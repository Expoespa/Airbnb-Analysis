-- 1. ¿Cuáles son los tipos de propiedades más comunes en cada ciudad?
WITH 
PropertyCount AS(
	SELECT 
        city,
        property_type,
        count(*) as count
	FROM airbnb
	GROUP BY city,property_type
),

MaxProperty AS(
	SELECT 
        city,MAX(count) as max_count
	FROM PropertyCount
	GROUP BY city
)
SELECT 
    pc.city,
    pc.property_type,
     pc.count
FROM PropertyCount pc
JOIN MaxProperty mp
ON mp.max_count = pc.count AND  pc.city = mp.city

-- 2. ¿Cuál es el precio promedio de los alojamientos en cada barrio?

SELECT 
    neighbourhood,
    CAST( AVG(EXP(log_price))as decimal(10,2)) as Avg_property_Price
FROM airbnb
GROUP BY 1

-- 3. ¿Cuántas propiedades tienen una política de cancelación flexible en cada ciudad?

SELECT 
    city,
    count(*) as Number
FROM airbnb
WHERE cancellation_policy = 'flexible'
GROUP BY city

-- 4. ¿Cuál es el número promedio de camas por tipo de habitación?

SELECT 
    DISTINCT room_type,
     AVG(beds) as Beds_Avg
FROM airbnb
GROUP BY 1

-- 5. ¿Cuántas propiedades tienen más de 3 dormitorios en cada ciudad?

SELECT 
    city, 
    count(*)
FROM airbnb
WHERE bedrooms < 3
GROUP BY 1

-- 6. ¿Cuál es el precio promedio por tipo de propiedad?

SELECT 
    distinct property_type,
    CAST(AVG(EXP(log_price)) as decimal(10,2))
FROM airbnb
GROUP BY 1
ORDER BY 2 DESC

-- 7. ¿Cuántas propiedades instantáneamente reservables hay en cada barrio?

SELECT 
    neighbourhood,
    count(*) as Number
FROM airbnb
WHERE instant_bookable = 't'
GROUP BY 1

-- 8. ¿Cuál es el número promedio de reseñas por tipo de propiedad?

SELECT 
    property_type,
    CAST(avg(number_of_reviews) as decimal (10,2))
FROM airbnb
GROUP BY 1

-- 9. ¿Cuántas propiedades tienen una calificación de reseñas superior a 90?

SELECT 
    count(*) as Number
FROM airbnb
WHERE review_scores_rating > 90

-- 10. ¿Cuántas propiedades tienen aire acondicionado y están ubicadas en Nueva York?

SELECT 
    count(*) as Number
FROM airbnb
WHERE city = 'NYC'
AND amenities LIKE '%condi%'

-- 11. ¿Cuál es la distribución de la tasa de respuesta del anfitrión en San Francisco?

SELECT 
    host_response_rate, 
    COUNT(*) AS count
FROM airbnb
WHERE city = 'SF'
GROUP BY host_response_rate
ORDER BY host_response_rate DESC;

-- 12. ¿Cuántas propiedades tienen una tarifa de limpieza y están ubicadas en Washington D.C.?

SELECT
	count(*) as Number
FROM airbnb
WHERE city = 'DC'
AND cleaning_fee = True

-- 13. ¿Cuál es el precio promedio de los alojamientos en cada ciudad?

SELECT city,
	CAST(AVG(EXP(log_price))as decimal(10,2)) as AVG_Price
FROM airbnb
GROUP BY 1

-- 14. ¿Cuál es la propiedad con más reseñas en cada barrio?

WITH MaxReviews AS(
	SELECT 
		neighbourhood,
		MAX(number_of_reviews) as max_reviews
	FROM airbnb
	GROUP BY 1
)
SELECT
	a.id,
	a.name,
	a.neighbourhood,
	a.number_of_reviews
FROM airbnb a
JOIN MaxReviews mr
ON a.neighbourhood = mr.neighbourhood
AND a.number_of_reviews = mr.max_reviews
ORDER BY 3 asc


-- 15. ¿Cuántas propiedades tienen más de 2 baños y están ubicadas en San Francisco?

SELECT 
    count(*) as Number
FROM airbnb
WHERE city = 'SF'
AND bathrooms > 2

-- 16. ¿Cuál es la calificación promedio de las propiedades con más de 5 reseñas en cada ciudad?

SELECT
	city,
	AVG(review_scores_rating)
FROM airbnb
WHERE number_of_reviews > 5
GROUP BY 1

-- 17. ¿Cuántas propiedades tienen una cama de tipo "Real Bed" en cada barrio?

SELECT 
	neighbourhood,
	count(*)
FROM airbnb
WHERE description LIKE '%Real Bed%'
GROUP BY 1

-- 18. ¿Cuál es el precio promedio de los alojamientos instantáneamente reservables?

SELECT 
	AVG(EXP(log_price))
FROM airbnb
WHERE instant_bookable = 't'

-- 19. ¿Cuántas propiedades tienen una descripción que contiene la palabra "luxury" y están en Nueva York?

SELECT
	count(*) as Number
FROM airbnb
WHERE city = 'NYC'
AND description LIKE '%luxury%'

-- 20. ¿Cuál es el número promedio de personas que pueden ser acomodadas en propiedades en San Francisco?

SELECT
	avg(accommodates)
FROM airbnb
WHERE city = 'SF'