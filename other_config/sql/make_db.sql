create user contest;

create database contest_dev;
create database contest_test;
create database contest_pro;

grant all privileges on contest_dev.* to 'contest'@'localhost' identified by 'testcon';
grant all privileges on contest_test.* to 'contest'@'localhost' identified by 'testcon';
grant all privileges on contest_pro.* to 'contest'@'localhost' identified by 'testcon';

