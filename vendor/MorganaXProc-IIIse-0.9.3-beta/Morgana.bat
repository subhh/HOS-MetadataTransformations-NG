@echo off
setlocal
set MORGANADIR=%~dp0
java -jar -javaagent:"%MORGANADIR%MorganaXProc-IIIse_lib\quasar-core-0.7.9.jar" "%MORGANADIR%MorganaXProc-IIIse.jar" %*