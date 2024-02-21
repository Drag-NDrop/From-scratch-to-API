use [master];
ALTER DATABASE [Shoppinglist_app_ORM_demo] SET OFFLINE WITH ROLLBACK IMMEDIATE;
ALTER DATABASE [Shoppinglist_app_ORM_demo] SET ONLINE;
DROP DATABASE [Shoppinglist_app_ORM_demo];