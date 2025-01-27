To contribute any Issues or Errors found using application please create a `New issue` under repository `Issues` tab.

To contribute Ideas or Comments please create a `New discussion` under repository `Discussions` tab.

To contribute Apache Access or Error Log Formats commonly used that application should process please start `New discussion` about that.

Any organizations, people or person with multiple Apache servers that find application a godsend in log collection monetary contributions are appreciated. Repository has my ***Buy Me a Coffee*** & ***Venmo*** links.

I volunteer for a nonprofit organization that wanted to import their Apache website logs into MySQL tables to query data. The Executive Director loves MySQL so I decided to research existing solutions that used MySQL. I thought it would be two or three days of my time. 

First I installed the Apache log_sql_mysql modules which did create a single MySQL mostly empty table of the access log with no control or customization and many other issues. Next I experimented with several simple log file parsers but none normalized the parsed log data into a MySQL database. Finally I reviewed other available Apache logging solutions that didn't use MySQL including GoAccess, Logstash, Apache Viewer, DataDog and others as well as CrowdStrike and Solarwinds Loggly.

Mid-September 2024 after all my research I decided to write a simple solution which snowballed into a complete application. All October I worked long hours around the clock. November I spent incorporating the application into VPS websites and applications I oversee while making improvements along the way. Version 2.0.0 fixed the major issues encountered and is the application baseline. December I spent refining the major changes made in Version 2.0.0. Version 2.1.5 was last code change to fix client identification issue when OS version changes by adding `import_device` TABLE.

First 2 weeks of January 2025 I spent processing millions of records from 10 VPS simultaneously to single MySQL Server. Version 3.0.0 is last major change with IP Address geoLocation and a final pass through to fine tune processes and rename some tables and columns. This version of application is production ready.

The final version is less Python and more SQL and much faster processing millions of records. At this point, I have over 1050 hours of research, design, iteration & development into application. It is much more time then I intended to invest into this project but it did produce my first open-source software.

That's how volunteering, lack of a viable MySQL solution and a flexible schedule came together just right to allow me to dive deep into this project.

### “Timing, degree and conviction are the three wise men in this life.” — Robert I. Fitzhenry

Monetary contributions made will be reflected in development of [Web Interface](https://github.com/WillTheFarmer/mysql-to-apache-echarts) for this MySQL `apache_logs` schema.