-- tables
-- Table: Artist
CREATE TABLE IF NOT EXISTS Artist (
    artist_id BIGSERIAL,
    name varchar(50)  NOT NULL,
    genre_id int  NOT NULL,
    date_start date  NULL,
    date_end date  NULL,
    about text  NULL,
    CONSTRAINT Artist_pk PRIMARY KEY (artist_id)
);

-- Table: Concert
CREATE TABLE IF NOT EXISTS Concert (
    concert_id BIGSERIAL,
    name varchar(50)  NOT NULL UNIQUE,
    address varchar(255)  NOT NULL,
    date_start timestamp  NOT NULL,
    capacity int  NOT NULL,
    ticket_price money  NOT NULL,
    organizer_id int  NOT NULL,
    playlist_id int  NULL,
    about text  NULL,
    date_end timestamp  NULL,
    CONSTRAINT Concert_pk PRIMARY KEY (concert_id)
);

-- Table: Concert_Artist
CREATE TABLE IF NOT EXISTS Concert_Artist (
    concert_id int  NOT NULL,
    artist_id int  NOT NULL,
    CONSTRAINT Concert_Artist_pk PRIMARY KEY (concert_id,artist_id)
);

-- Table: Genre
CREATE TABLE IF NOT EXISTS Genre (
    genre_id BIGSERIAL,
    name varchar(50)  NOT NULL UNIQUE,
    about text  NULL,
    CONSTRAINT Genre_pk PRIMARY KEY (genre_id)
);

-- Table: Listener
CREATE TABLE IF NOT EXISTS Listener (
    listener_id BIGSERIAL,
    login varchar(50)  NOT NULL UNIQUE,
    password varchar(50)  NOT NULL,
    name varchar(50)  NULL,
    birthday date  NULL,
    address varchar(255)  NULL,
    website varchar(255)  NULL,
    about text  NULL,
    CONSTRAINT Listener_pk PRIMARY KEY (listener_id)
);

-- Table: Musician
CREATE TABLE IF NOT EXISTS Musician (
    musician_id BIGSERIAL,
    is_busy boolean  NOT NULL,
    speciality_id int  NOT NULL,
    listener_id int  NOT NULL,
    about text  NULL,
    CONSTRAINT Musician_pk PRIMARY KEY (musician_id)
);

-- Table: Musician_Artist
CREATE TABLE IF NOT EXISTS Musician_Artist (
    musician_id int  NOT NULL,
    artist_id int  NOT NULL,
    CONSTRAINT Musician_Artist_pk PRIMARY KEY (musician_id,artist_id)
);

-- Table: Organizer
CREATE TABLE IF NOT EXISTS Organizer (
    organizer_id BIGSERIAL,
    listener_id int  NOT NULL,
    about text  NULL,
    CONSTRAINT Organizer_pk PRIMARY KEY (organizer_id)
);

-- Table: Playlist
CREATE TABLE IF NOT EXISTS Playlist (
    playlist_id BIGSERIAL,
    name varchar(50)  NOT NULL,
    listener_id int  NOT NULL,
    about text  NULL,
    CONSTRAINT Playlist_pk PRIMARY KEY (playlist_id)
);

-- Table: Speciality
CREATE TABLE IF NOT EXISTS Speciality (
    speciality_id BIGSERIAL,
    name varchar(50)  NOT NULL UNIQUE,
    about text  NULL,
    CONSTRAINT Speciality_pk PRIMARY KEY (speciality_id)
);

-- Table: Ticket
CREATE TABLE IF NOT EXISTS Ticket (
    ticket_id BIGSERIAL,
    listener_id int  NOT NULL,
    concert_id int  NOT NULL,
    CONSTRAINT Listener_Concert_pk PRIMARY KEY (ticket_id)
);

-- Table: Track
CREATE TABLE IF NOT EXISTS Track (
    track_id BIGSERIAL,
    name varchar(50)  NOT NULL,
    link varchar(255)  NOT NULL,
    artist_id int  NOT NULL,
    release_date date  NULL,
    duration time  NULL,
    CONSTRAINT Track_pk PRIMARY KEY (track_id)
);

-- Table: Track_Playlist
CREATE TABLE IF NOT EXISTS Track_Playlist (
    id BIGSERIAL,
    track_id int  NOT NULL,
    playlist_id int  NOT NULL,
    CONSTRAINT Track_Playlist_pk PRIMARY KEY (id)
);

-- foreign keys
-- Reference: Artist_Genre (table: Artist)
ALTER TABLE Artist ADD CONSTRAINT Artist_Genre
    FOREIGN KEY (genre_id)
    REFERENCES Genre (genre_id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: Concert_Artist_Artist (table: Concert_Artist)
ALTER TABLE Concert_Artist ADD CONSTRAINT Concert_Artist_Artist
    FOREIGN KEY (artist_id)
    REFERENCES Artist (artist_id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: Concert_Artist_Concert (table: Concert_Artist)
ALTER TABLE Concert_Artist ADD CONSTRAINT Concert_Artist_Concert
    FOREIGN KEY (concert_id)
    REFERENCES Concert (concert_id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: Concert_Organizer (table: Concert)
ALTER TABLE Concert ADD CONSTRAINT Concert_Organizer
    FOREIGN KEY (organizer_id)
    REFERENCES Organizer (organizer_id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: Concert_Playlist (table: Concert)
ALTER TABLE Concert ADD CONSTRAINT Concert_Playlist
    FOREIGN KEY (playlist_id)
    REFERENCES Playlist (playlist_id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: Listener_Concert_Concert (table: Ticket)
ALTER TABLE Ticket ADD CONSTRAINT Listener_Concert_Concert
    FOREIGN KEY (concert_id)
    REFERENCES Concert (concert_id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: Listener_Concert_Listener (table: Ticket)
ALTER TABLE Ticket ADD CONSTRAINT Listener_Concert_Listener
    FOREIGN KEY (listener_id)
    REFERENCES Listener (listener_id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: Musician_Artist_Artist (table: Musician_Artist)
ALTER TABLE Musician_Artist ADD CONSTRAINT Musician_Artist_Artist
    FOREIGN KEY (artist_id)
    REFERENCES Artist (artist_id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: Musician_Artist_Musician (table: Musician_Artist)
ALTER TABLE Musician_Artist ADD CONSTRAINT Musician_Artist_Musician
    FOREIGN KEY (musician_id)
    REFERENCES Musician (musician_id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: Musician_Listener (table: Musician)
ALTER TABLE Musician ADD CONSTRAINT Musician_Listener
    FOREIGN KEY (listener_id)
    REFERENCES Listener (listener_id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: Musician_Speciality (table: Musician)
ALTER TABLE Musician ADD CONSTRAINT Musician_Speciality
    FOREIGN KEY (speciality_id)
    REFERENCES Speciality (speciality_id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: Organizer_Listener (table: Organizer)
ALTER TABLE Organizer ADD CONSTRAINT Organizer_Listener
    FOREIGN KEY (listener_id)
    REFERENCES Listener (listener_id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: Playlist_Listener (table: Playlist)
ALTER TABLE Playlist ADD CONSTRAINT Playlist_Listener
    FOREIGN KEY (listener_id)
    REFERENCES Listener (listener_id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: Track_Artist (table: Track)
ALTER TABLE Track ADD CONSTRAINT Track_Artist
    FOREIGN KEY (artist_id)
    REFERENCES Artist (artist_id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: Track_Playlist_Playlist (table: Track_Playlist)
ALTER TABLE Track_Playlist ADD CONSTRAINT Track_Playlist_Playlist
    FOREIGN KEY (playlist_id)
    REFERENCES Playlist (playlist_id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: Track_Playlist_Track (table: Track_Playlist)
ALTER TABLE Track_Playlist ADD CONSTRAINT Track_Playlist_Track
    FOREIGN KEY (track_id)
    REFERENCES Track (track_id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;
