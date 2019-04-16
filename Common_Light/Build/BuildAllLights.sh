#!/bin/bash
#Usage below
#    1. make sure that environment Path variable must contain C:\NXP\bstudio_nxp\msys\bin in the beginning!
echo "Building Lights from JN-AN-1171"

start=$(date +"%T")
echo "Start Time : $start"
    
make JENNIC_SDK=JN-SW-4168 JENNIC_CHIP=JN5168 LIGHT=Light_ColorLight clean >> BuildLog_Light_ColorLight_JN5168.txt &
echo "Cleaning; Please wait"
wait

make JENNIC_SDK=JN-SW-4168 JENNIC_CHIP=JN5168 LIGHT=Light_ColorLight RGB=1 OTA=0 DR=JN516X_RGB >> BuildLog_Light_ColorLight_JN5168.txt &
echo "Building; Please wait"
wait

end=$(date +"%T")
echo "End Time : $end"

echo "Done !!!"
