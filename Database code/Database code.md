# Fair warning

The package you're browsing was made as a proof of concept, for a demonstration in class.
The database code directory, just contains an old copy of a hobby project, to demonstrate the deployment process in CodeGen.

Which is why you would have to manually go through the rather large collection of sql scripts, and adjust the
```sql
USE Shoppinglist_app_ORM_demo;
```

To something a bit more regconizable.

The original documentation from the Database ReSeed project, below:

# Scaffolding a database(Seeding Database)
Now, this isn't exactly possible, as the creator needs to decide upon a design and put in data, before it can happen. So in essence, logically, we cannot scaffold/codegen from nothing. There has to be something.
But then let's automate the decisions and data decided upon in above process.
The process is called seeding, and is a very nice tool to have lying ready, when developing stuff.
Basically, what I've found is, if planned right, you can explode your database, wipe it completely, run the ReSeeding tool, and be left with a fully functional database, containing test data(the seeding part) once the tool is done running.
Yes, it takes time to write. But to me, it has been worth it.

I ended up writing SQL scripts for setting up the complete database, as i discovered that, when exporting the setup scripts, the database engine had made modifications to them. Which of course, it might have had its reasons for doing.
But i like to operate with original code(Funny, when we're talking about codegen, i know). It's a way to ensure i have ironclad control over the most crucial part of the flow. As well as making sure i understand any problems, from the initial creation, all the way to production.

## Steps in the process
Decide upon a database design, what columns you want, and which of them should have mapping tables, etc.
 - Then write an SQL script for each table, taking identities, primary keys, composite keys and foreign keys, into account.
   - Save each SQL script. I made a Powershell ReSeed tool, that can use these original scripts to rebuild the database, from the original scripts.
 - Then write stored procedures. These might be scaffoleded(automatically code generated) later. But they might also not. 
 - Then why bother? Because time to market for adding other software shortens significantly, if you have a bunch of procedures lying ready for you to modify, later on.
   - Yes, it's a "might need em, might not" situation. But hey, do it.
   - It'll help you run structured tests on your database later on as well.
   - Fun fact: While writing down this mindset, i googled SQL unit testing. And it turns out that the above, is an excellent starting point for unit testing. Another great reason to do it
 - Organize your scripts in a folder structure like the one provided below

## Building the SQL scripts

```

G:\SHOPPINGAPI\SHOPPINGAPP\DATABASE CODE
├───Build -> Contains the build code, e.g. CREATE DATABASE. As well as the create table .sql scripts. Do it proper, and segmented. One sql script per table.
├───DataInsert -> Contains the Dummy data you want to insert after your database was wiped. .sql scripts
├───Procedures -> Contains your stored procedures, in my case, the CRUD operations(except delete), kept in .sql script format
│   ├───Create -> 
│   ├───Read   -> 
│   └───Update
├───Remove     -> Contains the scripts to remove the entire database, effectively creating a clean slate.
└───Views      -> Contains the views you would want for your application. Also in sql script format.

```


At the time of writing this, my folder looked like this:

```

PS G:\ShoppingAPI\ShoppingApp\Database code> tree /F .
Folder PATH listing for volume Projects
Volume serial number is 00007FF9 2003:4D3B
G:\SHOPPINGAPI\SHOPPINGAPP\DATABASE CODE
│   Notesheet.sql
│   ReSeed.ps1
│
├───Build
│       CreateDB.sql
│       CreateDBLog.txt
│       CreateTables.sql
│       CreateTablesLog.txt
│
├───DataInsert
│       InsertCategories.sql
│       InsertCategoriesLog.txt
│       InsertUnitTypes.sql
│       InsertUnitTypesLog.txt
│
├───Procedures
│   ├───Create
│   │       Create_Category.sql
│   │       Create_CategoryLog.txt
│   │       Create_Product.sql
│   │       Create_ProductCategoryMap.sql
│   │       Create_ProductCategoryMapLog.txt
│   │       Create_ProductLog.txt
│   │       Create_Shoppinglist.sql
│   │       Create_ShoppingListItem.sql
│   │       Create_ShoppingListItemLog.txt
│   │       Create_ShoppinglistLog.txt
│   │       Create_UnitType.sql
│   │       Create_UnitTypeLog.txt
│   │       Create_Vendor.sql
│   │       Create_VendorLog.txt
│   │       Create_VendorProductPriceMapping.sql
│   │       Create_VendorProductPriceMappingLog.txt
│   │
│   ├───Read
│   │       Read_AllCategories.sql
│   │       Read_AllCategoriesLog.txt
│   │       Read_AllProducts.sql
│   │       Read_AllProductsLog.txt
│   │       Read_AllUnitTypes.sql
│   │       Read_AllUnitTypesLog.txt
│   │       Read_AllVendors.sql
│   │       Read_AllVendorsLog.txt
│   │       Read_ProductsByCategoryID.sql
│   │       Read_ProductsByCategoryIDLog.txt
│   │       Read_ProductsByVendorID.sql
│   │       Read_ProductsByVendorIDLog.txt
│   │       Read_ShoppingListLinesByActiveWeekAndYear.sql
│   │       Read_ShoppingListLinesByActiveWeekAndYearLog.txt
│   │       Read_ShoppingListLinesByShoppingListID.sql
│   │       Read_ShoppingListLinesByShoppingListIDLog.txt
│   │
│   └───Update
│           Update_DiscountclubStatusByVendorID.sql
│           Update_DiscountclubStatusByVendorIDLog.txt
│           Update_FulfilledStatusByShoppingItemLineID.sql
│           Update_FulfilledStatusByShoppingItemLineIDLog.txt
│           Update_OfferPriceAndOnOfferStatusInVendorProductPriceMapByID.sql
│           Update_OfferPriceAndOnOfferStatusInVendorProductPriceMapByIDLog.txt
│           Update_PriceInVendorProductPriceMapByID.sql
│           Update_PriceInVendorProductPriceMapByIDLog.txt
│           Update_ProductDescriptionByProductID.sql
│           Update_ProductDescriptionByProductIDLog.txt
│           Update_ProductMakerByProductID.sql
│           Update_ProductMakerByProductIDLog.txt
│           Update_ProductNameByProductID.sql
│           Update_ProductNameByProductIDLog.txt
│           Update_QuantityInShoppingItemLineByID.sql
│           Update_QuantityInShoppingItemLineByIDLog.txt
│           Update_StoreboxStatusByVendorID.sql
│           Update_StoreboxStatusByVendorIDLog.txt
│           Update_VendorNameByVendorID.sql
│           Update_VendorNameByVendorIDLog.txt
│
├───Remove
│       DeleteAllTables.sql
│       DeleteAllTablesLog.txt
│       DeleteDatabase.sql
│       DeleteDatabaseLog.txt
│
├───Retired Tooling
│       SqlBatchRebuilderScripts.bat
│       SqlBatchRebuilderScripts.bat.lnk
│
└───Views
        View_ShoppingListLines.sql
        View_ShoppingListLinesLog.txt


```

Having this in place, you would just need to run the reseed tool from the "Database code" folder.
Notice all the ".log" files. The reseeder creates that on its own. 


## Seeding & Re-Seeding

At the time of writing, my reseeding procedure is what one might call "tried and true". I've used .bat scripts for a while, but a few days ago(07-02-2024), i've transitioned to a more elegant Powershell script of my own design.
It takes each folder, in the structure mentioned, and runs the contained scripts one by one. Waiting for a response, writing to the log file. It takes a bit of time. But it feels good to know that it gets done properly.

Remember, before running the ReSeeder, you should be completely disconnected from the database. That includes your database manager software.

At the time of writing, the reseeder looks like this:

```powershell

    # Define SQL connection variables
    Set-Location 'G:\ShoppingAPI\ShoppingApp\Database code'

    $SQLServer = 'ASG-DB-01'
    $SQLInstance = 'MSSQLSERVER'
    $SQLUser = 'sa'
    $SQLPassword = 'Temp1234!!'
    $BaseDirectory = 'G:\ShoppingAPI\ShoppingApp\Database code'



    # Execute sqlcmd using Start-Process


    # Function to execute SQL commands with error handling
    function Invoke-SqlCommand {
        param(
            [string]$Server,
            [string]$ServerInstance,
            [string]$Database,
            [string]$Username,
            [string]$Password,
            [string]$InputFile,
            [string]$OutputFile
        )
        
        try {
    # Prepare arguments for Start-Process
            $arguments = @(
                "-S", "$Server",
                "-d", $Database,
                "-U", $Username,
                "-P", $Password,
                "-i", "`"$InputFile`"",
                "-o", "`"$OutputFile`""
            )
            try{
                Start-Process "sqlcmd.exe" -ArgumentList $arguments -NoNewWindow -Wait -PassThru
            }
            catch{
                Write-Host "Error: $_"
            }
            
            if ($LASTEXITCODE -ne 0) {
                throw "SQL command execution failed with error level $LASTEXITCODE."
            }
        } catch {
            Write-Error "An error occurred: $_"
            Pause # Pause if there's an error
            exit
        }
    }

    # Function to run all SQL scripts in a folder (and its subfolders)
    function Run-SqlScriptsInFolder {
        param(
            [string]$FolderPath,
            [string]$Database
        )

        $sqlFiles = Get-ChildItem -Path $FolderPath -Recurse -Filter *.sql
        foreach ($file in $sqlFiles) {
            $inputPath = $file.FullName
            $outputPath = $file.FullName.Replace(".sql", "Log.txt")
            Write-Host "Executing $inputPath..."
            Invoke-SqlCommand -Server $SQLServer -ServerInstance $SQLInstance -Database $Database -Username $SQLUser -Password $SQLPassword -InputFile $inputPath -OutputFile $outputPath
        }
    }

    # Directory paths to process
    # Notice the order. The order is important.
    $directoriesToProcess = @("Remove", "Build", "Procedures\Create", "Procedures\Read", "Procedures\Update", "Views", "DataInsert")

    foreach ($directory in $directoriesToProcess) {
        $fullPath = Join-Path -Path $BaseDirectory -ChildPath $directory
        # Extra guardrail, to ensure proper execution
        if ($directory -eq "Remove" -or $directory -eq "Build" -or $directory -eq "Rebuild") {
            $db = "Master" # Assuming master database for these operations
        } else {
            $db = "Shoppinglist_app" # Change to your database name as needed
        }
        Run-SqlScriptsInFolder -FolderPath $fullPath -Database $db
    }

    Write-Host "All SQL scripts have been executed."

```

Now, i know that I still have have some hardcoded values, and this is not a nice, reuseable piece of scriptcode, yet.
But I'm okay with that. I did not write the script for the world. I wrote it for me. I wrote it before i knew that this concept were known as seeding/re-seeding.

When i feel like it, i want to create another script, that collects the logs from each folder, and displays them in a structured manner, for the operator. Overview is key, and should never be hard to achieve. Once the system's done. Of course.

In the context of my personal app, running the reseeder tool, now gets the job done. It completely destroys my existing database, and sets up a new, working copy.
This could be used for:
- Developing the database further
- Testing crash scenarios
- Automated testing from scratch to product
- Scaling out easily. In case customers would ever be interested.
- Writing code to interact with the database. Writing code that fucks something up in the database to.
  - The re-seeder enables me to recover in less than 5 minutes.

These gains are quite significant.

Now, with this marking a pre-requisite and establishing a context - we can finally get into the actual CodeGen/Scaffolding, that this topic is all about.
