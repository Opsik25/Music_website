-- №1 Название и продолжительность самого длительного трека.
-- Вариант 1
SELECT s.song_name, 
	   s.duration 
  FROM song AS s
 WHERE s.duration = (SELECT MAX(duration) 
					 FROM song);

-- Вариант 2
  SELECT s.song_name, 
  		 s.duration 
    FROM song AS s
   ORDER BY s.duration DESC
   LIMIT 1;

-- №2 Название треков, продолжительность которых не менее 3,5 минут.
SELECT s.song_name 
  FROM song AS s
 WHERE s.duration >= 210;

-- №3 Названия сборников, вышедших в период с 2018 по 2020 год включительно.
SELECT c.collection_name 
  FROM collection AS c
 WHERE c.release_year BETWEEN 2018 AND 2020;

-- №4 Исполнители, чьё имя состоит из одного слова.
SELECT m.musician_name 
  FROM musician AS m
 WHERE m.musician_name NOT LIKE '% %'; 

-- №5 Название треков, которые содержат слово «мой» или «my».
SELECT s.song_name 
  FROM song AS s
 WHERE s.song_name LIKE '% мой %' 
	OR song_name LIKE '% my %';

-- SELECT-запросы. Задание 3.

-- №1 Количество исполнителей в каждом жанре.
-- Вариант 1
  SELECT gm.genre_id, 
  		 COUNT(gm.musician_id) AS num_of_musicians 
    FROM genre_musician AS gm
   GROUP BY gm.genre_id
   ORDER BY gm.genre_id;

  -- Вариант 2
SELECT mg.genre_name,
	   COUNT(gm.musician_id) AS num_of_musicians
  FROM genre_musician AS gm
  JOIN music_genre AS mg 
  	ON gm.genre_id = mg.genre_id
 GROUP BY mg.genre_name, mg.genre_id
 ORDER BY mg.genre_id;
  

-- №2 Количество треков, вошедших в альбомы 2019–2020 годов.
SELECT COUNT(*) AS count_of_songs
  FROM song AS s
 WHERE s.album_id IN 
	   (SELECT a.album_id 
	  	  FROM album AS a 
	  	 WHERE a.release_year IN (2019, 2020));

-- №3 Средняя продолжительность треков по каждому альбому.
-- Вариант 1
  SELECT s.album_id, 
  		 AVG(s.duration) AS avg_duration 
	FROM song AS s
   GROUP BY s.album_id;
  
-- Вариант 2
  SELECT a.album_name, 
  		 AVG(s.duration) AS avg_duration
	FROM album AS a
	JOIN song AS s
	  ON a.album_id = s.album_id
   GROUP BY a.album_name
   ORDER BY a.album_name; 
  

-- №4 Все исполнители, которые не выпустили альбомы в 2020 году.
SELECT m.musician_name 
  FROM musician AS m
 WHERE m.musician_id NOT IN 
 	   (SELECT ma.musician_id 
 	      FROM musician_album AS ma
		 WHERE ma.album_id = (SELECT a.album_id 
								FROM album AS a 
							   WHERE a.release_year = 2020));

-- №5 Названия сборников, в которых присутствует конкретный исполнитель (выберите его сами).
SELECT c.collection_name 
  FROM collection AS c
 WHERE c.collection_id IN 
 	   (SELECT cs.collection_id 
 	      FROM collection_song AS cs
		 WHERE cs.song_id IN 
		 	   (SELECT s.song_id 
		 		  FROM song AS s
				  WHERE s.album_id IN 
				  		(SELECT ma.album_id 
				  		   FROM musician_album AS ma
						  WHERE ma.musician_id = (SELECT m.musician_id 
						  							FROM musician AS m
												   WHERE m.musician_name = 'Madonna'))));

-- SELECT-запросы. Задание 4.

-- №1 Названия альбомов, в которых присутствуют исполнители более чем одного жанра.
SELECT a.album_name 
  FROM album AS a
 WHERE a.album_id IN 
 	   (SELECT ma.album_id 
 	      FROM musician_album AS ma
		 WHERE ma.musician_id IN 
		 	   (SELECT gm.musician_id 
		 	      FROM genre_musician AS gm
			     GROUP BY gm.musician_id
				HAVING COUNT(gm.musician_id) > 1));

-- №2 Наименования треков, которые не входят в сборники.
SELECT s.song_name 
  FROM song AS s
 WHERE s.song_id NOT IN 
	   (SELECT cs.song_id 
	  	  FROM collection_song AS cs);

--№3 Исполнитель или исполнители, написавшие самый короткий по продолжительности трек, — теоретически таких треков может быть несколько.
SELECT m.musician_name 
  FROM musician AS m
 WHERE m.musician_id IN 
 	   (SELECT ma.musician_id 
 	   	  FROM musician_album AS ma
		 WHERE ma.album_id IN 
		 	   (SELECT a.album_id 
		 	   	  FROM album AS a
				 WHERE a.album_id IN 
				 	   (SELECT s1.album_id 
				 	      FROM song AS s1
						 WHERE s1.duration IN 
							   (SELECT MIN(s2.duration) 
							  	  FROM song AS s2))));

--№4 Названия альбомов, содержащих наименьшее количество треков.
SELECT a.album_name 
  FROM album AS a
 WHERE a.album_id IN 
 	   (SELECT album_id 
 	      FROM (SELECT s1.album_id, COUNT(s1.song_name) AS song_count 
 	      		  FROM song AS s1
			     GROUP BY s1.album_id
				HAVING COUNT(s1.song_name) = (SELECT MIN(song_count) 
											    FROM (SELECT s2.album_id, COUNT(s2.song_name) AS song_count 
											    		FROM song AS s2
													   GROUP BY s2.album_id))))
ORDER BY a.album_id;