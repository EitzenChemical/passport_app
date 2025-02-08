-- ������� ���� ������
CREATE DATABASE PassportRequestDB;
GO

-- ���������� ��������� ���� ������
USE PassportRequestDB;
GO

-- �������� ������� �������������
CREATE TABLE Users (
    Id INT IDENTITY(1,1) PRIMARY KEY, -- ������������� ������������
    Email NVARCHAR(255) NOT NULL, -- ����������� �����
    Password NVARCHAR(255) NOT NULL, -- ������ (������ ������ � ������������� ����)
    CONSTRAINT UC_Email UNIQUE (Email) -- ����������� ������������ ��� Email
);
GO

-- �������� ������� ������
CREATE TABLE Requests (
    Id INT IDENTITY(1,1) PRIMARY KEY, -- ������������� ������
    UserId INT NOT NULL, -- ������������� ������������, �������� ����������� ������
    Type NVARCHAR(100) NOT NULL, -- ��� ������ (��������, "������ ��������")
    Status NVARCHAR(50) NOT NULL, -- ������ ������ (��������, "�� ������������", "��������", "���������")
    Documents NVARCHAR(MAX), -- ������ ��� �������� ���������� � ����������� ���������� (���� � ����� ��� ������)
    CreatedAt DATETIME DEFAULT GETDATE(), -- ���� �������� ������
    UpdatedAt DATETIME DEFAULT GETDATE(), -- ���� ���������� ���������� ������
    FOREIGN KEY (UserId) REFERENCES Users(Id) -- ������� ���� �� ������� Users
);
GO