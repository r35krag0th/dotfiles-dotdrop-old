function set_jira_ticket --description "Set your active Jira Ticket"
  set --global --export X_JIRA_TICKET $argv[1]

  get_jira_ticket
end

function set_jira_project --description "Set your active Jira Project"
  set --global --export X_JIRA_PROJECT $argv[1]
end

function get_jira_ticket --description "Show your active Jira Ticket"
  set --query X_JIRA_TICKET
  if test $status -eq 0
    echo -e "You are currently working on \033[48;5;27m\033[37m Jira \033[0m."
  else
    echo "You don't seem to be working on a ticket."
  end
end

function ticket_create --description "Create a new Jira Ticket"
  set --query X_JIRA_PROJECT
  if test $status -ne 0
    echo -e "\033[31mERROR --> \033[0mYou do not have a project set."
  else
    set -l extra_args ""
    if test -n $argv[1]
      set extra_args $argv[1]
    end
    command jira create -p $X_JIRA_PROJECT -i Task $extra_args
  end
end

function ticket_create_for_github_access --description "Create a new Jira Ticket for a Github Access change"
  ticket_create "-t github_access"
end

function ticket_create_for_support_queue --description "Create a new Jira Ticket for a support channel request"
  ticket_create "-t support_queue"
end

function ticket_transition_to
  set --query X_JIRA_TICKET
  if test $status -ne 0
    echo -e "\033[31mERROR --> \033[0mYou do not have a current ticket set.\033[0m"
    exit 1
  end

  set --query X_JIRA_PROJECT
  if test $status -ne 0
    echo -e "\033[31mERROR -->\033[0mYou do not have a project set."
    exit 2
  else
    command jira transition $argv[1] $X_JIRA_TICKET --noedit
  end
end

function ticket_is_actionable --description "Transition the active ticket to Actionable"
  ticket_transition_to "Actionable"
end

function ticket_is_inprogress --description "Start working on a ticket"
  ticket_transition_to "Start"
end

function ticket_is_done --description "Complete a ticket"
  ticket_transition_to "Done"
end

function ticket_comment --description "Leave a comment on a ticket"
  set --query X_JIRA_TICKET
  if test $status -eq 0
    command jira comment $X_JIRA_TICKET -m "$argv"
  else
    echo "\033[31mERROR --> \033[0mYou do not have a current ticket set.\033[0m"
  end
end

function ticket_add_time_spent --description "Log time spent on a ticket"
  set --query X_JIRA_TICKET
  if test $status -eq 0
    command jira worklog add $X_JIRA_TICKET -m "$argv"
  else
    echo "\033[31mERROR --> \033[0mYou do not have a current ticket set.\033[0m"
  end
end

function ticket_view --description "View the summary of a ticket"
  set --query X_JIRA_TICKET
  if test $status -eq 0
    command jira view $X_JIRA_TICKET
  else
    echo "\033[31mERROR --> \033[0mYou do not have a current ticket set.\033[0m"
  end
end
