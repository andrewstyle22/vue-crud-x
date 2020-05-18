#!/bin/bash

# This is meant to be copied into the build folder...

# $0. The name of script itself.
# $$ Process id of current shell.
# $* Values of all the arguments. ...
# $# Total number of arguments passed to script.
# $@ Values of all the arguments.
# $? Exit status id of last command.

if [ ! $1 ]
then
    echo "Usage: npm run deploy"
    exit
fi

# build and install frontend?
baseDir=`pwd`

PEM=./$1/deploy/id_rsa
echo $PEM

# URL=ubuntu@127.0.0.1
URL=ubuntu@3.1.138.164
# root@128.199.139.34

# echo $PEM $URL
# echo --- $PEM $URL --- $1 $2
# exit

PS3="Please enter your choice: "
options=(
  "ssh"
  "deploy"
  "list"
  "start"
  "stop"
  "quit"
)
select opt in "${options[@]}"
do
  case $opt in
    "ssh")
      ssh -i $PEM $URL -L 27000:127.0.0.1:27017
      # ssh $URL -L 27000:127.0.0.1:27017
      ;;
    "deploy")
      echo "Deploy Back End... take note public and upload folders"
      tar -zcvf deploy-app.tgz .
      # tar \
      #   --exclude=".git" \
      #   --exclude="node_modules" \
      #   --exclude="${packagePath}/$1/.git" \
      #   --exclude="${packagePath}/$1/node_modules" \
      #   --exclude="${packagePath}/$1/deploy" \
      #   --exclude="${packagePath}/$1/coverage" \
      #   --exclude="${packagePath}/$1/tests" \
      #   --exclude="${packagePath}/$1/web" \
      #   -zcvf deploy-app.tgz .

      # scp -i $PEM deploy-app.tgz $URL:~ && rm deploy-app.tgz
      # ssh -i $PEM $URL "tar -zxvf deploy-app.tgz -C ~/app;rm deploy-app.tgz"
      # cd $packagePath/deploy
      ;;
    "list")
      ssh -i $PEM $URL "pm2 list"
      ;;
    "start")
        # ssh -i $PEM $URL "cd ~/app; authbind --deep pm2 start --only app,cron --env production;"
        ssh -i $PEM $URL "cd ~/app; authbind --deep pm2 start --only app --env production;"
      ;;
    "stop")
        # ssh -i $PEM $URL "cd ~/app; pm2 delete app cron;"
        ssh -i $PEM $URL "cd ~/app; pm2 delete app;"
      ;;
    "quit")
      echo "QUIT"
      break
      ;;
    *) echo "Invalid option $opt";;
  esac
done

echo "Done... press enter to exit"
read # pause exit in windows

