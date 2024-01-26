CREATE TABLE music_genre (
	genre_id SERIAL PRIMARY KEY,
	genre_name VARCHAR(255) UNIQUE NOT NULL
);
CREATE TABLE musician (
	musician_id SERIAL PRIMARY KEY,
	musician_name VARCHAR(255) NOT NULL
);
CREATE TABLE genre_musician (
	genre_id INT REFERENCES music_genre(genre_id),
	musician_id INT REFERENCES musician(musician_id),
	CONSTRAINT genre_musician_id PRIMARY KEY(genre_id, musician_id)
);
CREATE TABLE album (
	album_id SERIAL PRIMARY KEY,
	album_name VARCHAR(255) NOT NULL,
	release_year SMALLINT NOT NULL CHECK
		(release_year>1900)
);
CREATE TABLE musician_album (
	musician_id INT REFERENCES musician(musician_id),
	album_id INT REFERENCES album(album_id),
	CONSTRAINT musician_album_id PRIMARY KEY(musician_id, album_id)
);
CREATE TABLE song (
	song_id SERIAL PRIMARY KEY,
	song_name VARCHAR(255) NOT NULL,
	duration INTEGER NOT NULL,
	album_id INT NOT NULL REFERENCES album(album_id) ON DELETE CASCADE
);
CREATE TABLE collection (
	collection_id SERIAL PRIMARY KEY,
	collection_name VARCHAR(255) NOT NULL,
	release_year SMALLINT NOT NULL CHECK
		(release_year>1900)
);
CREATE TABLE collection_song (
	collection_id INT REFERENCES collection(collection_id),
	song_id INT REFERENCES song(song_id),
	CONSTRAINT collection_song_id PRIMARY KEY(collection_id, song_id)
);
