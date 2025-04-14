# Get your hands dirty
### Configuration Management Tools
1. What happens if you run the Ansible playbook a second time? How does this compare to the Bash script?
a. When running the playbook a second time
```
PLAY RECAP **********************************************************************************************************************************************************************************************
localhost                  : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```
b. Ansible ensure idempotency, it will check the current state before making change, making this safer than using bash script
2. How would you have to change the playbook to configure multiple EC2 instances?
--> Changing the num of instance to 2 or more