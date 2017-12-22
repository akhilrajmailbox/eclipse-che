#!/bin/bash
## User's home folder should be configured with .m2 folder for maven
DEST=/home/akhil/Desktop



  if [ -e "$HOME/.m2/settings.xml" ]; then
echo "found maven settings file under $HOME/.m2 "



   if [ -d "$DEST" ]; then
echo "folder exist $DEST"
   else
echo "folder $DEST doesn't exist"
   read -p 'Do You Want to create the folder, Press Y or N: ' INFO

   until [[ $INFO = [Y,N] ]];do
echo "WARNING"
echo "Press Y or N"
   read INFO
   done

     if [[ $INFO = "Y" ]] ; then
echo "creating $DEST"
mkdir -p $DEST
     fi
   fi



cd $DEST
git clone https://github.com/eclipse/che.git
cd che
git checkout tags/5.22.0
cd ..

read -p 'Start assembly build, Press Y or N: ' INFO1
until [[ $INFO1 = [Y,N] ]];do
echo "WARNING"
echo "Press Y or N"
read INFO1
done


if [[ $INFO1 = "Y" ]] ; then
docker run -it --rm --name build-che \
           -v "$HOME/.m2:/home/user/.m2" \
           -v "$DEST/che:/home/user/che-build" \
           -v /var/run/docker.sock:/var/run/docker.sock \
           -w /home/user/che-build/assembly/assembly-main eclipse/che-dev \
           mvn clean install
fi

sleep 10



read -p 'Start Che and all submodules build, Press Y or N: ' INFO2
until [[ $INFO2 = [Y,N] ]];do
echo "WARNING"
echo "Press Y or N"
read INFO2
done


if [[ $INFO2 = "Y" ]] ; then
docker run -it --rm --name build-che \
           -v "$HOME/.m2:/home/user/.m2" \
           -v "$DEST/che:/home/user/che-build" \
           -v /var/run/docker.sock:/var/run/docker.sock \
           -w /home/user/che-build eclipse/che-dev \
           mvn -DskipTests=true \
               -Dfindbugs.skip=true \
               -Dgwt.compiler.localWorkers=2 -T 1C \
               -Dmdep.analyze.skip=true \
               -Dlicense.skip=true \
               -Pnative \
               clean install
fi

sleep 10

read -p 'Star the core build, Press Y or N: ' INFO3
until [[ $INFO3 = [Y,N] ]];do
echo "WARNING"
echo "Press Y or N"
read INFO3
done


if [[ $INFO3 = "Y" ]] ; then
docker run -it --rm --name build-che \
           -v "$HOME/.m2:/home/user/.m2" \
           -v "$DEST/che:/home/user/che-build" \
           -v /var/run/docker.sock:/var/run/docker.sock \
           -w /home/user/che-build/core eclipse/che-dev \
           mvn -DskipTests=true -Dfindbugs.skip=true clean install

fi

sleep 10

read -p 'Star the plugins build, Press Y or N: ' INFO4
until [[ $INFO4 = [Y,N] ]];do
echo "WARNING"
echo "Press Y or N"
read INFO4
done

if [[ $INFO4 = "Y" ]] ; then
docker run -it --rm --name build-che \
           -v "$HOME/.m2:/home/user/.m2" \
           -v "$DEST/che:/home/user/che-build" \
           -v /var/run/docker.sock:/var/run/docker.sock \
           -w /home/user/che-build/plugins eclipse/che-dev \
           mvn clean install

fi

sleep 10

read -p 'Star the Dashboard build, Press Y or N: ' INFO5
until [[ $INFO5 = [Y,N] ]];do
echo "WARNING"
echo "Press Y or N"
read INFO5
done

if [[ $INFO5 = "Y" ]] ; then
cd $DEST/che/dashboard
mvn clean install

fi




  else
echo "maven settings file under $HOME/.m2 doesn't exist"
echo "Configure maven in your home folder and try to run it again...."
echo "task aborting.....!"
exit 0
  fi
