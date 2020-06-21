CURRENT_SCRIPT=$0
echo $0
MORGANA_HOME=$(dirname $CURRENT_SCRIPT)
MORGANA_LIB=$MORGANA_HOME/MorganaXProc-IIIse_lib
java -jar -javaagent:$MORGANA_LIB/quasar-core-0.7.9.jar $MORGANA_HOME/MorganaXProc-IIIse.jar $@
