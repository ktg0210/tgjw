Jenkins Pipeline for ECS_fargate

# General
  ### Delete Old build files
    Strategy : Log Rotation
    Max days : 0
    Max files : 30
 
# SCM
  ### Git
   #### Repositories
    Repository URL :git@github.com:xxxxxx/xxxxxxx.git
    Credentials : xxxx (jenkins-root)
   
   #### Branches to build
    Branch Specifier(blank for 'any') : **(blank)
    Repository browser : (auto)

# Build Trigger
    Build whenever a SNAPSHOT dependency is built 
    GitHub hook trigger for GITScm polling
    
# Build Envirionment
    Add timestamps to the Console Output
    
# Pre Steps
  #### Excute shell
    sh env.sh
    
# Build
    Root POM : pom.xml

# Post Steps
    Run only if build succeeds
 #### Excute shell
    sh case.sh
    sleep 1
    rm -f env.conf
