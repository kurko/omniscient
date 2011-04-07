Omniscient is a gem that automatically dumps a MySQL database in a remote server
via SSH, copies the dumped file to localhost via SCP and imports it, overwriting the local
database (or table).

It'll be very useful for those that are developing using more than one machine and
don't want to dump and clone data manually all the time.

Getting Started
===============

In your console, type the following, where aliasname is a name you choose
(i.e. home_computer, work etc):

$ omniscient clone aliasname

A setup will begin. The data will be save to ~/.omni_config.yml

Now that Omniscient knows where to connect, run the following command again

$ omniscient clone aliasname

You can clone a 'custom_dbname' database from that host.

$ omniscient clone aliasname -d custom_dbname

Troubleshoting
==============

Tested on Mac OS X.

Credits
=======

Alexandre de Oliveira