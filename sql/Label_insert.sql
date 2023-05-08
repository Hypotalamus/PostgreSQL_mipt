-- create some genres
INSERT INTO Genre (name)
VALUES  ('Grunge'),
        ('Punk Rock'),
        ('Hip-Hop')
;

-- create some specialities
INSERT INTO Speciality (name)
VALUES  ('Singer'),
        ('Guitarist'),
        ('Bassist'),
        ('Drummer')
;

-- create some artists
WITH ins (name, genre, date_start, date_end) AS
( VALUES
    ( 'Nirvana', 'Grunge', '1987-01-01'::date, '1994-04-08'::date),
    ( 'The Offspring', 'Punk Rock', '1984-01-01'::date, NULL),
    ( 'Ultramagnetic MCs', 'Hip-Hop', '1984-01-01'::date, NULL)
)  
INSERT INTO Artist
   (name, genre_id, date_start, date_end) 
SELECT 
    ins.name, Genre.genre_id, ins.date_start, ins.date_end
FROM 
  Genre JOIN ins
    ON ins.genre = Genre.name;

-- create some listeners
INSERT INTO Listener (login, password, name)
VALUES  ('Kurt', '123kc', 'Kurt Cobain'), -- Nirvana start
        ('Krist', '123kn', 'Krist Novoselic'),
        ('Dave', '123dg', 'Dave Grohl'), -- Nirvana end
        ('Dexter', '123dh', 'Dexter Holland'), -- The Offspring start
        ('Noodles', '123n', 'Noodles'),
        ('Todd', '123tm', 'Todd Morse'), -- The Offspring end
        ('Kool', '123kk', 'Kool Keith'), -- Ultramagnetic MCs start
        ('Ced', '123cg', 'Ced-Gee'),
        ('TR', '123trl', 'TR Love'),
        ('Moe', '123ml', 'Moe Love'),
        ('Jaycee', '123j', 'Jaycee'), -- Ultramagnetic MCs end   
        ('MJ', '123mj', 'Michael Jordin'), -- Ordinary user
        ('Barnes', '123cb', 'Chris Barnes')
;

-- create some musicians
WITH ins (speciality_name, listener_login, is_busy) AS
( VALUES
    ('Singer', 'Kurt', 'f'::boolean), -- Nirvana start
    ('Guitarist', 'Kurt', 'f'::boolean),
    ('Bassist', 'Krist', 'f'::boolean),
    ('Drummer', 'Dave', 'f'::boolean), -- Nirvana end
    ('Singer', 'Dexter', 'f'::boolean), -- The Offspring start
    ('Guitarist', 'Dexter', 'f'::boolean),
    ('Guitarist', 'Noodles', 'f'::boolean),
    ('Bassist', 'Todd', 'f'::boolean), -- The Offspring end
    ('Singer', 'Kool', 'f'::boolean), -- Ultramagnetic MCs start
    ('Singer', 'Ced', 'f'::boolean),
    ('Singer', 'TR', 'f'::boolean),
    ('Singer', 'Moe', 'f'::boolean),
    ('Singer', 'Jaycee', 'f'::boolean) -- Ultramagnetic MCs end  
)  
INSERT INTO Musician
   (speciality_id, listener_id, is_busy) 
SELECT 
    Speciality.speciality_id, Listener.listener_id, ins.is_busy
FROM Speciality
JOIN ins
    ON Speciality.name = ins.speciality_name
JOIN Listener
    ON Listener.login = ins.listener_login;

-- connect musician to artist Musician_Artist
WITH ins (listener_login, artist_name, speciality_name) AS 
( VALUES
    ('Kurt', 'Nirvana', 'Singer'),
    ('Kurt', 'Nirvana', 'Guitarist'),
    ('Krist', 'Nirvana', 'Bassist'),
    ('Dave', 'Nirvana', 'Drummer'),
    ('Dexter', 'The Offspring', 'Singer'),
    ('Dexter', 'The Offspring', 'Guitarist'),
    ('Noodles', 'The Offspring', 'Guitarist'),
    ('Todd', 'The Offspring', 'Bassist'),
    ('Kool', 'Ultramagnetic MCs', 'Singer'),
    ('Ced', 'Ultramagnetic MCs', 'Singer'),
    ('TR', 'Ultramagnetic MCs', 'Singer'),
    ('Moe', 'Ultramagnetic MCs', 'Singer'),
    ('Jaycee', 'Ultramagnetic MCs', 'Singer')
)
INSERT INTO Musician_Artist 
    (musician_id, artist_id)
SELECT
    Musician.musician_id, Artist.artist_id
FROM Musician
JOIN Listener
    ON Musician.listener_id = Listener.listener_id
JOIN Speciality
    ON Musician.speciality_id = Speciality.speciality_id
JOIN ins
    ON Listener.login = ins.listener_login AND Speciality.name = ins.speciality_name
JOIN Artist
    ON Artist.name = ins.artist_name;

-- Add some The Offspring tracks
INSERT INTO Track (name, link, artist_id, release_date)
VALUES  ('Walla Walla', 'https://download.me/1', 
            (SELECT artist_id FROM Artist WHERE name = 'The Offspring'), '1998-11-17'),
        ('Mota', 'https://download.me/2',
            (SELECT artist_id FROM Artist WHERE name = 'The Offspring'), '1997-02-04'),
        ('Staring at the Sun', 'https://download.me/3',
            (SELECT artist_id FROM Artist WHERE name = 'The Offspring'), '1998-11-17'),
        ('Americana', 'https://download.me/4',
            (SELECT artist_id FROM Artist WHERE name = 'The Offspring'), '1998-11-17')
;

-- Add some Nirvana tracks
INSERT INTO Track (name, link, artist_id, release_date)
VALUES  ('In Bloom', 'https://download.me/5', 
            (SELECT artist_id FROM Artist WHERE name = 'Nirvana'), '1991-09-24'),
        ('Breed', 'https://download.me/6',
            (SELECT artist_id FROM Artist WHERE name = 'Nirvana'), '1991-09-24'),
        ('Stay Away', 'https://download.me/7',
            (SELECT artist_id FROM Artist WHERE name = 'Nirvana'), '1991-09-24')
;

-- Add The Offspring concert
-- Add organizer
INSERT INTO Organizer (listener_id)
VALUES ((SELECT listener_id FROM Listener WHERE login = 'Dexter'));

-- Create concert
WITH ins (name, address, date_start, capacity, ticket_price, organizer_login) AS
( VALUES
    ( 'The Offspring tour 2023', 'Adrenaline Stadium, Moscow', '2023-05-31'::date, 
        1000, '500.00'::money, 'Dexter') 
)  
INSERT INTO Concert
   (name, address, date_start, capacity, ticket_price, organizer_id) 
SELECT 
    ins.name, ins.address, ins.date_start, ins.capacity, ins.ticket_price, Organizer.organizer_id
FROM Organizer
JOIN Listener
    ON Organizer.listener_id = Listener.listener_id
JOIN ins
    ON Listener.login = ins.organizer_login;

-- Buy tickets on concert
WITH ins (listener, concert) AS
( VALUES
    ('Dexter', 'The Offspring tour 2023'),
    ('Noodles', 'The Offspring tour 2023'),
    ('Todd', 'The Offspring tour 2023'),
    ('Kool', 'The Offspring tour 2023'),
    ('Barnes', 'The Offspring tour 2023'),
    ('MJ', 'The Offspring tour 2023'),
    ('Dave', 'The Offspring tour 2023')      
)  
INSERT INTO Ticket
   (listener_id, concert_id) 
SELECT 
    Listener.listener_id, Concert.concert_id
FROM Listener
JOIN ins
    ON Listener.login = ins.listener
JOIN Concert
    ON Concert.name = ins.concert;

-- Create playlist for Dexter
INSERT INTO Playlist (name, listener_id) 
VALUES
    ('Default', (SELECT listener_id FROM Listener WHERE login = 'Dexter'));

WITH ins (playlist, track) AS
( VALUES
    ('Default', 'Mota'),
    ('Default', 'Breed'),
    ('Default', 'Americana'),
    ('Default', 'Stay Away')      
)  
INSERT INTO Track_Playlist
   (playlist_id, track_id) 
SELECT 
    Playlist.playlist_id, Track.track_id
FROM Playlist
JOIN ins
    ON Playlist.name = ins.playlist
JOIN Track
    ON Track.name = ins.track;