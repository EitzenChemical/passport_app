-- Создаем базу данных
CREATE DATABASE PassportRequestDB;
GO

-- Используем созданную базу данных
USE PassportRequestDB;
GO

-- Создание таблицы пользователей
CREATE TABLE Users (
    Id INT IDENTITY(1,1) PRIMARY KEY, -- Идентификатор пользователя
    Email NVARCHAR(255) NOT NULL, -- Электронная почта
    Password NVARCHAR(255) NOT NULL, -- Пароль (обычно храним в зашифрованном виде)
    CONSTRAINT UC_Email UNIQUE (Email) -- Ограничение уникальности для Email
);
GO

-- Создание таблицы заявок
CREATE TABLE Requests (
    Id INT IDENTITY(1,1) PRIMARY KEY, -- Идентификатор заявки
    UserId INT NOT NULL, -- Идентификатор пользователя, которому принадлежит заявка
    Type NVARCHAR(100) NOT NULL, -- Тип услуги (например, "Замена паспорта")
    Status NVARCHAR(50) NOT NULL, -- Статус заявки (например, "На рассмотрении", "Одобрена", "Отклонена")
    Documents NVARCHAR(MAX), -- Строка для хранения информации о загруженных документах (путь к файлу или данные)
    CreatedAt DATETIME DEFAULT GETDATE(), -- Дата создания заявки
    UpdatedAt DATETIME DEFAULT GETDATE(), -- Дата последнего обновления заявки
    FOREIGN KEY (UserId) REFERENCES Users(Id) -- Внешний ключ на таблицу Users
);
GO