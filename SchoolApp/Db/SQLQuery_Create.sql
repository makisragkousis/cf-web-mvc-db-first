-- ============================================
-- 1. ROLES
-- ============================================
CREATE TABLE [dbo].[Roles] (
    [Id]        INT             IDENTITY(1, 1) NOT NULL,
    [Name]      NVARCHAR(50)    NOT NULL,
    CONSTRAINT [PK_Roles] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [UQ_Roles_Name] UNIQUE ([Name])
);
 
CREATE NONCLUSTERED INDEX [IX_Roles_Name]
    ON [dbo].[Roles]([Name] ASC);
 
-- ============================================
-- 2. CAPABILITIES
-- ============================================
CREATE TABLE [dbo].[Capabilities] (
    [Id]            INT             IDENTITY(1, 1) NOT NULL,
    [Name]          NVARCHAR(100)   NOT NULL,
    [Description]   NVARCHAR(255)   NULL,
    CONSTRAINT [PK_Capabilities] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [UQ_Capabilities_Name] UNIQUE ([Name])
);
 
CREATE NONCLUSTERED INDEX [IX_Capabilities_Name]
    ON [dbo].[Capabilities]([Name] ASC);
 
-- ============================================
-- 3. ROLES_CAPABILITIES (Many-to-Many)
-- ============================================
CREATE TABLE [dbo].[RolesCapabilities] (
    [RoleId]        INT NOT NULL,
    [CapabilityId]  INT NOT NULL,
    CONSTRAINT [PK_RolesCapabilities] PRIMARY KEY CLUSTERED ([RoleId], [CapabilityId]),
 
    CONSTRAINT [FK_RolesCapabilities_Roles]
        FOREIGN KEY ([RoleId]) REFERENCES [dbo].[Roles]([Id])
        ON DELETE CASCADE,
 
    CONSTRAINT [FK_RolesCapabilities_Capabilities]
        FOREIGN KEY ([CapabilityId]) REFERENCES [dbo].[Capabilities]([Id])
        ON DELETE CASCADE
);
 
CREATE NONCLUSTERED INDEX [IX_RolesCapabilities_CapabilityId]
    ON [dbo].[RolesCapabilities]([CapabilityId] ASC);
 
-- ============================================
-- 4. USERS
-- ============================================
CREATE TABLE [dbo].[Users] (
    [Id]            INT             IDENTITY(1, 1) NOT NULL,
    [Username]      NVARCHAR(50)    NOT NULL,
    [Email]         NVARCHAR(50)    NOT NULL,
    [Password]      NVARCHAR(60)    NOT NULL,
    [Firstname]     NVARCHAR(50)    NOT NULL,
    [Lastname]      NVARCHAR(50)    NOT NULL,
    [RoleId]        INT             NOT NULL,
    CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED ([Id] ASC),
 
    CONSTRAINT [FK_Users_Roles]
        FOREIGN KEY ([RoleId]) REFERENCES [dbo].[Roles]([Id])
        ON DELETE NO ACTION
);
 
CREATE UNIQUE NONCLUSTERED INDEX [IX_Users_Username]
    ON [dbo].[Users]([Username] ASC);
 
CREATE UNIQUE NONCLUSTERED INDEX [IX_Users_Email]
    ON [dbo].[Users]([Email] ASC);
 
CREATE NONCLUSTERED INDEX [IX_Users_RoleId]
    ON [dbo].[Users]([RoleId] ASC);
 
-- ============================================
-- 5. TEACHERS
-- ============================================
CREATE TABLE [dbo].[Teachers] (
    [Id]            INT             IDENTITY(1, 1) NOT NULL,
    [Institution]   NVARCHAR(50)    NOT NULL,
    [PhoneNumber]   NVARCHAR(20)    NULL,
    [UserId]        INT             NOT NULL,
    CONSTRAINT [PK_Teachers] PRIMARY KEY CLUSTERED ([Id] ASC),
 
    CONSTRAINT [FK_Teachers_Users]
        FOREIGN KEY ([UserId]) REFERENCES [dbo].[Users]([Id])
);
 
CREATE NONCLUSTERED INDEX [IX_Teachers_Institution]
    ON [dbo].[Teachers]([Institution] ASC);
 
CREATE UNIQUE NONCLUSTERED INDEX [IX_Teachers_UserId]
    ON [dbo].[Teachers]([UserId] ASC);
 
-- ============================================
-- 6. STUDENTS
-- ============================================
CREATE TABLE [dbo].[Students] (
    [Id]            INT             IDENTITY(1, 1) NOT NULL,
    [AM]            NVARCHAR(10)    NOT NULL,
    [Institution]   NVARCHAR(50)    NOT NULL,
    [Department]    NVARCHAR(50)    NULL,
    [UserId]        INT             NOT NULL,
    CONSTRAINT [PK_Students] PRIMARY KEY CLUSTERED ([Id] ASC),
 
    CONSTRAINT [FK_Students_Users]
        FOREIGN KEY ([UserId]) REFERENCES [dbo].[Users]([Id])
);
 
CREATE UNIQUE NONCLUSTERED INDEX [IX_Students_AM]
    ON [dbo].[Students]([AM] ASC);
 
CREATE UNIQUE NONCLUSTERED INDEX [IX_Students_UserId]
    ON [dbo].[Students]([UserId] ASC);
 
CREATE NONCLUSTERED INDEX [IX_Students_Institution]
    ON [dbo].[Students]([Institution] ASC);
 
-- ============================================
-- 7. COURSES
-- ============================================
CREATE TABLE [dbo].[Courses] (
    [Id]            INT             IDENTITY(1, 1) NOT NULL,
    [Description]   NVARCHAR(50)    NOT NULL,
    [TeacherId]     INT             NULL,
    CONSTRAINT [PK_Courses] PRIMARY KEY CLUSTERED ([Id] ASC),
 
    CONSTRAINT [FK_Courses_Teachers]
        FOREIGN KEY ([TeacherId]) REFERENCES [dbo].[Teachers]([Id])
);
 
CREATE NONCLUSTERED INDEX [IX_Courses_Description]
    ON [dbo].[Courses]([Description] ASC);
 
CREATE NONCLUSTERED INDEX [IX_Courses_TeacherId]
    ON [dbo].[Courses]([TeacherId] ASC);
 
-- ============================================
-- 8. COURSES_STUDENTS (Many-to-Many)
-- ============================================
CREATE TABLE [dbo].[CoursesStudents] (
    [CourseId]      INT NOT NULL,
    [StudentId]     INT NOT NULL,
    CONSTRAINT [PK_CoursesStudents] PRIMARY KEY CLUSTERED ([CourseId], [StudentId]),
 
    CONSTRAINT [FK_CoursesStudents_Courses]
        FOREIGN KEY ([CourseId]) REFERENCES [dbo].[Courses]([Id]),
 
    CONSTRAINT [FK_CoursesStudents_Students]
        FOREIGN KEY ([StudentId]) REFERENCES [dbo].[Students]([Id])
);
 
CREATE INDEX [IX_CoursesStudents_CourseId]
    ON [dbo].[CoursesStudents]([CourseId]);
 
CREATE INDEX [IX_CoursesStudents_StudentId]
    ON [dbo].[CoursesStudents]([StudentId]);