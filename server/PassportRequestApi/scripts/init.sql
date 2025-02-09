CREATE DATABASE PassportRequestDB;

USE PassportRequestDB;

-- Таблица пользователей
CREATE TABLE Users (
    UserId INT IDENTITY PRIMARY KEY,
    FullName NVARCHAR(255) NOT NULL,
    DateOfBirth DATE NOT NULL,
    PassportSeries INT NULL,
    PassportNumber INT NULL,
    PasswordHash NVARCHAR(255) NOT NULL
);

-- Таблица заявок
CREATE TABLE Applications (
    ApplicationId INT IDENTITY PRIMARY KEY,
    UserId INT NOT NULL FOREIGN KEY REFERENCES Users(UserId),
    DateSubmitted DATETIME NOT NULL DEFAULT GETDATE(),
    Reason NVARCHAR(255) NOT NULL,
    Status NVARCHAR(50) CHECK (Status IN ('На рассмотрении', 'Одобрена', 'Отклонена')) NOT NULL DEFAULT 'На рассмотрении',
    DocumentPhoto VARBINARY(MAX) NULL
);