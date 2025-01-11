To contribute Apache Access or Log formats commonly used that application is not setup for please email farmfreshsoftware@gmail.com with subject <sup>Additional Import Formats</sup> and I'll consider incorporating the format.

To contribute ideas or comments email farmfreshsoftware@gmail.com with subject <sup>ideas or comments</sup> and I'll be sure to reply.

Any organizations, people or person with multiple Apache servers that find application to be a godsend in log collection financial contributions are appreciated. Repository has my ***Buy Me a Coffee*** & ***Venmo*** links.

I volunteer for a nonprofit organization that wanted a solution to import Apache logs into MySQL. The Executive Director loves MySQL so I decided to investigate existing solutions that used MySQL. At that point, I thought it would be day or two of my time. 

First I installed the Apache log_sql_mysql modules which did create a single MySQL mostly empty table of the access log with no control or customization and many other issues. Next I experimented with several simple log file parsers but none normalized the parsed log data into a MySQL database. Finally I reviewed other available Apache logging solutions that didn't use MySQL including GoAccess, Logstash, Apache Viewer, DataDog and others as well as CrowdStrike and Solarwinds Loggly.

After all my research I decided to write a simple solution which snowballed into a complete application.

That's how volunteering, lack of a viable MySQL solution and a flexible schedule came together just right to allow me to dive deep into this project.

### “Timing, degree and conviction are the three wise men in this life.” — Robert I. Fitzhenry

November 2024 I spent incorporating the application into VPS websites and applications I oversee while making improvements along the way. Version 2.0.0 fixes all the major issues encountered and is the application baseline. Version 2.1.6 fixes client identification issue with OS version change.

The final version is less Python and more SQL and much faster processing 3 million of records. At this point, I have over 950 hours of research, design, iteration & development into application. During October 2024 I worked long hours around the clock. It is way more time then I intended to invest into this project but it did produce my first open-source software.

Any contributions made will be reflected in additional repository development projects, feeding cows :cow: and fixing :wrench: farm equipment :tractor:.