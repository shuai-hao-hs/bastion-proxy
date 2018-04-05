#!/bin/bash

echo "This will set the passwords for the MySQL and ProxySQL user accounts that will be used to syncronizes accounts"
echo ""
echo -n "Please enter ProxySQL admin password : "
read -s PROXY_ADMIN_PASS
echo ""
echo -n "Please enter ProxySQL remote admin password : "
read -s PROXY_REMOTE_PASS
echo ""


echo ""
echo "Configuring ProxySQL Local and Remote Admin passwords"
docker exec -it proxysql mysql -u admin -padmin -h 127.0.0.1 -P6032 -e "UPDATE global_variables SET variable_value='admin:$PROXY_ADMIN_PASS;radminuser:$PROXY_REMOTE_PASS' WHERE variable_name='admin-admin_credentials';"
docker exec -it proxysql mysql -u admin -padmin -h 127.0.0.1 -P6032 -e "LOAD ADMIN VARIABLES TO RUNTIME;SAVE ADMIN VARIABLES TO DISK;"


echo ""
echo "  You should now be able to login to Proxy SQL with the following command and your password: "
echo ""
echo "    mysql -h proxysql -P6032 -u radminuser -p"
echo ""
echo "  Next you need to configure your encrypt secure credential files with the following two commands and the passwords you configured above: "
echo ""
echo "    mysql_config_editor set --login-path=mysql --host=<MYSQL_BASTION_RDS_CLUSTER_ENDPOINT> --user=bastion_sync --password *Find the password in LastPass"
echo "    mysql_config_editor set --login-path=proxysql --host=proxysql --port=6032 --user=radminuser --password"
echo ""
echo "  Once those are configured you should now be able to login with the following commands"
echo ""
echo "   mysql --login-path=mysql"
echo "   mysql --login-path=proxysql"
echo ""
