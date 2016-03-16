#### How to execute tasks?

**Lab manager perspective**

To actually carry out the Awesome Task for real in the wetlab, in most cases (except for Sequencing Verification), the lab manager need to schedule the metacol/protocols corresponding to this Awesome Task. Noting that it only needs to be started once to execute all the Awesome Tasks that are waiting or ready, so the best practice is to start this regularly every day at a determined time so users can enter their tasks before that time. To start the metacol/protocols, go to Protocols > Under Version Control, find the Github repo tree, click workflows/metacol, then click the file named awesome_task.oy, leave the debug_mode empty, assign to a group that is going to experimentally perform all the protocols, normally choose technicians, then click Launch! All the protocols will then be subsequently scheduled and can be accessed from Protocols > Pending Jobs.

**User perspective**

For each new task entered, it will start as waiting by default. A protocol named tasks_inputs.rb, normally the first protocol in the metacol associated with this task, will process all the tasks in the waiting or ready status and change its status to ready if all the input requirements are fulfilled and change to waiting if not. All the tasks in the ready will be batched and being processed by subsequent protocols in the metacol to actually instruct technicians to perform guided steps in the lab to carry out actual experiments.

If you don't want a task to be executed anymore, change its status to canceled. You are advised only to do this while your task is in waiting or ready and the metacol has not been started, if your task already been processed and progressed to other status, contact the Lab manager to discuss alternatives if you don't want a task to be executed anymore.
