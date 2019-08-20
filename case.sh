branch=`cat env.conf | grep "GIT_BRANCH" | awk -F "/" '{print $2}'`
echo "branch"
case ${branch} in
 dev)
        echo "Deploying to dev"
        /usr/bin/sh dev.sh
        ;;
 master)
        echo "Deploying to master"
        /usr/bin/sh dev.sh
        #/usr/bin/sh deploy.sh
        ;;
 *)
        echo "nothing happens.."
        ;;
esac