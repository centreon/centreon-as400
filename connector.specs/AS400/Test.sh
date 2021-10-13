BIN=/usr/lib64/nagios/plugins/operatingsystems-as400/check_centreon_as400_generic
CONNECTOR=10.40.1.34:8091

AS400=XXX.XXX.XXX.XXX
LOGIN=XXXXXXXX
PASSWORD=XXXXXXXX

##############################################################################
echo ---- cpuUsage ----
$BIN -C $CONNECTOR -H $AS400 -U $LOGIN -P $PASSWORD -c cpuUsage -A 80\!90

echo ---- asp1Usage ----
$BIN -C $CONNECTOR -H $AS400 -U $LOGIN -P $PASSWORD -c asp1Usage -A 80\!90

echo ---- diskState ----
$BIN -C $CONNECTOR -H $AS400 -U $LOGIN -P $PASSWORD -c diskState

echo ---- diskUsage ----
$BIN -C $CONNECTOR -H $AS400 -U $LOGIN -P $PASSWORD -c diskUsage -A DD003\!80\!90

echo ---- diskUsageRepartition ----
$BIN -C $CONNECTOR -H $AS400 -U $LOGIN -P $PASSWORD -c diskUsageRepartition -A 0.5\!2

echo ---- subSystemExist ----
$BIN -C $CONNECTOR -H $AS400 -U $LOGIN -P $PASSWORD -c subSystemExist -A QBATCH\!QSYS.LIB

echo ---- jobExist ----
$BIN -C $CONNECTOR -H $AS400 -U $LOGIN -P $PASSWORD -c jobExist -A QCTL\!QBASE

echo ---- jobHasNoMsgw ----
$BIN -C $CONNECTOR -H $AS400 -U $LOGIN -P $PASSWORD -c jobHasNoMsgw -A QCTL\!QBASE

echo ---- messageQueueSize ----
$BIN -C $CONNECTOR -H $AS400 -U $LOGIN -P $PASSWORD -c messageQueueSize -A /QSYS.LIB/QSYSOPR.MSGQ\!40\!2000\!2500

echo ---- pageFault ----
$BIN -C $CONNECTOR -H $AS400 -U $LOGIN -P $PASSWORD -c pageFault -A 50\!70

echo ---- jobQueueStatus ----
$BIN -C $CONNECTOR -H $AS400 -U $LOGIN -P $PASSWORD -c jobQueueStatus -A QSYSNOMAX\!QSYS

echo ---- jobQueueWaitJobCount ----
$BIN -C $CONNECTOR -H $AS400 -U $LOGIN -P $PASSWORD -c jobQueueWaitJobCount -A QSYSNOMAX\!QSYS\!1\!2
	
echo ---- messageQueueSizeFiltered ----
$BIN -C $CONNECTOR -H $AS400 -U $LOGIN -P $PASSWORD -c messageQueueSizeFiltered -A /QSYS.LIB/QSYSOPR.MSGQ\!CP.*\!60\!80\!1\!2

echo ---- allJobHaveNoMsgWInSubSystem ----
$BIN -C $CONNECTOR -H $AS400 -U $LOGIN -P $PASSWORD -c allJobHaveNoMsgWInSubSystem -A QBATCH\!1\!2

echo ---- specificJobRunningInSubSystem ----
$BIN -C $CONNECTOR -H $AS400 -U $LOGIN -P $PASSWORD -c specificJobRunningInSubSystem -A .*\!QSYSNOMAX\!5\!10\!1\!15

echo ---- specificJobInSubSystem ----
$BIN -C $CONNECTOR -H $AS400 -U $LOGIN -P $PASSWORD -c specificJobInSubSystem -A .*\!QSYSNOMAX\!*ANY\!ANY\!5\!10\!1\!15