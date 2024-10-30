# Security Policy
Important to understand the client module of this application can be run on multiple computers in multiple locations uploading to a single server module of the application.
It is extremely important to maintain control of server user accounts and IP addresses the accounts can connect to the server from.

Information below is from link. Please visit for more information: https://dev.mysql.com/doc/refman/8.0/en/load-data-local-security.html

8.1.6 Security Considerations for LOAD DATA LOCAL
The LOAD DATA statement loads a data file into a table. The statement can load a file located on the server host, or, if the LOCAL keyword is specified, on the client host.

The LOCAL version of LOAD DATA has two potential security issues:

Because LOAD DATA LOCAL is an SQL statement, parsing occurs on the server side, and transfer of the file from the client host to the server host is initiated by the MySQL server, which tells the client the file named in the statement. In theory, a patched server could tell the client program to transfer a file of the server's choosing rather than the file named in the statement. Such a server could access any file on the client host to which the client user has read access. (A patched server could in fact reply with a file-transfer request to any statement, not just LOAD DATA LOCAL, so a more fundamental issue is that clients should not connect to untrusted servers.)

In a Web environment where the clients are connecting from a Web server, a user could use LOAD DATA LOCAL to read any files that the Web server process has read access to (assuming that a user could run any statement against the SQL server). In this environment, the client with respect to the MySQL server actually is the Web server, not a remote program being run by users who connect to the Web server.

To avoid connecting to untrusted servers, clients can establish a secure connection and verify the server identity by connecting using the --ssl-mode=VERIFY_IDENTITY option and the appropriate CA certificate. To implement this level of verification, you must first ensure that the CA certificate for the server is reliably available to the replica, otherwise availability issues will result. For more information, see Command Options for Encrypted Connections.

To avoid LOAD DATA issues, clients should avoid using LOCAL unless proper client-side precautions have been taken.

For control over local data loading, MySQL permits the capability to be enabled or disabled. In addition, as of MySQL 8.0.21, MySQL enables clients to restrict local data loading operations to files located in a designated directory.

## Supported Versions

This is the initial release of this application and requires local-infile=1 to be set on the server. Only only version currently available is listed below.

| Version | Supported          |
| ------- | ------------------ |
| 1.0.0   | :white_check_mark: |

## Reporting a Vulnerability
The following is directly from link above. If have concerns or wish to report any vulnerbilities with application email farmfreshsoftware@gmail.com or open issue on repository.

Enabling or Disabling Local Data Loading Capability
Administrators and applications can configure whether to permit local data loading as follows:

On the server side:

The local_infile system variable controls server-side LOCAL capability. Depending on the local_infile setting, the server refuses or permits local data loading by clients that request local data loading.

By default, local_infile is disabled. (This is a change from previous versions of MySQL.) To cause the server to refuse or permit LOAD DATA LOCAL statements explicitly (regardless of how client programs and libraries are configured at build time or runtime), start mysqld with local_infile disabled or enabled. local_infile can also be set at runtime.

On the client side:

The ENABLED_LOCAL_INFILE CMake option controls the compiled-in default LOCAL capability for the MySQL client library (see Section 2.8.7, “MySQL Source-Configuration Options”). Clients that make no explicit arrangements therefore have LOCAL capability disabled or enabled according to the ENABLED_LOCAL_INFILE setting specified at MySQL build time.

By default, the client library in MySQL binary distributions is compiled with ENABLED_LOCAL_INFILE disabled. If you compile MySQL from source, configure it with ENABLED_LOCAL_INFILE disabled or enabled based on whether clients that make no explicit arrangements should have LOCAL capability disabled or enabled.

For client programs that use the C API, local data loading capability is determined by the default compiled into the MySQL client library. To enable or disable it explicitly, invoke the mysql_options() C API function to disable or enable the MYSQL_OPT_LOCAL_INFILE option. See mysql_options().

For the mysql client, local data loading capability is determined by the default compiled into the MySQL client library. To disable or enable it explicitly, use the --local-infile=0 or --local-infile[=1] option.

For the mysqlimport client, local data loading is not used by default. To disable or enable it explicitly, use the --local=0 or --local[=1] option.

If you use LOAD DATA LOCAL in Perl scripts or other programs that read the [client] group from option files, you can add a local-infile option setting to that group. To prevent problems for programs that do not understand this option, specify it using the loose- prefix:

[client]
loose-local-infile=0
or:

[client]
loose-local-infile=1
In all cases, successful use of a LOCAL load operation by a client also requires that the server permits local loading.

If LOCAL capability is disabled, on either the server or client side, a client that attempts to issue a LOAD DATA LOCAL statement receives the following error message:

ERROR 3950 (42000): Loading local data is disabled; this must be
enabled on both the client and server side
