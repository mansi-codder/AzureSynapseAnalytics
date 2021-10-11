-- Lab - SQL Pool - External Tables - CSV

CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'P@ssw0rd@123';

-- Here we are using the Storage account key for authorization

CREATE DATABASE SCOPED CREDENTIAL AzureStorageCredential
WITH IDENTITY = 'tenoctaccount',
  SECRET = '30gHcZuxSXMlAhDHGJK2b22Zhb0Jsb2wlxH628iNak2cTpvH0u9ZAN1xp5WJ5r414CONYkD4mbrLrx+go8gckQ==';


-- In the SQL pool, we can use Hadoop drivers to mention the source

CREATE EXTERNAL DATA SOURCE log_data_new
WITH (    LOCATION   = 'abfss://data@tenoctaccount.dfs.core.windows.net',
          CREDENTIAL = AzureStorageCredential,
          TYPE = HADOOP
)

CREATE EXTERNAL FILE FORMAT TextFileFormat WITH (  
      FORMAT_TYPE = DELIMITEDTEXT,  
    FORMAT_OPTIONS (  
        FIELD_TERMINATOR = ',',
        FIRST_ROW = 2))


CREATE EXTERNAL TABLE [logdatacleared]
(
    [Id] [int],
	[Correlationid] [varchar](200),
	[Operationname] [varchar](200) ,
	[Status] [varchar](100) ,
	[Eventcategory] [varchar](100) ,
	[Level] [varchar](100) ,
	[Time] [datetime] ,
	[Subscription] [varchar](200) ,
	[Eventinitiatedby] [varchar](1000) ,
	[Resourcetype] [varchar](1000) ,
	[Resourcegroup] [varchar](1000) 
)
WITH (
 LOCATION = '/cleared/Log.csv',
    DATA_SOURCE = log_data_new,  
    FILE_FORMAT = TextFileFormat
)



SELECT * FROM logdatacleared


SELECT [Operation name] , COUNT([Operation name]) as [Operation Count]
FROM logdata
GROUP BY [Operation name]
ORDER BY [Operation Count]