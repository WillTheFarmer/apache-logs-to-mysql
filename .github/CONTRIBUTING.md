To contribute Apache Access or Log formats commonly used that application is not setup for please create a `New issue` under repository `Issues` tab.

To contribute ideas or comments please create a `New discussion` under repository `Discussions` tab.

Any organizations, people or person with multiple Apache servers that find application a godsend in log collection monetary contributions are appreciated. Repository has my ***Buy Me a Coffee*** & ***Venmo*** links.

I volunteer for a nonprofit organization that wanted to import their Apache website logs into MySQL tables to query data. The Executive Director loves MySQL so I decided to research existing solutions that used MySQL. I thought it would be two or three days of my time. 

First I installed the Apache log_sql_mysql modules which did create a single MySQL mostly empty table of the access log with no control or customization and many other issues. Next I experimented with several simple log file parsers but none normalized the parsed log data into a MySQL database. Finally I reviewed other available Apache logging solutions that didn't use MySQL including GoAccess, Logstash, Apache Viewer, DataDog and others as well as CrowdStrike and Solarwinds Loggly.

Mid-September 2024 after all my research I decided to write a simple solution which snowballed into a complete application. All October I worked long hours around the clock. November I spent incorporating the application into VPS websites and applications I oversee while making improvements along the way. Version 2.0.0 fixed the major issues encountered and is the application baseline. December I spent refining the major changes made in Version 2.0.0. Version 2.1.5 was last code change to fix client identification issue when OS version changes by adding `import_device` TABLE. The first week of January 2025 I spent processing millions of records from 10 VPS simultaneously to single MySQL Server.

Version 2.1.6 renames the repository, the 2 Python modules files and the MySQL schema creation script file. This version of application is production ready.

That's how volunteering, lack of a viable MySQL solution and a flexible schedule came together just right to allow me to dive deep into this project.

### “Timing, degree and conviction are the three wise men in this life.” — Robert I. Fitzhenry

The final version is less Python and more SQL and much faster processing millions of records. At this point, I have over 950 hours of research, design, iteration & development into application. It is much more time then I intended to invest into this project but it did produce my first open-source software.

Any monetary contributions made will be reflected in additional repository development projects, feeding cows :cow: and fixing :wrench: farm equipment :tractor:.