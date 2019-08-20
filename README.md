Jenkins Pipeline for ECS_fargate

# General
 ## Log Rotation for old build files
    Max files 30
    Max days 0
 
 # SCM
  ### Git
   #### Repositories
        Repository URL :git@github.com:xxxxxx/xxxxxxx.git
        Credentials : root (jenkins-root)
   
   #### Branches to build
        Branch Specifier(blank for 'any') : **(blank)
        Repository browser : (auto)
    
    

# Pre Steps
  #### Excute shell
    sh env.sh

# Post Steps
 #### Excute shell
    sh case.sh
    sleep 1
    rm -f env.conf
