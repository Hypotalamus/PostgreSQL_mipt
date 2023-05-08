-- Show all tracks of The Offspring older then 1998-01-01
SELECT * FROM Track
WHERE artist_id = (SELECT artist_id FROM artist WHERE name = 'The Offspring') AND
    release_date > '1998-01-01';

-- Count tracks grouping by bands in playlist called 'Default' from user 'Dexter'
SELECT Artist.name, COUNT(*) FROM Track_Playlist
    INNER JOIN Playlist
    ON Track_Playlist.playlist_id = Playlist.playlist_id
    INNER JOIN Track
    ON Track_Playlist.track_id = Track.track_id
    INNER JOIN Artist
    ON Artist.artist_id = Track.artist_id
    INNER JOIN Listener
    ON Listener.listener_id = Playlist.listener_id
    WHERE Playlist.name = 'Default' AND Listener.login = 'Dexter'
    GROUP BY (Artist.name);  

-- Show all members of band Nirvana
SELECT Listener.login, Listener.name, Speciality.name FROM Listener,
    (SELECT Musician.musician_id, speciality_id, listener_id FROM Musician_Artist
    INNER JOIN Artist
    ON Musician_artist.artist_id = Artist.artist_id
    INNER JOIN Musician
    ON Musician.musician_id = Musician_Artist.musician_id
	WHERE name = 'Nirvana') AS musicians
INNER JOIN Speciality
ON Speciality.speciality_id = musicians.speciality_id
WHERE Listener.listener_id = musicians.listener_id;

-- Count all tickets on The Offspring tour 2023 exclude The Offspring members
SELECT COUNT(ticket_id) FROM Ticket
WHERE concert_id = (SELECT concert_id FROM Concert WHERE name = 'The Offspring tour 2023') AND
    listener_id NOT IN (
        SELECT DISTINCT listener_id FROM Musician_Artist
            INNER JOIN Artist
            ON Musician_artist.artist_id = Artist.artist_id
            INNER JOIN Musician
            ON Musician.musician_id = Musician_Artist.musician_id
            WHERE name = 'The Offspring'         
    );


