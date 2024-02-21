# CodeGen

I really like the concept of codegen, as it shortens the time to market significantly.
It provides a uniform approach to getting the basics of the application up and running, created by Microsoft professionals.
It also gives me a way to think into, how to boilerplate integrationtests for my API layer. And Dataaccess layer as well.

I've been playing around with automatic generation of code. It works surprisingly well. However, i found some curious caveats/errors, i document here, to make sure i can find the solution again, if i encounter the same problems in the future.

Obviously, it's the future. Codegen, that is. Just as automated setup of servers and infrastructure with puppet/salt/ansible is. 
All that's left to do, is to harness the power. Which i attempt, in the journey you are about to read, and the journey, I am about to write.

Also.. Rid yourself of the feeling, that this should be done in a hurry. Because if you do that, you will obtain control in trade. And to write proper software, control is essential. Mission Critical. There will be no good software, without a feel of complete control.
Take your time. Do the work. And in return, use the power of calm and time, to create an application that can withstand the test of time. Any adjustments made, should be "easystreet", with a foundation like this.

In order to give the reader a solid understanding of this topic, i feel like we have to start from the bottom/from scratch.
So i will briefly explain how the seeding of the database, the rest of this document is based on, looks. And how one could automate making it.

## Scaffolding a database(Seeding Database)
Now, this isn't exactly possible, as the creator needs to decide upon a design and put in data, before it can happen. So in essence, logically, we cannot scaffold/codegen from nothing. There has to be something.
But then let's automate the decisions and data decided upon in above process.
The process is called seeding, and is a very nice tool to have lying ready, when developing stuff.
Basically, what I've found is, if planned right, you can explode your database, wipe it completely, run the ReSeeding tool, and be left with a fully functional database, containing test data(the seeding part) once the tool is done running.
Yes, it takes time to write. But to me, it has been worth it.

I ended up writing SQL scripts for setting up the complete database, as i discovered that, when exporting the setup scripts, the database engine had made modifications to them. Which of course, it might have had its reasons for doing.
But i like to operate with original code(Funny, when we're talking about codegen, i know). It's a way to ensure i have ironclad control over the most crucial part of the flow. As well as making sure i understand any problems, from the initial creation, all the way to production.

### Steps in the process
Decide upon a database design, what columns you want, and which of them should have mapping tables, etc.
 - Then write an SQL script for each table, taking identities, primary keys, composite keys and foreign keys, into account.
   - Save each SQL script. I made a Powershell ReSeed tool, that can use these original scripts to rebuild the database, from the original scripts.
 - Then write stored procedures. These might be scaffoleded(automatically code generated) later. But they might also not. 
 - Then why bother? Because time to market for adding other software shortens significantly, if you have a bunch of procedures lying ready for you to modify, later on.
   - Yes, it's a "might need em, might not" situation. But hey, do it.
   - It'll help you run structured tests on your database later on as well.
   - Fun fact: While writing down this mindset, i googled SQL unit testing. And it turns out that the above, is an excellent starting point for unit testing. Another great reason to do it
 - Organize your scripts in a folder structure like the one provided below

### Building the SQL scripts

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


### Seeding & Re-Seeding

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
    $SQLPassword = 'MonkeyTonkeyLand?'
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



## Scaffolding code models(Database-first) - Entity Framework

What the scaffolding does, is to provide a database connection to your solution. And the elements you would need to interface with it.

It creates the following:
- DbContext(class)
 - This database connection is stored in a class named DbContext, which is a singleton(meaning there can only, and will only ever be a single instance of it, running at a given time). Multiple (different)database connections, warrants multiple dbContexts.
- Models(classes)
  - All the models you need to be able to call tables from your database and perform operations on them
- Consistency
  - It will do exactly the same each time, making your control "from scratch to product" a lot more significant.

> [!CAUTION]
> Every time you re-scaffold this, all custom code inside the relevant classes, will be wiped.  
> So take caution, and if you want to add custom functionality, make a seperate directory, and extend from the classes in question. Put your custom code in the extended classes.  
> Added win by doing this: Your code will abide to the Open/Close priciple in the S[O]LID best-practise methodology.  
> No takebacksies. Your progress will be lost if you re-scaffold.



### Mindset 

I feel like i should explain a bit about the mindset i had on the journey, and how it ended up changing. When being new to all of this, it's easy to think one is suposed to master it from the get-go. This is not the case.

Entity Framework has a pretty cool approach to codegen, when using the database-first approach.
At first, i believed that code-first would be essential for me. But i've come to the conclusion, that i like it better with database-first.  

The idea i had with code-first, was born out of a stubborn desire to be able to write code that interfaced perfectly well with the way Entity Framework works. And behaves.
But i would have to be an expert in Entity, in order to even grasp that. That dawned upon me after several trial and errors. I don't need to be an expert in every aspect of programming. Especially not when stuff starts to crash, with no easy ways to recover, when Entity makes changes to their framework.  

It's simple, almost trivial to me, to write and understand sql designs and scripts. So leaning upon that, would be the smartest play, for me. 😉 
Realizing ones strengths, and being able to determine the best pro's and cons for oneself, is pretty essential in development i think.

### Security notes on Entity Framework classes

Entity Framework, at the time of writing, includes these ways to interact with the database directly
- ``` DBSet.SqlQuery() ```
- ``` Database.SqlQuery() ``` 
- ``` Database.ExecuteSqlCommand() ```

If you can, avoid using them at all costs. Unless you really put in the work, to sanitize your SQL statements properly.
Use LINQ instead, and a lambda expression to filter.
An example of that could be:
``` var result = context.Users.Where(u => u.email == userEmail).ToList(); ```


### The actual scaffolding

Scaffolding a database-first entity collection, can be done by adding a nuget package, and firing a command. Yes. That simple.
The command is at the time of writing, in powershell syntax, as Visual Studio uses this per default, in the package manager CLI.

This is the command i used:
```powershell
    Scaffold-DbContext -connection 'Server=ASG-DB-01;Initial Catalog=Shoppinglist_app;Persist Security Info=False;User ID=sa;Password=MonkeyTonkeyLand?;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=True;Connection Timeout=30;' Microsoft.EntityFrameworkCore.SqlServer -OutputDir Models -ContextDir Contexts

```

Breaking it down, we see some recognizable elements:
- Scaffold-DbContext
  - This is the powershell commandlet, used to kick off an operation.
- -Connection &lt;ConnectionString&gt; Microsoft.EntityFrameworkCore.SqlServer
  - -Connection                              // This is just a named parameter that takes the following items as input
  - &lt;ConnectionString&gt;                       // this is a plain old SQL connection string -> If you don't understand these, it warrents a case study for you, to understand them.
  - Microsoft.EntityFrameworkCore.SqlServer  // This is the driver, entity should use to perform the operation
- OutputDir Models                         // This is where the entity framework model classes should end up, inside the solution. We tell it to create a folder named "Models", and put the output model classes, there.
- ContextDir Contexts                      // As with the previous flag, we tell Entity Framework, where to put the database context, generated by the scaffolding tool.

If the execution goes well, we end up with a nice collection of automatically generated entities:
![Scaffolded Entities example](../Images/Codegen/Scaffolded%20Entities.png)

Now THIS we can work with! 😁

Remember, don't ever change the name of the files or the classes. We need it to be as generic as possible, so the rest of the tooling explained in this document, works as expected.

Note: In order to use the entities, the program must know how to access the database. You tell it that, by injecting a dependency in the program.cs:
```

            // Inject the ShoppinglistAppContext into the dependency injection container
            builder.Services.AddDbContext<ShoppinglistAppContext>(options =>
            {
                options.UseSqlServer("Server=ASG-DB-01;Initial Catalog=Shoppinglist_app;Persist Security Info=False;User ID=sa;Password=MonkeyTonkeyLand?;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=True;Connection Timeout=30;");
            });

```

### Using the entities in action: Proper extension

As mentioned earlier, we have to extend the functionality provided by Entity Framework - not modify it.
The 'O' in SOLID, is the Open/Closed Principle: Open for extension, closed for modification. If we break - or ignore this, we will be in a world of trouble, if we blindly re-scaffold our entities, eventually follwing a database change.

We have to extend the models that are granted by the entity framework. And this is how we do that in practise. A flow for extension of a class from scratch, could look like this:
1. Created a folder in the project solution, named ExtendedClasses
2. Create a class file there, and use a naming convention for the naming. It's pretty straight-forward if you just name it ExtendedCategory for example. If the class you're extending is named "Category".
3. Create a class in the abovementioned file, that inherits "Category". Apply the functionality you want. I provided a "Wonky"-test in this example. Don't follow my lead on this particular implementation. Apply logic. 😉
4. Remember to add the ExtendedModels namespace, where you would normally add a "Models" namespace.
5. Now use the extended class where you would use the class normally.
6. You have achieved proper seperation of concerns, and are also now applying the Open/Close principle correctly. You need some practise to get to this point. Well done!
7. An added win to this, is that you can now write unit tests to the extended functionality you add. This is an awesome win!

You are now able to make whatever changes you want in your database table, and re-scaffold all your entities to infinity.  
There's no need to concern yourself with custom logic being overwritten. Because you seperated that concern, with this approach.

![Applying proper extension of entities](../Images/Codegen/Extending%20Entities%20in%20action.png)






## Scaffolding an API with CRUD operations, entirely from Entities created by Entity Framework

At the time of writing, Swagger has become a thing, and is a great help to observe proper creationg of API endpoints.
I recommend testing your results with Swagger, when using Codegen. You would be testing the code anyways, if you were not using Codegen.

There can be multiple approacesh to scaffolding basic CRUD API endpoints. I focused on learning two: 
- Manual
- CodeGen

### Manual API Codegen

### Automated API Codegen

I wrote a Powershell script to assist automating the manual process.  
In essence, it makes my recovery time, if i wreck the project, much shorter.  
The script basically loops through the Entity Framework generated models, and creates a set of CRUD endpoints, for each model.
The script looks like this:

```Powershell

    # Define the path to your project's root directory and DbContext name
    $projectPath = "G:\ShoppingAPI\ShoppingApp\ShoppingAPI\ShoppingAPI"
    $dbContextName = "ShoppingListAppContext"

    # Change to the project directory
    Set-Location $projectPath

    # Get all model files from the Models directory
    $modelFiles = Get-ChildItem -Path "$projectPath\Models" -Filter *.cs

    foreach ($file in $modelFiles) {
        # Extract the model class name from the file name (assuming class name matches file name without the extension)
        $modelName = $file.BaseName

        # Define the controller name
        $controllerName = $modelName + "Controller"

        # Run the scaffolding command
        dotnet aspnet-codegenerator controller -name $controllerName -async -api -m $modelName -dc $dbContextName -outDir Controllers
    }

```

>[!NOTE]
> Please read the below, before running your tests..

After running this, all my endpoints was created. However, there was an issue with the connection string. It would be inserted by Entity Framework in appsettings.json, and look like this:
```
{
  "Logging": {
    "LogLevel": {
      "Default": "Information",
      "Microsoft.AspNetCore": "Warning"
    }
  },
  "AllowedHosts": "*",
  "ConnectionStrings": {
    "ShoppingListAppContext": "Server=(localdb)\\mssqllocaldb;Database=ShoppingListAppContext-9f94d154-8291-4aea-9211-94e937ce7204;Trusted_Connection=True;MultipleActiveResultSets=true"
  }
}
```

Changing it, to look like this, enabled the API to get to the proper database:
```
{
  "Logging": {
    "LogLevel": {
      "Default": "Information",
      "Microsoft.AspNetCore": "Warning"
    }
  },
  "AllowedHosts": "*",
  "ConnectionStrings": {
    "ShoppingListAppContext": "Server=ASG-DB-01;Initial Catalog=Shoppinglist_app;Persist Security Info=False;User ID=sa;Password=MonkeyTonkeyLand?;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=True;Connection Timeout=30;"
  }
}

```

Not understanding why entity framework creates a connection string like that, warrants a case study on the DBContext creation process.

# Errors encountered on my way




## Could not get the reflection type for DbContext

### Symptoms
Added a scaffolded endpoint based on an Entity class worked great. The first time.
But all subsequent tries to add more endpoints based on other classes, yielded in the same error:

>[!CAUTION]  
>---------------------------  
>Microsoft Visual Studio  
>---------------------------  
>Error  
>  
>There was an error running the selected code generator:  
>  
>'Could not get the reflection type for DbContext : ShoppingAPI.Contexts.ShoppinglistAppContext'  
>---------------------------  
>OK  
>---------------------------


### Description
This was quite troublesome, and caused me to wipe my project and start over.
Nothing i did worked, nor a complete wipe of the project and rebuilding.

The problem turned out to be in the dependencies and their framework targets.
I were, at the time, using dependencies targetted at the framework .NET 8.1.

What ultimately solved the issue, was to yet again, start a project from scratch, but this time set target framework to .NET 7.0. Then i got the dependencies for .NET 7.0 as well, made sure all version numbers matched, and lo-and-behold - the error was gone.

Without diving further into it, i did notice that all my dependencies except the codegen, was targetted 8.1.
The codegen dependency itself, was targetted 8.0. There had not been released a 8.1 at the time.

### Framework and dependency configuration at the time of error

This composition did not work, despite being newer:

![Broken composition](../Images/Codegen/Framework%20and%20dependency%20composition%20that's%20not%20working.png)

### What solved the problem - Older framework composition
This composition worked great:

![Working composition](../Images/Codegen/Framework%20and%20dependency%20composition%20that%20IS%20working.png)


### Later comment
At the time of writing, i've found that my original assumption about the degrading of versions might have fixed the error, seems wrong.
As i am now able to create a complete project, with the same versions, with no issues.