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
  JOIN album AS a
    ON s.album_id = a.album_id 
 WHERE a.release_year IN (2019, 2020);

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
          JOIN album AS a
            ON ma.album_id = a.album_id 
         WHERE a.release_year = 2020);

-- №5 Названия сборников, в которых присутствует конкретный исполнитель (выберите его сами).												  
SELECT DISTINCT c.collection_name 
  FROM collection AS c
  JOIN collection_song AS cs
    ON c.collection_id = cs.collection_id
  JOIN song AS s
    ON cs.song_id = s.song_id
  JOIN album AS a
    ON s.album_id = a.album_id
  JOIN musician_album AS ma
    ON a.album_id = ma.album_id
  JOIN musician AS m
    ON ma.musician_id = m.musician_id
 WHERE m.musician_name = 'Madonna';

-- SELECT-запросы. Задание 4.

-- №1 Названия альбомов, в которых присутствуют исполнители более чем одного жанра.		
SELECT a.album_name
  FROM album AS a
  JOIN musician_album AS ma
    ON a.album_id = ma.album_id
  JOIN genre_musician AS gm
    ON ma.musician_id = gm.musician_id
 GROUP BY a.album_name
HAVING COUNT(gm.musician_id) > 1;

-- №2 Наименования треков, которые не входят в сборники.	  	 
SELECT s.song_name
  FROM song AS s
  LEFT JOIN collection_song AS cs
    ON s.song_id = cs.song_id
 WHERE cs.collection_id IS NULL;

--№3 Исполнитель или исполнители, написавшие самый короткий по продолжительности трек, — теоретически таких треков может быть несколько.							  	 
SELECT m.musician_name 
  FROM musician AS m
  JOIN musician_album AS ma
    ON m.musician_id = ma.musician_id 
  JOIN album AS a
    ON ma.album_id = a.album_id 
  JOIN song AS s1
    ON a.album_id = s1.album_id 
 WHERE s1.duration IN
       (SELECT MIN(s2.duration) 
          FROM song AS s2);

--№4 Названия альбомов, содержащих наименьшее количество треков.
SELECT a.album_name
  FROM album AS a
  JOIN song AS s
    ON a.album_id = s.album_id
 GROUP BY a.album_name
HAVING COUNT(a.album_name) = (SELECT COUNT(*) AS song_count 
                                        FROM song AS s
                                       GROUP BY s.album_id
                                       ORDER BY COUNT(*)
                                       LIMIT 1);
