CREATE TABLE IF NOT EXISTS Artists (
	ID INTEGER PRIMARY KEY AUTOINCREMENT,
  	ArtistID VARCHAR(16) GENERATED ALWAYS AS ('ART-' || printf('%05d', id)) STORED,
  	ArtistName VARCHAR(255) NOT NULL,
  	ArtistNameSinhala VARCHAR(255), -- Sinhala script name
  	UNIQUE(ArtistName)
);

CREATE TABLE IF NOT EXISTS Songs (
	ID INTEGER PRIMARY KEY AUTOINCREMENT,
	SongID VARCHAR(64) GENERATED ALWAYS AS ('SNG-' || printf('%07d', ID)) STORED,
    SongName VARCHAR(255) NOT NULL,
    SongNameSinhala VARCHAR(255),
    ArtistID VARCHAR(16) NOT NULL,        -- FK references Albums(ID)
    Duration INT, 
    ReleaseYear INT,
    Composer VARCHAR(255),
    Lyricist VARCHAR(255),
    ViewCount INT DEFAULT 0,
    FOREIGN KEY (ArtistID) REFERENCES Artists(ArtistID)
);

CREATE TABLE IF NOT EXISTS Lyrics (
    ID INTEGER PRIMARY KEY AUTOINCREMENT,
    LyricID VARCHAR(64) GENERATED ALWAYS AS ('LYR-' || printf('%07d', ID)) STORED,
    SongID INTEGER UNIQUE NOT NULL,                 -- FK references Songs(SongID)
    LyricContent TEXT,                              -- Sinhala lyrics
    LyricContentSinhala TEXT,                     -- Optional romanized version
    FOREIGN KEY (SongID) REFERENCES Songs(SongID)
);

CREATE TABLE IF NOT EXISTS ArtistSongs (
    ID INTEGER PRIMARY KEY AUTOINCREMENT,
    ArtistID VARCHAR(16) NOT NULL,
    SongID VARCHAR(64) NOT NULL,
    IsPrimary BOOLEAN DEFAULT 0,
    FOREIGN KEY (ArtistID) REFERENCES Artists(ArtistID),
    FOREIGN KEY (SongID) REFERENCES Songs(SongID),
    UNIQUE(ArtistID, SongID)
);

-- Foreign Key Indexes (Critical for join performance)
--CREATE INDEX idx_songs_artistid ON Songs(ArtistID);
--CREATE INDEX idx_lyrics_songid ON Lyrics(SongID);
--
-- Search and Filter Indexes
--CREATE INDEX idx_songs_songname ON Songs(SongName);
--CREATE INDEX idx_artists_artistname ON Artists(ArtistName); -- May be redundant due to UNIQUE constraint
--CREATE INDEX idx_songs_releaseyear ON Songs(ReleaseYear);
--CREATE INDEX idx_songs_viewcount ON Songs(ViewCount);

-- For queries filtering by artist and year
--CREATE INDEX idx_songs_artist_year ON Songs(ArtistID, ReleaseYear);
--
---- For queries ordering songs by popularity within artist
--CREATE INDEX idx_songs_artist_views ON Songs(ArtistID, ViewCount DESC);
--
---- For search queries combining name and year
--CREATE INDEX idx_songs_name_year ON Songs(SongName, ReleaseYear);
--
---- For full-text search on song names (SQLite FTS example)
--CREATE VIRTUAL TABLE songs_fts USING fts5(SongName, SongNameSinhala, content='Songs');
--
---- For lyrics search
--CREATE VIRTUAL TABLE lyrics_fts USING fts5(LyricContent, LyricContentSinhala, content='Lyrics');