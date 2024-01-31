CREATE TABLE music_genre (
	PRIMARY KEY (genre_id),
	genre_id   SERIAL 	       NOT NULL,
	genre_name VARCHAR(255) UNIQUE NOT NULL
);
CREATE TABLE musician (
	PRIMARY KEY (musician_id),
	musician_id   SERIAL 	   NOT NULL,
	musician_name VARCHAR(255) NOT NULL
);
CREATE TABLE genre_musician (
	PRIMARY KEY (genre_id, musician_id),
	genre_id    INT NOT NULL REFERENCES music_genre(genre_id),
	musician_id INT NOT NULL REFERENCES musician(musician_id)	
);
CREATE TABLE album (
	PRIMARY KEY (album_id),
	album_id     SERIAL 	  NOT NULL,
	album_name   VARCHAR(255) NOT NULL,
	release_year SMALLINT 	  NOT NULL, 
		     CONSTRAINT album_release_year_range
		     CHECK (release_year BETWEEN 1900 AND 2100)
);
CREATE TABLE musician_album (
	PRIMARY KEY (musician_id, album_id),
	musician_id INT NOT NULL REFERENCES musician(musician_id),
	album_id    INT NOT NULL REFERENCES album(album_id)			
);
CREATE TABLE song (
	PRIMARY KEY (song_id),
	song_id   SERIAL       NOT NULL,
	song_name VARCHAR(255) NOT NULL,
	duration  INTEGER      NOT NULL,
		  CONSTRAINT song_duration_check
		  CHECK (duration > 0),
	album_id  INT 	       NOT NULL REFERENCES album(album_id) ON DELETE CASCADE
);
CREATE TABLE collection (
	PRIMARY KEY (collection_id),
	collection_id   SERIAL 	     NOT NULL,
	collection_name VARCHAR(255) NOT NULL,
	release_year 	SMALLINT     NOT NULL,
			CONSTRAINT collection_release_year_range
			CHECK (release_year BETWEEN 1900 AND 2100)
);
CREATE TABLE collection_song (
	PRIMARY KEY (collection_id, song_id),
	collection_id INT NOT NULL REFERENCES collection(collection_id),
	song_id       INT NOT NULL REFERENCES song(song_id)	  
);
