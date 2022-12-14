USE [master]
GO
/****** Object:  Database [Libraries]    Script Date: 08/12/2022 16:30:45 ******/
CREATE DATABASE [Libraries]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Libraries', FILENAME = N'I:\tools\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\DATA\Libraries.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'Libraries_log', FILENAME = N'I:\tools\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\DATA\Libraries_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [Libraries] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Libraries].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Libraries] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Libraries] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Libraries] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Libraries] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Libraries] SET ARITHABORT OFF 
GO
ALTER DATABASE [Libraries] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [Libraries] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Libraries] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Libraries] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Libraries] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Libraries] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Libraries] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Libraries] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Libraries] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Libraries] SET  DISABLE_BROKER 
GO
ALTER DATABASE [Libraries] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Libraries] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Libraries] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [Libraries] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [Libraries] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Libraries] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [Libraries] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [Libraries] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [Libraries] SET  MULTI_USER 
GO
ALTER DATABASE [Libraries] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [Libraries] SET DB_CHAINING OFF 
GO
ALTER DATABASE [Libraries] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [Libraries] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [Libraries] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [Libraries] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [Libraries] SET QUERY_STORE = OFF
GO
USE [Libraries]
GO
/****** Object:  User [programer]    Script Date: 08/12/2022 16:30:45 ******/
CREATE USER [programer] FOR LOGIN [programer] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  UserDefinedFunction [dbo].[showLibraryAddress]    Script Date: 08/12/2022 16:30:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[showLibraryAddress]
(
	@library_name NVARCHAR(255)
)
RETURNS NVARCHAR(255)
AS
BEGIN
	DECLARE @ADDRESS NVARCHAR(255), @location_id INT
	SELECT @location_id = location_id FROM libraries WHERE library_name = @library_name 
	SELECT @ADDRESS = [address] FROM locations WHERE location_id = @location_id
	RETURN @ADDRESS
END
GO
/****** Object:  UserDefinedFunction [dbo].[titlesPublished]    Script Date: 08/12/2022 16:30:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[titlesPublished]
(
	@publisher_name NVARCHAR(255)
)
RETURNS INT
AS
BEGIN
	DECLARE @number_of_titles INT, @publisher_id INT
	SELECT @publisher_id = publisher_id FROM publishers WHERE publisher_name = @publisher_name
	SELECT @number_of_titles = COUNT(title_id) FROM titles WHERE publisher_id = @publisher_id
	RETURN @number_of_titles
END
GO
/****** Object:  Table [dbo].[titles]    Script Date: 08/12/2022 16:30:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[titles](
	[title_id] [int] IDENTITY(1,1) NOT NULL,
	[title_name] [nvarchar](255) NOT NULL,
	[page_count] [int] NOT NULL,
	[category_id] [int] NOT NULL,
	[publisher_id] [int] NOT NULL,
	[date_released] [date] NOT NULL,
	[date_inserted] [datetime] NOT NULL,
	[date_updated] [datetime] NULL,
	[date_deleted] [datetime] NULL,
 CONSTRAINT [PK_titles] PRIMARY KEY CLUSTERED 
(
	[title_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[showTitlesOfCategory]    Script Date: 08/12/2022 16:30:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[showTitlesOfCategory]
(
	@category_id INT
)
RETURNS 
TABLE 
AS
	RETURN (
		SELECT * FROM titles
		WHERE category_id = @category_id
	)
GO
/****** Object:  Table [dbo].[authors]    Script Date: 08/12/2022 16:30:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[authors](
	[author_id] [int] IDENTITY(1,1) NOT NULL,
	[first_name] [nvarchar](50) NOT NULL,
	[last_name] [nvarchar](50) NOT NULL,
	[date_inserted] [datetime] NOT NULL,
	[date_updated] [datetime] NULL,
	[date_deleted] [datetime] NULL,
 CONSTRAINT [PK_authors] PRIMARY KEY CLUSTERED 
(
	[author_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[authors_data]    Script Date: 08/12/2022 16:30:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[authors_data]
AS
SELECT        author_id, first_name, last_name
FROM            dbo.authors
WHERE        (date_deleted IS NULL)
GO
/****** Object:  Table [dbo].[books]    Script Date: 08/12/2022 16:30:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[books](
	[book_id] [int] IDENTITY(1,1) NOT NULL,
	[title_id] [int] NOT NULL,
	[library_id] [int] NOT NULL,
	[loaned] [bit] NOT NULL,
	[date_inserted] [datetime] NOT NULL,
	[date_updated] [datetime] NULL,
	[date_deleted] [datetime] NULL,
 CONSTRAINT [PK_books] PRIMARY KEY CLUSTERED 
(
	[book_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[books_data]    Script Date: 08/12/2022 16:30:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[books_data]
AS
SELECT        book_id, title_id, library_id, loaned
FROM            dbo.books
WHERE        (date_deleted IS NULL)
GO
/****** Object:  Table [dbo].[categories]    Script Date: 08/12/2022 16:30:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[categories](
	[category_id] [int] IDENTITY(1,1) NOT NULL,
	[category_name] [nvarchar](255) NOT NULL,
	[date_inserted] [datetime] NOT NULL,
	[date_updated] [datetime] NULL,
	[date_deleted] [datetime] NULL,
 CONSTRAINT [PK_categories] PRIMARY KEY CLUSTERED 
(
	[category_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[categories_data]    Script Date: 08/12/2022 16:30:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[categories_data]
AS
SELECT        category_id, category_name
FROM            dbo.categories
WHERE        (date_deleted IS NULL)
GO
/****** Object:  Table [dbo].[loans]    Script Date: 08/12/2022 16:30:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[loans](
	[loan_id] [int] IDENTITY(1,1) NOT NULL,
	[user_id] [int] NOT NULL,
	[book_id] [int] NOT NULL,
	[date_loaned] [datetime] NOT NULL,
	[date_due] [datetime] NOT NULL,
	[date_returned] [datetime] NULL,
	[date_inserted] [datetime] NOT NULL,
	[date_updated] [datetime] NULL,
	[date_deleted] [datetime] NULL,
 CONSTRAINT [PK_loans] PRIMARY KEY CLUSTERED 
(
	[loan_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[loans_data]    Script Date: 08/12/2022 16:30:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[loans_data]
AS
SELECT        date_returned, date_loaned, date_due, book_id, user_id, loan_id
FROM            dbo.loans
WHERE        (date_deleted IS NULL)
GO
/****** Object:  Table [dbo].[locations]    Script Date: 08/12/2022 16:30:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[locations](
	[location_id] [int] IDENTITY(1,1) NOT NULL,
	[town_id] [int] NOT NULL,
	[address] [nvarchar](255) NOT NULL,
	[date_inserted] [datetime] NOT NULL,
	[date_updated] [datetime] NULL,
	[date_deleted] [datetime] NULL,
 CONSTRAINT [PK_locations] PRIMARY KEY CLUSTERED 
(
	[location_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[locations_data]    Script Date: 08/12/2022 16:30:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[locations_data]
AS
SELECT        address, town_id, location_id
FROM            dbo.locations
WHERE        (date_deleted IS NULL)
GO
/****** Object:  View [dbo].[titles_data]    Script Date: 08/12/2022 16:30:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[titles_data]
AS
SELECT        category_id, page_count, title_name, title_id, publisher_id, date_released
FROM            dbo.titles
WHERE        (date_deleted IS NULL)
GO
/****** Object:  Table [dbo].[titles_authors]    Script Date: 08/12/2022 16:30:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[titles_authors](
	[title_author_id] [int] NOT NULL,
	[author_id] [int] NOT NULL,
	[title_id] [int] NOT NULL,
	[position] [tinyint] NOT NULL,
	[date_inserted] [datetime] NOT NULL,
	[date_updated] [datetime] NULL,
	[date_deleted] [datetime] NULL,
 CONSTRAINT [PK_titles_authors_1] PRIMARY KEY CLUSTERED 
(
	[title_author_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[titles_authors_data]    Script Date: 08/12/2022 16:30:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[titles_authors_data]
AS
SELECT        title_author_id, author_id, title_id, position
FROM            dbo.titles_authors
WHERE        (date_deleted IS NULL)
GO
/****** Object:  Table [dbo].[towns]    Script Date: 08/12/2022 16:30:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[towns](
	[town_id] [int] IDENTITY(1,1) NOT NULL,
	[town_name] [nvarchar](50) NOT NULL,
	[date_inserted] [datetime] NOT NULL,
	[date_updated] [datetime] NULL,
	[date_deleted] [datetime] NULL,
 CONSTRAINT [PK_towns] PRIMARY KEY CLUSTERED 
(
	[town_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[towns_data]    Script Date: 08/12/2022 16:30:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[towns_data]
AS
SELECT        town_name, town_id
FROM            dbo.towns
WHERE        (date_deleted IS NULL)
GO
/****** Object:  Table [dbo].[users]    Script Date: 08/12/2022 16:30:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[users](
	[user_id] [int] IDENTITY(1,1) NOT NULL,
	[first_name] [nvarchar](50) NOT NULL,
	[last_name] [nvarchar](50) NOT NULL,
	[birthday] [date] NOT NULL,
	[date_inserted] [datetime] NOT NULL,
	[date_updated] [datetime] NULL,
	[date_deleted] [datetime] NULL,
 CONSTRAINT [PK_users] PRIMARY KEY CLUSTERED 
(
	[user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[users_data]    Script Date: 08/12/2022 16:30:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[users_data]
AS
SELECT        last_name, first_name, user_id, birthday
FROM            dbo.users
WHERE        (date_deleted IS NULL)
GO
/****** Object:  View [dbo].[author_more_than_one_title]    Script Date: 08/12/2022 16:30:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[author_more_than_one_title]
AS
SELECT        a.author_id, a.first_name, a.last_name
FROM            dbo.authors_data AS a INNER JOIN
                         dbo.titles_authors_data AS ta ON a.author_id = ta.author_id
GROUP BY a.author_id, a.first_name, a.last_name
HAVING        (COUNT(ta.title_id) > 1)
GO
/****** Object:  Table [dbo].[publishers]    Script Date: 08/12/2022 16:30:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[publishers](
	[publisher_id] [int] IDENTITY(1,1) NOT NULL,
	[location_id] [int] NOT NULL,
	[publisher_name] [nvarchar](255) NOT NULL,
	[date_inserted] [datetime] NOT NULL,
	[date_updated] [datetime] NULL,
	[date_deleted] [datetime] NULL,
 CONSTRAINT [PK_publishers] PRIMARY KEY CLUSTERED 
(
	[publisher_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[publishers_data]    Script Date: 08/12/2022 16:30:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[publishers_data]
AS
SELECT        publisher_id, publisher_name, location_id
FROM            dbo.publishers
WHERE        (date_deleted IS NULL)
GO
/****** Object:  View [dbo].[publishers_from_belgrade]    Script Date: 08/12/2022 16:30:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[publishers_from_belgrade]
AS
SELECT        p.publisher_id, p.publisher_name, t.town_name, l.address
FROM            dbo.publishers_data AS p INNER JOIN
                         dbo.locations_data AS l ON p.location_id = l.location_id INNER JOIN
                         dbo.towns_data AS t ON l.town_id = t.town_id
WHERE        (t.town_name = N'Belgrade')
GO
/****** Object:  Table [dbo].[libraries]    Script Date: 08/12/2022 16:30:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[libraries](
	[library_id] [int] IDENTITY(1,1) NOT NULL,
	[location_id] [int] NOT NULL,
	[library_name] [nvarchar](255) NOT NULL,
	[date_inserted] [datetime] NOT NULL,
	[date_updated] [datetime] NULL,
	[date_deleted] [datetime] NULL,
 CONSTRAINT [PK_libraries] PRIMARY KEY CLUSTERED 
(
	[library_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[libraries_data]    Script Date: 08/12/2022 16:30:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[libraries_data]
AS
SELECT        library_id, location_id, library_name
FROM            dbo.libraries
WHERE        (date_deleted IS NULL)
GO
/****** Object:  View [dbo].[libraries_in_belgrade]    Script Date: 08/12/2022 16:30:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[libraries_in_belgrade]
AS
SELECT        dbo.libraries_data.library_id, dbo.libraries_data.library_name, dbo.towns_data.town_name, dbo.locations_data.address
FROM            dbo.libraries_data INNER JOIN
                         dbo.locations_data ON dbo.libraries_data.location_id = dbo.locations_data.location_id INNER JOIN
                         dbo.towns_data ON dbo.locations_data.town_id = dbo.towns_data.town_id
WHERE        (dbo.towns_data.town_name = N'Belgrade')
GO
/****** Object:  View [dbo].[titles_without_copies]    Script Date: 08/12/2022 16:30:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[titles_without_copies]
AS
SELECT        title_id, title_name, category_id, publisher_id, page_count, date_released
FROM            dbo.titles_data
WHERE        (title_id NOT IN
                             (SELECT        title_id
                               FROM            dbo.books_data))
GO
/****** Object:  View [dbo].[books_on_loan]    Script Date: 08/12/2022 16:30:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[books_on_loan]
AS
SELECT        dbo.users_data.first_name + N' ' + dbo.users_data.last_name AS [User], dbo.titles_data.title_name AS Title, dbo.books_data.book_id AS [Book ID]
FROM            dbo.loans_data INNER JOIN
                         dbo.books_data ON dbo.loans_data.book_id = dbo.books_data.book_id INNER JOIN
                         dbo.titles_data ON dbo.books_data.title_id = dbo.titles_data.title_id INNER JOIN
                         dbo.users_data ON dbo.loans_data.user_id = dbo.users_data.user_id
WHERE        (dbo.books_data.loaned = 1)
GO
/****** Object:  Table [dbo].[activities]    Script Date: 08/12/2022 16:30:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[activities](
	[activity_id] [int] IDENTITY(1,1) NOT NULL,
	[user] [nvarchar](255) NOT NULL,
	[date] [datetime] NOT NULL,
	[action] [nvarchar](255) NOT NULL,
	[data_deleted] [nvarchar](max) NULL,
	[data_inserted] [nvarchar](max) NULL,
 CONSTRAINT [PK_Activities] PRIMARY KEY CLUSTERED 
(
	[activity_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[activities] ADD  CONSTRAINT [DF_Activities_user]  DEFAULT (user_name()) FOR [user]
GO
ALTER TABLE [dbo].[activities] ADD  CONSTRAINT [DF_Activities_date]  DEFAULT (getdate()) FOR [date]
GO
ALTER TABLE [dbo].[authors] ADD  CONSTRAINT [DF_authors_date_inserted]  DEFAULT (getdate()) FOR [date_inserted]
GO
ALTER TABLE [dbo].[books] ADD  CONSTRAINT [DF_books_loaned]  DEFAULT ((0)) FOR [loaned]
GO
ALTER TABLE [dbo].[books] ADD  CONSTRAINT [DF_books_date_inserted]  DEFAULT (getdate()) FOR [date_inserted]
GO
ALTER TABLE [dbo].[categories] ADD  CONSTRAINT [DF_categories_date_inserted]  DEFAULT (getdate()) FOR [date_inserted]
GO
ALTER TABLE [dbo].[libraries] ADD  CONSTRAINT [DF_libraries_date_inserted]  DEFAULT (getdate()) FOR [date_inserted]
GO
ALTER TABLE [dbo].[loans] ADD  CONSTRAINT [DF_loans_date_due]  DEFAULT (getdate()+(20)) FOR [date_due]
GO
ALTER TABLE [dbo].[loans] ADD  CONSTRAINT [DF_loans_date_inserted]  DEFAULT (getdate()) FOR [date_inserted]
GO
ALTER TABLE [dbo].[locations] ADD  CONSTRAINT [DF_locations_date_inserted]  DEFAULT (getdate()) FOR [date_inserted]
GO
ALTER TABLE [dbo].[publishers] ADD  CONSTRAINT [DF_publishers_date_inserted]  DEFAULT (getdate()) FOR [date_inserted]
GO
ALTER TABLE [dbo].[titles] ADD  CONSTRAINT [DF_titles_date_inserted]  DEFAULT (getdate()) FOR [date_inserted]
GO
ALTER TABLE [dbo].[titles_authors] ADD  CONSTRAINT [DF_titles_authors_date_inserted]  DEFAULT (getdate()) FOR [date_inserted]
GO
ALTER TABLE [dbo].[towns] ADD  CONSTRAINT [DF_towns_date_inserted]  DEFAULT (getdate()) FOR [date_inserted]
GO
ALTER TABLE [dbo].[users] ADD  CONSTRAINT [DF_users_date_inserted]  DEFAULT (getdate()) FOR [date_inserted]
GO
ALTER TABLE [dbo].[books]  WITH CHECK ADD  CONSTRAINT [FK_books_libraries] FOREIGN KEY([library_id])
REFERENCES [dbo].[libraries] ([library_id])
GO
ALTER TABLE [dbo].[books] CHECK CONSTRAINT [FK_books_libraries]
GO
ALTER TABLE [dbo].[books]  WITH CHECK ADD  CONSTRAINT [FK_books_titles] FOREIGN KEY([title_id])
REFERENCES [dbo].[titles] ([title_id])
GO
ALTER TABLE [dbo].[books] CHECK CONSTRAINT [FK_books_titles]
GO
ALTER TABLE [dbo].[libraries]  WITH CHECK ADD  CONSTRAINT [FK_libraries_locations] FOREIGN KEY([location_id])
REFERENCES [dbo].[locations] ([location_id])
GO
ALTER TABLE [dbo].[libraries] CHECK CONSTRAINT [FK_libraries_locations]
GO
ALTER TABLE [dbo].[loans]  WITH CHECK ADD  CONSTRAINT [FK_loans_books] FOREIGN KEY([book_id])
REFERENCES [dbo].[books] ([book_id])
GO
ALTER TABLE [dbo].[loans] CHECK CONSTRAINT [FK_loans_books]
GO
ALTER TABLE [dbo].[loans]  WITH CHECK ADD  CONSTRAINT [FK_loans_users] FOREIGN KEY([user_id])
REFERENCES [dbo].[users] ([user_id])
GO
ALTER TABLE [dbo].[loans] CHECK CONSTRAINT [FK_loans_users]
GO
ALTER TABLE [dbo].[locations]  WITH CHECK ADD  CONSTRAINT [FK_locations_towns] FOREIGN KEY([town_id])
REFERENCES [dbo].[towns] ([town_id])
GO
ALTER TABLE [dbo].[locations] CHECK CONSTRAINT [FK_locations_towns]
GO
ALTER TABLE [dbo].[publishers]  WITH CHECK ADD  CONSTRAINT [FK_publishers_locations] FOREIGN KEY([location_id])
REFERENCES [dbo].[locations] ([location_id])
GO
ALTER TABLE [dbo].[publishers] CHECK CONSTRAINT [FK_publishers_locations]
GO
ALTER TABLE [dbo].[titles]  WITH CHECK ADD  CONSTRAINT [FK_titles_categories] FOREIGN KEY([category_id])
REFERENCES [dbo].[categories] ([category_id])
GO
ALTER TABLE [dbo].[titles] CHECK CONSTRAINT [FK_titles_categories]
GO
ALTER TABLE [dbo].[titles]  WITH CHECK ADD  CONSTRAINT [FK_titles_publishers] FOREIGN KEY([publisher_id])
REFERENCES [dbo].[publishers] ([publisher_id])
GO
ALTER TABLE [dbo].[titles] CHECK CONSTRAINT [FK_titles_publishers]
GO
ALTER TABLE [dbo].[titles_authors]  WITH CHECK ADD  CONSTRAINT [FK_authors] FOREIGN KEY([author_id])
REFERENCES [dbo].[authors] ([author_id])
GO
ALTER TABLE [dbo].[titles_authors] CHECK CONSTRAINT [FK_authors]
GO
ALTER TABLE [dbo].[titles_authors]  WITH CHECK ADD  CONSTRAINT [FK_titles_authors_titles] FOREIGN KEY([title_id])
REFERENCES [dbo].[titles] ([title_id])
GO
ALTER TABLE [dbo].[titles_authors] CHECK CONSTRAINT [FK_titles_authors_titles]
GO
/****** Object:  StoredProcedure [dbo].[delete_author]    Script Date: 08/12/2022 16:30:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[delete_author] @id int
AS
BEGIN
	DELETE FROM authors
	WHERE author_id = @id
END
GO
/****** Object:  StoredProcedure [dbo].[delete_book]    Script Date: 08/12/2022 16:30:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[delete_book] @id int
AS
BEGIN
	DELETE FROM books
	WHERE book_id = @id
END
GO
/****** Object:  StoredProcedure [dbo].[delete_category]    Script Date: 08/12/2022 16:30:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[delete_category] @id int
AS
BEGIN
	DELETE FROM categories
	WHERE category_id = @id
END
GO
/****** Object:  StoredProcedure [dbo].[delete_library]    Script Date: 08/12/2022 16:30:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[delete_library] @id int
AS
BEGIN
	DELETE FROM libraries
	WHERE library_id = @id
END
GO
/****** Object:  StoredProcedure [dbo].[delete_loan]    Script Date: 08/12/2022 16:30:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[delete_loan] @id int
AS
BEGIN
	DELETE FROM loans
	WHERE loan_id = @id
END
GO
/****** Object:  StoredProcedure [dbo].[delete_location]    Script Date: 08/12/2022 16:30:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[delete_location] @id int
AS
BEGIN
	DELETE FROM locations
	WHERE location_id = @id
END
GO
/****** Object:  StoredProcedure [dbo].[delete_publisher]    Script Date: 08/12/2022 16:30:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[delete_publisher] @id int
AS
BEGIN
	DELETE FROM publishers
	WHERE publisher_id = @id
END
GO
/****** Object:  StoredProcedure [dbo].[delete_title]    Script Date: 08/12/2022 16:30:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[delete_title] @id int
AS
BEGIN
	DELETE FROM titles
	WHERE title_id = @id
END
GO
/****** Object:  StoredProcedure [dbo].[delete_title_author]    Script Date: 08/12/2022 16:30:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[delete_title_author] @id int
AS
BEGIN
	DELETE FROM titles_authors
	WHERE title_author_id = @id
END
GO
/****** Object:  StoredProcedure [dbo].[delete_town]    Script Date: 08/12/2022 16:30:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[delete_town] @id int
AS
BEGIN
	DELETE FROM towns
	WHERE town_id = @id
END
GO
/****** Object:  StoredProcedure [dbo].[delete_user]    Script Date: 08/12/2022 16:30:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[delete_user] @id int
AS
BEGIN
	DELETE FROM users
	WHERE [user_id] = @id
END
GO
/****** Object:  StoredProcedure [dbo].[insert_author]    Script Date: 08/12/2022 16:30:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[insert_author](
@first_name NVARCHAR(50), @last_name NVARCHAR(50)
)
AS BEGIN
INSERT INTO authors (first_name, last_name)
VALUES (@first_name, @last_name)
END
GO
/****** Object:  StoredProcedure [dbo].[insert_book]    Script Date: 08/12/2022 16:30:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[insert_book](
@title_id INT, @library_id INT
)
AS BEGIN
INSERT INTO books (title_id, library_id)
VALUES (@title_id, @library_id)
END
GO
/****** Object:  StoredProcedure [dbo].[insert_category]    Script Date: 08/12/2022 16:30:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[insert_category](
@category_name NVARCHAR(255)
)
AS BEGIN
INSERT INTO categories (category_name)
VALUES (@category_name)
END
GO
/****** Object:  StoredProcedure [dbo].[insert_library]    Script Date: 08/12/2022 16:30:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[insert_library](
@library_name NVARCHAR(255), @location_id INT
)
AS BEGIN
INSERT INTO libraries (library_name, location_id)
VALUES (@library_name, @location_id)
END
GO
/****** Object:  StoredProcedure [dbo].[insert_loan]    Script Date: 08/12/2022 16:30:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[insert_loan](
@user_id INT, @book_id INT
)
AS BEGIN
INSERT INTO loans ([user_id], [book_id])
VALUES (@user_id, @book_id)
END
GO
/****** Object:  StoredProcedure [dbo].[insert_location]    Script Date: 08/12/2022 16:30:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[insert_location](
@address NVARCHAR(255), @town_id INT
)
AS BEGIN
INSERT INTO locations ([address], [town_id])
VALUES (@address, @town_id)
END
GO
/****** Object:  StoredProcedure [dbo].[insert_publisher]    Script Date: 08/12/2022 16:30:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[insert_publisher](
@publisher_name NVARCHAR(255), @location_id INT
)
AS BEGIN
INSERT INTO publishers (publisher_name, location_id)
VALUES (@publisher_name, @location_id)
END
GO
/****** Object:  StoredProcedure [dbo].[insert_title]    Script Date: 08/12/2022 16:30:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[insert_title](
@title_name NVARCHAR(255), @page_count INT, @category_id INT, @publisher_id INT, @date_released DATE
)
AS BEGIN
IF(@page_count < 10)
THROW 50001, 'Number of pages cannot be less than ten.', 1;
ELSE IF(@date_released > GETDATE())
THROW 50002, 'Date of release cannot be in the future', 1;
ELSE
BEGIN
INSERT INTO titles (title_name, page_count, category_id, publisher_id, date_released)
VALUES (@title_name, @page_count, @category_id, @publisher_id, @date_released)
END
END
GO
/****** Object:  StoredProcedure [dbo].[insert_title_author]    Script Date: 08/12/2022 16:30:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[insert_title_author](
@author_id INT, @title_id INT, @position TINYINT
)
AS BEGIN
INSERT INTO titles_authors (author_id, title_id, position)
VALUES (@author_id, @title_id, @position)
END
GO
/****** Object:  StoredProcedure [dbo].[insert_town]    Script Date: 08/12/2022 16:30:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[insert_town](
@town_name NVARCHAR(50)
)
AS BEGIN
INSERT INTO towns (town_name)
VALUES (@town_name)
END
GO
/****** Object:  StoredProcedure [dbo].[insert_user]    Script Date: 08/12/2022 16:30:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[insert_user](
@first_name NVARCHAR(50), @last_name NVARCHAR(50), @birthday DATE
)
AS BEGIN
IF(@birthday > GETDATE())
THROW 50003 ,'Birthday cannot be in the future', 1;
ELSE
BEGIN
INSERT INTO users (first_name, last_name, birthday)
VALUES (@first_name, @last_name, @birthday)
END
END
GO
/****** Object:  StoredProcedure [dbo].[select_author]    Script Date: 08/12/2022 16:30:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[select_author] (@author_id INT)
AS BEGIN
SELECT author_id, first_name, last_name FROM authors
WHERE author_id =@author_id
END
GO
/****** Object:  StoredProcedure [dbo].[select_authors]    Script Date: 08/12/2022 16:30:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[select_authors]
AS BEGIN
SELECT author_id, first_name, last_name FROM authors
END
GO
/****** Object:  StoredProcedure [dbo].[select_book]    Script Date: 08/12/2022 16:30:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[select_book] (@book_id INT)
AS BEGIN
SELECT book_id, title_id, library_id, loaned FROM books
WHERE book_id =@book_id
END
GO
/****** Object:  StoredProcedure [dbo].[select_books]    Script Date: 08/12/2022 16:30:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[select_books]
AS BEGIN
SELECT book_id, title_id, library_id, loaned FROM books
END
GO
/****** Object:  StoredProcedure [dbo].[select_categories]    Script Date: 08/12/2022 16:30:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[select_categories]
AS BEGIN
SELECT category_id, category_name FROM categories
END
GO
/****** Object:  StoredProcedure [dbo].[select_category]    Script Date: 08/12/2022 16:30:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[select_category] (@category_id INT)
AS BEGIN
SELECT category_id, category_name FROM categories
WHERE category_id =@category_id
END
GO
/****** Object:  StoredProcedure [dbo].[select_libraries]    Script Date: 08/12/2022 16:30:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[select_libraries]
AS BEGIN
SELECT library_id, library_name, location_id FROM libraries
END
GO
/****** Object:  StoredProcedure [dbo].[select_library]    Script Date: 08/12/2022 16:30:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[select_library] (@library_id INT)
AS BEGIN
SELECT library_id, library_name, location_id FROM libraries
WHERE library_id =@library_id
END
GO
/****** Object:  StoredProcedure [dbo].[select_loan]    Script Date: 08/12/2022 16:30:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[select_loan] (@loan_id INT)
AS BEGIN
SELECT loan_id, book_id, [user_id], date_loaned, date_due, date_returned FROM loans
WHERE loan_id =@loan_id
END
GO
/****** Object:  StoredProcedure [dbo].[select_loans]    Script Date: 08/12/2022 16:30:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[select_loans]
AS BEGIN
SELECT loan_id, book_id, [user_id], date_loaned, date_due, date_returned FROM loans
END
GO
/****** Object:  StoredProcedure [dbo].[select_location]    Script Date: 08/12/2022 16:30:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[select_location] (@location_id INT)
AS BEGIN
SELECT location_id, [address], town_id FROM locations
WHERE location_id =@location_id
END
GO
/****** Object:  StoredProcedure [dbo].[select_locations]    Script Date: 08/12/2022 16:30:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[select_locations]
AS BEGIN
SELECT location_id, [address], town_id FROM locations
END
GO
/****** Object:  StoredProcedure [dbo].[select_publisher]    Script Date: 08/12/2022 16:30:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[select_publisher] (@publisher_id INT)
AS BEGIN
SELECT publisher_id, publisher_name, location_id FROM publishers
WHERE publisher_id =@publisher_id
END
GO
/****** Object:  StoredProcedure [dbo].[select_publishers]    Script Date: 08/12/2022 16:30:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[select_publishers]
AS BEGIN
SELECT publisher_id, publisher_name, location_id FROM publishers
END
GO
/****** Object:  StoredProcedure [dbo].[select_title]    Script Date: 08/12/2022 16:30:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[select_title] (@title_id INT)
AS BEGIN
SELECT title_id, title_name, category_id, page_count, publisher_id, date_released FROM titles
WHERE title_id =@title_id
END
GO
/****** Object:  StoredProcedure [dbo].[select_title_author]    Script Date: 08/12/2022 16:30:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[select_title_author] (@title_author_id INT)
AS BEGIN
SELECT title_author_id, author_id, title_id, position FROM titles_authors_data
WHERE title_author_id =@title_author_id
END
GO
/****** Object:  StoredProcedure [dbo].[select_titles]    Script Date: 08/12/2022 16:30:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[select_titles]
AS BEGIN
SELECT category_id, page_count, title_name, title_id, publisher_id, date_released FROM titles
END
GO
/****** Object:  StoredProcedure [dbo].[select_titles_authors]    Script Date: 08/12/2022 16:30:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[select_titles_authors]
AS BEGIN
SELECT title_author_id, author_id, title_id, position FROM titles_authors
END
GO
/****** Object:  StoredProcedure [dbo].[select_town]    Script Date: 08/12/2022 16:30:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[select_town] (@town_id INT)
AS BEGIN
SELECT town_id, town_name FROM towns_data
WHERE town_id =@town_id
END
GO
/****** Object:  StoredProcedure [dbo].[select_towns]    Script Date: 08/12/2022 16:30:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[select_towns]
AS BEGIN
SELECT town_name, town_id FROM towns
END
GO
/****** Object:  StoredProcedure [dbo].[select_user]    Script Date: 08/12/2022 16:30:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[select_user] (@user_id INT)
AS BEGIN
SELECT first_name, last_name, [user_id], birthday FROM users_data
WHERE user_id =@user_id
END
GO
/****** Object:  StoredProcedure [dbo].[select_users]    Script Date: 08/12/2022 16:30:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[select_users]
AS BEGIN
SELECT first_name, last_name, [user_id], birthday FROM users
END
GO
/****** Object:  StoredProcedure [dbo].[update_author]    Script Date: 08/12/2022 16:30:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[update_author](
@author_id INT, @first_name NVARCHAR(50), @last_name NVARCHAR(50)
)
AS BEGIN
SET NOCOUNT ON;
UPDATE authors SET first_name = @first_name, last_name = @last_name
WHERE author_id = @author_id
END
GO
/****** Object:  StoredProcedure [dbo].[update_book]    Script Date: 08/12/2022 16:30:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[update_book](
@book_id INT, @title_id INT, @library_id INT
)
AS BEGIN
SET NOCOUNT ON;
UPDATE books SET title_id = @title_id, library_id = @library_id
WHERE book_id = @book_id
END
GO
/****** Object:  StoredProcedure [dbo].[update_category]    Script Date: 08/12/2022 16:30:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[update_category](
@category_id INT, @category_name NVARCHAR(255)
)
AS BEGIN
SET NOCOUNT ON;
UPDATE categories SET category_name = @category_name
WHERE category_id = @category_id
END
GO
/****** Object:  StoredProcedure [dbo].[update_library]    Script Date: 08/12/2022 16:30:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[update_library](
@library_id INT, @library_name NVARCHAR(255), @location_id INT
)
AS BEGIN
SET NOCOUNT ON;
UPDATE libraries SET library_name  = @library_name, location_id = @location_id
WHERE library_id = @library_id
END
GO
/****** Object:  StoredProcedure [dbo].[update_loan]    Script Date: 08/12/2022 16:30:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[update_loan](
@loan_id INT, @user_id INT, @book_id INT
)
AS BEGIN
SET NOCOUNT ON;
UPDATE loans SET [user_id] = @user_id, book_id = @book_id
WHERE loan_id = loan_id
END
GO
/****** Object:  StoredProcedure [dbo].[update_location]    Script Date: 08/12/2022 16:30:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[update_location](
@location_id INT, @address NVARCHAR(255), @town_id INT
)
AS BEGIN
SET NOCOUNT ON;
UPDATE locations SET [address] = @address, town_id = @town_id
WHERE location_id = @location_id
END
GO
/****** Object:  StoredProcedure [dbo].[update_publisher]    Script Date: 08/12/2022 16:30:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[update_publisher](
@publisher_id INT, @publisher_name NVARCHAR(255), @location_id INT
)
AS BEGIN
SET NOCOUNT ON;
UPDATE publishers SET publisher_name = @publisher_name, location_id = @location_id
WHERE publisher_id = @publisher_id
END
GO
/****** Object:  StoredProcedure [dbo].[update_title]    Script Date: 08/12/2022 16:30:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[update_title](
@title_id INT,@title_name NVARCHAR(255), @page_count INT, @category_id INT, @publisher_id INT, @date_released DATE
)
AS BEGIN
SET NOCOUNT ON;
IF(@page_count < 10)
THROW 50001, 'Number of pages cannot be less than ten.', 1;
ELSE IF(@date_released > GETDATE())
THROW 50002, 'Date of release cannot be in the future', 1;
ELSE
BEGIN
UPDATE titles SET title_name = @title_name, page_count = @page_count, category_id = @category_id, publisher_id = @publisher_id, date_released = @date_released
WHERE title_id = @title_id
END
END
GO
/****** Object:  StoredProcedure [dbo].[update_title_author]    Script Date: 08/12/2022 16:30:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[update_title_author](
@title_author_id INT, @author_id INT, @title_id INT, @position TINYINT
)
AS BEGIN
SET NOCOUNT ON;
UPDATE titles_authors SET author_id = @author_id, title_id = @title_id, position = @position
WHERE title_author_id = @title_author_id
END
GO
/****** Object:  StoredProcedure [dbo].[update_town]    Script Date: 08/12/2022 16:30:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[update_town](
@town_id INT, @town_name NVARCHAR(50)
)
AS BEGIN
SET NOCOUNT ON;
UPDATE towns SET town_name = @town_name
WHERE town_id = @town_id
END
GO
/****** Object:  StoredProcedure [dbo].[update_user]    Script Date: 08/12/2022 16:30:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[update_user](
@user_id INT, @first_name NVARCHAR(50), @last_name NVARCHAR(50), @birthday DATE
)
AS BEGIN
SET NOCOUNT ON;
UPDATE users SET first_name = @first_name, last_name = @last_name, birthday = @birthday
WHERE [user_id] = @user_id
END
GO
/****** Object:  Trigger [dbo].[author_delete]    Script Date: 08/12/2022 16:30:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[author_delete] ON [dbo].[authors]
 INSTEAD OF DELETE
 AS BEGIN
SET NOCOUNT ON
 DECLARE @data_deleted nvarchar(max)
 SET @data_deleted = (SELECT * FROM deleted FOR JSON PATH, ROOT('authors'))
 INSERT INTO activities (data_deleted, action) VALUES (@data_deleted, 'Delete author')
UPDATE authors SET date_deleted = GETDATE()
 WHERE author_id = (SELECT author_id FROM deleted)
END
GO
ALTER TABLE [dbo].[authors] ENABLE TRIGGER [author_delete]
GO
/****** Object:  Trigger [dbo].[author_insert]    Script Date: 08/12/2022 16:30:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[author_insert] ON [dbo].[authors]
 AFTER INSERT
 AS BEGIN
SET NOCOUNT ON
 DECLARE @data_inserted nvarchar(max)
 SET @data_inserted = (SELECT * FROM inserted FOR JSON PATH, ROOT('authors'))
 INSERT INTO activities (data_inserted, action) VALUES (@data_inserted, 'Insert author')
END
GO
ALTER TABLE [dbo].[authors] ENABLE TRIGGER [author_insert]
GO
/****** Object:  Trigger [dbo].[author_update]    Script Date: 08/12/2022 16:30:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[author_update] ON [dbo].[authors]
 AFTER UPDATE
 AS BEGIN
SET NOCOUNT ON
 DECLARE @data_inserted nvarchar(max)
 SET @data_inserted = (SELECT * FROM inserted FOR JSON PATH, ROOT('authors'))
 INSERT INTO activities (data_inserted, action) VALUES (@data_inserted, 'Update author')
UPDATE authors SET date_updated = GETDATE()
 WHERE author_id = (SELECT author_id FROM inserted)
END
GO
ALTER TABLE [dbo].[authors] ENABLE TRIGGER [author_update]
GO
/****** Object:  Trigger [dbo].[book_delete]    Script Date: 08/12/2022 16:30:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[book_delete] ON [dbo].[books]
 INSTEAD OF DELETE
 AS BEGIN
SET NOCOUNT ON
 DECLARE @data_deleted nvarchar(max)
 SET @data_deleted = (SELECT * FROM deleted FOR JSON PATH, ROOT('books'))
 INSERT INTO activities (data_deleted, action) VALUES (@data_deleted, 'Delete book')
UPDATE books SET date_deleted = GETDATE()
 WHERE book_id = (SELECT book_id FROM deleted)
END
GO
ALTER TABLE [dbo].[books] ENABLE TRIGGER [book_delete]
GO
/****** Object:  Trigger [dbo].[book_insert]    Script Date: 08/12/2022 16:30:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[book_insert] ON [dbo].[books]
 AFTER INSERT
 AS BEGIN
SET NOCOUNT ON
 DECLARE @data_inserted nvarchar(max)
 SET @data_inserted = (SELECT * FROM inserted FOR JSON PATH, ROOT('books'))
 INSERT INTO activities (data_inserted, action) VALUES (@data_inserted, 'Insert book')
END
GO
ALTER TABLE [dbo].[books] ENABLE TRIGGER [book_insert]
GO
/****** Object:  Trigger [dbo].[book_update]    Script Date: 08/12/2022 16:30:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[book_update] ON [dbo].[books]
 AFTER UPDATE
 AS BEGIN
SET NOCOUNT ON
 DECLARE @data_inserted nvarchar(max)
 SET @data_inserted = (SELECT * FROM inserted FOR JSON PATH, ROOT('books'))
 INSERT INTO activities (data_inserted, action) VALUES (@data_inserted, 'Update book')
UPDATE books SET date_updated = GETDATE()
 WHERE book_id = (SELECT book_id FROM inserted)
END
GO
ALTER TABLE [dbo].[books] ENABLE TRIGGER [book_update]
GO
/****** Object:  Trigger [dbo].[category_delete]    Script Date: 08/12/2022 16:30:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[category_delete] ON [dbo].[categories]
 INSTEAD OF DELETE
 AS BEGIN
SET NOCOUNT ON
 DECLARE @data_deleted nvarchar(max)
 SET @data_deleted = (SELECT * FROM deleted FOR JSON PATH, ROOT('categories'))
 INSERT INTO activities (data_deleted, action) VALUES (@data_deleted, 'Delete category')
UPDATE categories SET date_deleted = GETDATE()
 WHERE category_id = (SELECT category_id FROM deleted)
END
GO
ALTER TABLE [dbo].[categories] ENABLE TRIGGER [category_delete]
GO
/****** Object:  Trigger [dbo].[category_insert]    Script Date: 08/12/2022 16:30:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[category_insert] ON [dbo].[categories]
 AFTER INSERT
 AS BEGIN
SET NOCOUNT ON
 DECLARE @data_inserted nvarchar(max)
 SET @data_inserted = (SELECT * FROM inserted FOR JSON PATH, ROOT('categories'))
 INSERT INTO activities (data_inserted, action) VALUES (@data_inserted, 'Insert category')
END
GO
ALTER TABLE [dbo].[categories] ENABLE TRIGGER [category_insert]
GO
/****** Object:  Trigger [dbo].[category_update]    Script Date: 08/12/2022 16:30:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[category_update] ON [dbo].[categories]
 AFTER UPDATE
 AS BEGIN
SET NOCOUNT ON
 DECLARE @data_inserted nvarchar(max)
 SET @data_inserted = (SELECT * FROM inserted FOR JSON PATH, ROOT('categories'))
 INSERT INTO activities (data_inserted, action) VALUES (@data_inserted, 'Update category')
UPDATE categories SET date_updated = GETDATE()
 WHERE category_id = (SELECT category_id FROM inserted)
END
GO
ALTER TABLE [dbo].[categories] ENABLE TRIGGER [category_update]
GO
/****** Object:  Trigger [dbo].[library_delete]    Script Date: 08/12/2022 16:30:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[library_delete] ON [dbo].[libraries]
 INSTEAD OF DELETE
 AS BEGIN
SET NOCOUNT ON
 DECLARE @data_deleted nvarchar(max)
 SET @data_deleted = (SELECT * FROM deleted FOR JSON PATH, ROOT('libraries'))
 INSERT INTO activities (data_deleted, action) VALUES (@data_deleted, 'Delete library')
UPDATE libraries SET date_deleted = GETDATE()
 WHERE library_id = (SELECT library_id FROM deleted)
END
GO
ALTER TABLE [dbo].[libraries] ENABLE TRIGGER [library_delete]
GO
/****** Object:  Trigger [dbo].[library_insert]    Script Date: 08/12/2022 16:30:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[library_insert] ON [dbo].[libraries]
 AFTER INSERT
 AS BEGIN
SET NOCOUNT ON
 DECLARE @data_inserted nvarchar(max)
 SET @data_inserted = (SELECT * FROM inserted FOR JSON PATH, ROOT('libraries'))
 INSERT INTO activities (data_inserted, action) VALUES (@data_inserted, 'Insert library')
END
GO
ALTER TABLE [dbo].[libraries] ENABLE TRIGGER [library_insert]
GO
/****** Object:  Trigger [dbo].[library_update]    Script Date: 08/12/2022 16:30:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[library_update] ON [dbo].[libraries]
 AFTER UPDATE
 AS BEGIN
SET NOCOUNT ON
 DECLARE @data_inserted nvarchar(max)
 SET @data_inserted = (SELECT * FROM inserted FOR JSON PATH, ROOT('libraries'))
 INSERT INTO activities (data_inserted, action) VALUES (@data_inserted, 'Update library')
UPDATE libraries SET date_updated = GETDATE()
 WHERE library_id = (SELECT library_id FROM inserted)
END
GO
ALTER TABLE [dbo].[libraries] ENABLE TRIGGER [library_update]
GO
/****** Object:  Trigger [dbo].[loan_delete]    Script Date: 08/12/2022 16:30:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[loan_delete] ON [dbo].[loans]
 INSTEAD OF DELETE
 AS BEGIN
SET NOCOUNT ON
 DECLARE @data_deleted nvarchar(max)
 SET @data_deleted = (SELECT * FROM deleted FOR JSON PATH, ROOT('loans'))
 INSERT INTO activities (data_deleted, action) VALUES (@data_deleted, 'Delete loan')
UPDATE loans SET date_deleted = GETDATE()
 WHERE loan_id = (SELECT loan_id FROM deleted)
END
GO
ALTER TABLE [dbo].[loans] ENABLE TRIGGER [loan_delete]
GO
/****** Object:  Trigger [dbo].[loan_give]    Script Date: 08/12/2022 16:30:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[loan_give] 
   ON  [dbo].[loans]
   AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;
	DECLARE @date_loaned DATETIME, @loan_id INT, @book_id INT
	SELECT @loan_id = loan_id, @book_id = book_id FROM inserted
	SELECT @date_loaned = date_loaned FROM loans WHERE loan_id = @loan_id
	IF(@date_loaned < GETDATE())
	BEGIN
	UPDATE books SET loaned = 1 WHERE book_id = @book_id
	END
END
GO
ALTER TABLE [dbo].[loans] ENABLE TRIGGER [loan_give]
GO
/****** Object:  Trigger [dbo].[loan_insert]    Script Date: 08/12/2022 16:30:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[loan_insert] ON [dbo].[loans]
 AFTER INSERT
 AS BEGIN
SET NOCOUNT ON
 DECLARE @data_inserted nvarchar(max)
 SET @data_inserted = (SELECT * FROM inserted FOR JSON PATH, ROOT('loans'))
 INSERT INTO activities (data_inserted, action) VALUES (@data_inserted, 'Insert loan')
END
GO
ALTER TABLE [dbo].[loans] ENABLE TRIGGER [loan_insert]
GO
/****** Object:  Trigger [dbo].[loan_return]    Script Date: 08/12/2022 16:30:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[loan_return] 
   ON  [dbo].[loans]
   AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;
	DECLARE @date_returned DATETIME, @loan_id INT, @book_id INT
	SELECT @loan_id = loan_id, @book_id = book_id FROM inserted
	SELECT @date_returned = date_loaned FROM loans WHERE loan_id = @loan_id
	IF(@date_returned < GETDATE())
	BEGIN
	UPDATE books SET loaned = 0 WHERE book_id = @book_id
	END
END
GO
ALTER TABLE [dbo].[loans] ENABLE TRIGGER [loan_return]
GO
/****** Object:  Trigger [dbo].[loan_update]    Script Date: 08/12/2022 16:30:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[loan_update] ON [dbo].[loans]
 AFTER UPDATE
 AS BEGIN
SET NOCOUNT ON
 DECLARE @data_inserted nvarchar(max)
 SET @data_inserted = (SELECT * FROM inserted FOR JSON PATH, ROOT('loans'))
 INSERT INTO activities (data_inserted, action) VALUES (@data_inserted, 'Update loan')
UPDATE loans SET date_updated = GETDATE()
 WHERE loan_id = (SELECT loan_id FROM inserted)
END
GO
ALTER TABLE [dbo].[loans] ENABLE TRIGGER [loan_update]
GO
/****** Object:  Trigger [dbo].[location_delete]    Script Date: 08/12/2022 16:30:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[location_delete] ON [dbo].[locations]
 INSTEAD OF DELETE
 AS BEGIN
SET NOCOUNT ON
 DECLARE @data_deleted nvarchar(max)
 SET @data_deleted = (SELECT * FROM deleted FOR JSON PATH, ROOT('locations'))
 INSERT INTO activities (data_deleted, action) VALUES (@data_deleted, 'Delete location')
UPDATE locations SET date_deleted = GETDATE()
 WHERE location_id = (SELECT location_id FROM deleted)
END
GO
ALTER TABLE [dbo].[locations] ENABLE TRIGGER [location_delete]
GO
/****** Object:  Trigger [dbo].[location_insert]    Script Date: 08/12/2022 16:30:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[location_insert] ON [dbo].[locations]
 AFTER INSERT
 AS BEGIN
SET NOCOUNT ON
 DECLARE @data_inserted nvarchar(max)
 SET @data_inserted = (SELECT * FROM inserted FOR JSON PATH, ROOT('locations'))
 INSERT INTO activities (data_inserted, action) VALUES (@data_inserted, 'Insert location')
END
GO
ALTER TABLE [dbo].[locations] ENABLE TRIGGER [location_insert]
GO
/****** Object:  Trigger [dbo].[location_update]    Script Date: 08/12/2022 16:30:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[location_update] ON [dbo].[locations]
 AFTER UPDATE
 AS BEGIN
SET NOCOUNT ON
 DECLARE @data_inserted nvarchar(max)
 SET @data_inserted = (SELECT * FROM inserted FOR JSON PATH, ROOT('locations'))
 INSERT INTO activities (data_inserted, action) VALUES (@data_inserted, 'Update location')
UPDATE locations SET date_updated = GETDATE()
 WHERE location_id = (SELECT location_id FROM inserted)
END
GO
ALTER TABLE [dbo].[locations] ENABLE TRIGGER [location_update]
GO
/****** Object:  Trigger [dbo].[publisher_delete]    Script Date: 08/12/2022 16:30:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[publisher_delete] ON [dbo].[publishers]
 INSTEAD OF DELETE
 AS BEGIN
SET NOCOUNT ON
 DECLARE @data_deleted nvarchar(max)
 SET @data_deleted = (SELECT * FROM deleted FOR JSON PATH, ROOT('publishers'))
 INSERT INTO activities (data_deleted, action) VALUES (@data_deleted, 'Delete publisher')
UPDATE publishers SET date_deleted = GETDATE()
 WHERE publisher_id = (SELECT publisher_id FROM deleted)
END
GO
ALTER TABLE [dbo].[publishers] ENABLE TRIGGER [publisher_delete]
GO
/****** Object:  Trigger [dbo].[publisher_insert]    Script Date: 08/12/2022 16:30:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[publisher_insert] ON [dbo].[publishers]
 AFTER INSERT
 AS BEGIN
SET NOCOUNT ON
 DECLARE @data_inserted nvarchar(max)
 SET @data_inserted = (SELECT * FROM inserted FOR JSON PATH, ROOT('publishers'))
 INSERT INTO activities (data_inserted, action) VALUES (@data_inserted, 'Insert publisher')
END
GO
ALTER TABLE [dbo].[publishers] ENABLE TRIGGER [publisher_insert]
GO
/****** Object:  Trigger [dbo].[publisher_update]    Script Date: 08/12/2022 16:30:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[publisher_update] ON [dbo].[publishers]
 AFTER UPDATE
 AS BEGIN
SET NOCOUNT ON
 DECLARE @data_inserted nvarchar(max)
 SET @data_inserted = (SELECT * FROM inserted FOR JSON PATH, ROOT('publishers'))
 INSERT INTO activities (data_inserted, action) VALUES (@data_inserted, 'Update publisher')
UPDATE publishers SET date_updated = GETDATE()
 WHERE publisher_id = (SELECT publisher_id FROM inserted)
END
GO
ALTER TABLE [dbo].[publishers] ENABLE TRIGGER [publisher_update]
GO
/****** Object:  Trigger [dbo].[title_delete]    Script Date: 08/12/2022 16:30:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[title_delete] ON [dbo].[titles]
 INSTEAD OF DELETE
 AS BEGIN
SET NOCOUNT ON
 DECLARE @data_deleted nvarchar(max)
 SET @data_deleted = (SELECT * FROM deleted FOR JSON PATH, ROOT('titles'))
 INSERT INTO activities (data_deleted, action) VALUES (@data_deleted, 'Delete title')
UPDATE titles SET date_deleted = GETDATE()
 WHERE title_id = (SELECT title_id FROM deleted)
END
GO
ALTER TABLE [dbo].[titles] ENABLE TRIGGER [title_delete]
GO
/****** Object:  Trigger [dbo].[title_insert]    Script Date: 08/12/2022 16:30:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[title_insert] ON [dbo].[titles]
 AFTER INSERT
 AS BEGIN
SET NOCOUNT ON
 DECLARE @data_inserted nvarchar(max)
 SET @data_inserted = (SELECT * FROM inserted FOR JSON PATH, ROOT('titles'))
 INSERT INTO activities (data_inserted, action) VALUES (@data_inserted, 'Insert title')
END
GO
ALTER TABLE [dbo].[titles] ENABLE TRIGGER [title_insert]
GO
/****** Object:  Trigger [dbo].[title_update]    Script Date: 08/12/2022 16:30:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[title_update] ON [dbo].[titles]
 AFTER UPDATE
 AS BEGIN
SET NOCOUNT ON
 DECLARE @data_inserted nvarchar(max)
 SET @data_inserted = (SELECT * FROM inserted FOR JSON PATH, ROOT('titles'))
 INSERT INTO activities (data_inserted, action) VALUES (@data_inserted, 'Update title')
UPDATE titles SET date_updated = GETDATE()
 WHERE title_id = (SELECT title_id FROM inserted)
END
GO
ALTER TABLE [dbo].[titles] ENABLE TRIGGER [title_update]
GO
/****** Object:  Trigger [dbo].[title_author_delete]    Script Date: 08/12/2022 16:30:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[title_author_delete] ON [dbo].[titles_authors]
 INSTEAD OF DELETE
 AS BEGIN
SET NOCOUNT ON
 DECLARE @data_deleted nvarchar(max)
 SET @data_deleted = (SELECT * FROM deleted FOR JSON PATH, ROOT('titles_authors'))
 INSERT INTO activities (data_deleted, action) VALUES (@data_deleted, 'Delete title_author')
UPDATE titles_authors SET date_deleted = GETDATE()
 WHERE title_author_id = (SELECT title_author_id FROM deleted)
END
GO
ALTER TABLE [dbo].[titles_authors] ENABLE TRIGGER [title_author_delete]
GO
/****** Object:  Trigger [dbo].[title_author_insert]    Script Date: 08/12/2022 16:30:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[title_author_insert] ON [dbo].[titles_authors]
 AFTER INSERT
 AS BEGIN
SET NOCOUNT ON
 DECLARE @data_inserted nvarchar(max)
 SET @data_inserted = (SELECT * FROM inserted FOR JSON PATH, ROOT('titles_authors'))
 INSERT INTO activities (data_inserted, action) VALUES (@data_inserted, 'Insert title_author')
END
GO
ALTER TABLE [dbo].[titles_authors] ENABLE TRIGGER [title_author_insert]
GO
/****** Object:  Trigger [dbo].[title_author_update]    Script Date: 08/12/2022 16:30:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[title_author_update] ON [dbo].[titles_authors]
 AFTER UPDATE
 AS BEGIN
SET NOCOUNT ON
 DECLARE @data_inserted nvarchar(max)
 SET @data_inserted = (SELECT * FROM inserted FOR JSON PATH, ROOT('titles_authors'))
 INSERT INTO activities (data_inserted, action) VALUES (@data_inserted, 'Update title_author')
UPDATE titles_authors SET date_updated = GETDATE()
 WHERE title_author_id = (SELECT title_author_id FROM inserted)
END
GO
ALTER TABLE [dbo].[titles_authors] ENABLE TRIGGER [title_author_update]
GO
/****** Object:  Trigger [dbo].[town_delete]    Script Date: 08/12/2022 16:30:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[town_delete] ON [dbo].[towns]
 INSTEAD OF DELETE
 AS BEGIN
SET NOCOUNT ON
 DECLARE @data_deleted nvarchar(max)
 SET @data_deleted = (SELECT * FROM deleted FOR JSON PATH, ROOT('towns'))
 INSERT INTO activities (data_deleted, action) VALUES (@data_deleted, 'Delete town')
UPDATE towns SET date_deleted = GETDATE()
 WHERE town_id = (SELECT town_id FROM deleted)
END
GO
ALTER TABLE [dbo].[towns] ENABLE TRIGGER [town_delete]
GO
/****** Object:  Trigger [dbo].[town_insert]    Script Date: 08/12/2022 16:30:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[town_insert] ON [dbo].[towns]
 AFTER INSERT
 AS BEGIN
SET NOCOUNT ON
 DECLARE @data_inserted nvarchar(max)
 SET @data_inserted = (SELECT * FROM inserted FOR JSON PATH, ROOT('towns'))
 INSERT INTO activities (data_inserted, action) VALUES (@data_inserted, 'Insert town')
END
GO
ALTER TABLE [dbo].[towns] ENABLE TRIGGER [town_insert]
GO
/****** Object:  Trigger [dbo].[town_update]    Script Date: 08/12/2022 16:30:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[town_update] ON [dbo].[towns]
 AFTER UPDATE
 AS BEGIN
SET NOCOUNT ON
 DECLARE @data_inserted nvarchar(max)
 SET @data_inserted = (SELECT * FROM inserted FOR JSON PATH, ROOT('towns'))
 INSERT INTO activities (data_inserted, action) VALUES (@data_inserted, 'Update town')
UPDATE towns SET date_updated = GETDATE()
 WHERE town_id = (SELECT town_id FROM inserted)
END
GO
ALTER TABLE [dbo].[towns] ENABLE TRIGGER [town_update]
GO
/****** Object:  Trigger [dbo].[user_delete]    Script Date: 08/12/2022 16:30:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[user_delete] ON [dbo].[users]
 INSTEAD OF DELETE
 AS BEGIN
SET NOCOUNT ON
 DECLARE @data_deleted nvarchar(max)
 SET @data_deleted = (SELECT * FROM deleted FOR JSON PATH, ROOT('users'))
 INSERT INTO activities (data_deleted, action) VALUES (@data_deleted, 'Delete user')
UPDATE users SET date_deleted = GETDATE()
 WHERE user_id = (SELECT user_id FROM deleted)
END
GO
ALTER TABLE [dbo].[users] ENABLE TRIGGER [user_delete]
GO
/****** Object:  Trigger [dbo].[user_insert]    Script Date: 08/12/2022 16:30:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[user_insert] ON [dbo].[users]
 AFTER INSERT
 AS BEGIN
SET NOCOUNT ON
 DECLARE @data_inserted nvarchar(max)
 SET @data_inserted = (SELECT * FROM inserted FOR JSON PATH, ROOT('users'))
 INSERT INTO activities (data_inserted, action) VALUES (@data_inserted, 'Insert user')
END
GO
ALTER TABLE [dbo].[users] ENABLE TRIGGER [user_insert]
GO
/****** Object:  Trigger [dbo].[user_update]    Script Date: 08/12/2022 16:30:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[user_update] ON [dbo].[users]
 AFTER UPDATE
 AS BEGIN
SET NOCOUNT ON
 DECLARE @data_inserted nvarchar(max)
 SET @data_inserted = (SELECT * FROM inserted FOR JSON PATH, ROOT('users'))
 INSERT INTO activities (data_inserted, action) VALUES (@data_inserted, 'Update user')
UPDATE users SET date_updated = GETDATE()
 WHERE user_id = (SELECT user_id FROM inserted)
END
GO
ALTER TABLE [dbo].[users] ENABLE TRIGGER [user_update]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "a"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 119
               Right = 224
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ta"
            Begin Extent = 
               Top = 6
               Left = 262
               Bottom = 136
               Right = 448
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 12
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'author_more_than_one_title'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'author_more_than_one_title'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "authors"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 208
            End
            DisplayFlags = 280
            TopColumn = 3
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'authors_data'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'authors_data'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "books"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 208
            End
            DisplayFlags = 280
            TopColumn = 3
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'books_data'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'books_data'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "loans_data"
            Begin Extent = 
               Top = 1
               Left = 425
               Bottom = 131
               Right = 595
            End
            DisplayFlags = 280
            TopColumn = 2
         End
         Begin Table = "books_data"
            Begin Extent = 
               Top = 12
               Left = 197
               Bottom = 142
               Right = 367
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "titles_data"
            Begin Extent = 
               Top = 155
               Left = 412
               Bottom = 285
               Right = 582
            End
            DisplayFlags = 280
            TopColumn = 1
         End
         Begin Table = "users_data"
            Begin Extent = 
               Top = 6
               Left = 662
               Bottom = 119
               Right = 832
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 3945
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'books_on_loan'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'books_on_loan'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "categories"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 208
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'categories_data'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'categories_data'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "libraries"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 208
            End
            DisplayFlags = 280
            TopColumn = 2
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'libraries_data'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'libraries_data'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "libraries_data"
            Begin Extent = 
               Top = 6
               Left = 1078
               Bottom = 119
               Right = 1248
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "locations_data"
            Begin Extent = 
               Top = 6
               Left = 870
               Bottom = 119
               Right = 1040
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "towns_data"
            Begin Extent = 
               Top = 6
               Left = 662
               Bottom = 102
               Right = 832
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'libraries_in_belgrade'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'libraries_in_belgrade'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "loans"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 208
            End
            DisplayFlags = 280
            TopColumn = 5
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'loans_data'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'loans_data'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "locations"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 208
            End
            DisplayFlags = 280
            TopColumn = 2
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'locations_data'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'locations_data'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "publishers"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 211
            End
            DisplayFlags = 280
            TopColumn = 2
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'publishers_data'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'publishers_data'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "p"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 119
               Right = 211
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "l"
            Begin Extent = 
               Top = 6
               Left = 249
               Bottom = 119
               Right = 419
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "t"
            Begin Extent = 
               Top = 6
               Left = 457
               Bottom = 102
               Right = 627
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'publishers_from_belgrade'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'publishers_from_belgrade'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "titles_authors"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 208
            End
            DisplayFlags = 280
            TopColumn = 3
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'titles_authors_data'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'titles_authors_data'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "titles"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 208
            End
            DisplayFlags = 280
            TopColumn = 5
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'titles_data'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'titles_data'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "titles_data"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 208
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'titles_without_copies'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'titles_without_copies'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "towns"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 208
            End
            DisplayFlags = 280
            TopColumn = 1
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'towns_data'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'towns_data'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "users"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 208
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'users_data'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'users_data'
GO
USE [master]
GO
ALTER DATABASE [Libraries] SET  READ_WRITE 
GO
