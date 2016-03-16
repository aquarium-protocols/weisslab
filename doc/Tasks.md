Task Routines
---
#### How to enter new tasks?
Assume a task prototype has the name of Awesome Task (such as Fragment Construction). To enter new tasks and track all existing tasks progress and information, go to Tasks > Awesome Tasks. You can click the button New Awesome Task to enter inputs for new tasks: you can enter anything that helps you recognize in the Name field, leave the Status as waiting by default, enter the rest of arguments referring to the **input requirements** of each specific task documentation in the following sections. If an argument input has "+", "-" buttons, it means the argument takes an array of inputs, if the input has two "+", "-" button, it means the argument takes an array of array inputs. You can also click the status bar such as waiting, ready, canceled, etc to track all your tasks. You can use search bar to filter out your tasks of interest by typing user name or tasks name. It starts with your user name as default. You can check your input by running aqualib/workflows/general/tasks_inputs.rb, enter Awesome Task as the argument in task_name and enter your user name in the group argument. After you run, you can check the notifications of the tasks to see what's wrong with your input.

#### How to execute tasks?

**Lab manager perspective**

To actually carry out the Awesome Task for real in the wetlab, in most cases (except for Sequencing Verification), the lab manager need to schedule the metacol/protocols corresponding to this Awesome Task. Noting that it only needs to be started once to execute all the Awesome Tasks that are waiting or ready, so the best practice is to start this regularly every day at a determined time so users can enter their tasks before that time. To start the metacol/protocols, go to Protocols > Under Version Control, find the Github repo tree, click workflows/metacol, then click the file named awesome_task.oy, leave the debug_mode empty, assign to a group that is going to experimentally perform all the protocols, normally choose technicians, then click Launch! All the protocols will then be subsequently scheduled and can be accessed from Protocols > Pending Jobs.

**User perspective**

For each new task entered, it will start as waiting by default. A protocol named tasks_inputs.rb, normally the first protocol in the metacol associated with this task, will process all the tasks in the waiting or ready status and change its status to ready if all the input requirements are fulfilled and change to waiting if not. All the tasks in the ready will be batched and being processed by subsequent protocols in the metacol to actually instruct technicians to perform guided steps in the lab to carry out actual experiments.

If you don't want a task to be executed anymore, change its status to canceled. You are advised only to do this while your task is in waiting or ready and the metacol has not been started, if your task already been processed and progressed to other status, contact the Lab manager to discuss alternatives if you don't want a task to be executed anymore.
