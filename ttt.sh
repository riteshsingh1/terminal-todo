#!/bin/sh

# Simple terminal todo application (POSIX-compliant version)
# Usage: ttt.sh

# Data file to store tasks
DATA_DIR="$HOME/.ttt"
TASKS_FILE="$DATA_DIR/tasks.txt"

# Create data directory if it doesn't exist
mkdir -p "$DATA_DIR"
touch "$TASKS_FILE"

# Colors and formatting
RESET="\033[0m"
BOLD="\033[1m"
STRIKETHROUGH="\033[9m"
ITALIC="\033[3m"
GREEN="\033[32m"
YELLOW="\033[33m"
BLUE="\033[34m"
RED="\033[31m"
CYAN="\033[36m"
GRAY="\033[37m"

# Function to display usage
show_help() {
  echo "$BOLD""Terminal Todo Tracker (ttt)""$RESET"
  echo ""
  echo "$BOLD""Commands:""$RESET"
  echo "  ""$CYAN""ttt""$RESET""              Show task list"
  echo "  ""$CYAN""ttt add""$RESET""          Add a new task"
  echo "  ""$CYAN""ttt clear""$RESET""        Clear completed tasks"
  echo "  ""$CYAN""ttt help""$RESET""         Show this help message"
  echo ""
  echo "$BOLD""Keyboard Shortcuts:""$RESET"
  echo "  ""$GREEN""d""$RESET"" - Mark as done"
  echo "  ""$YELLOW""p""$RESET"" - Postpone (enter new due date)"
  echo "  ""$RED""n""$RESET"" - Remove task (not required)"
  echo "  ""$BLUE""a""$RESET"" - Add new task"
  echo "  ""$GRAY""q""$RESET"" - Quit application"
}

# Clear screen function (POSIX-compliant)
clear_screen() {
  printf "\033c"
}

# Function to display tasks
display_tasks() {
  clear_screen
  
  echo ""
  echo "$BOLD""$CYAN""===== Terminal Todo Tracker =====""$RESET"
  echo ""
  
  # Get unique dates and sort them (include all dates)
  dates=$(cut -d'|' -f2 "$TASKS_FILE" | sort -u)
  
  # Display all tasks by date
  if [ -z "$dates" ]; then
    echo "$YELLOW""No tasks found.""$RESET"
  else
    echo "$BOLD""TASKS:""$RESET"
    echo ""
    
    # Create a temporary file for the task mapping
    rm -f "$DATA_DIR/task_map.tmp" 2>/dev/null
    touch "$DATA_DIR/task_map.tmp"
    
    # Track overall task number for backwards compatibility
    total_task_num=1
    
    # For tracking date numbers
    date_num=1
    
    for date in $dates; do
      echo "$BOLD""$CYAN""Due: $date""$RESET"
      echo "$GRAY""----------------------------------------""$RESET"
      
      # Reset the task number for each date
      local_task_num=1
      
      # Display both active and completed tasks for this date
      grep "|$date|" "$TASKS_FILE" | while IFS='|' read -r status date task; do
        if [ "$status" = "DONE:" ]; then
          echo " ""$BOLD""$BLUE""[$local_task_num]""$RESET"" ""$STRIKETHROUGH""$task""$RESET"" ""$GRAY""(done)""$RESET"
        else
          echo " ""$BOLD""$BLUE""[$local_task_num]""$RESET"" $task"
        fi
        
        # Store both the display number and the task line
        echo "$date:$local_task_num:$total_task_num:$status|$date|$task" >> "$DATA_DIR/task_map.tmp"
        
        local_task_num=$((local_task_num + 1))
        total_task_num=$((total_task_num + 1))
      done
      echo ""
      
      date_num=$((date_num + 1))
    done
    
    echo "$GRAY""$ITALIC""----------------------------------------""$RESET"
    echo "$ITALIC""$BOLD""Actions:""$RESET""$ITALIC"" Select task number, then choose:""$RESET"
    echo "$ITALIC"" ""$GREEN""d""$RESET""$ITALIC""-Done  ""$YELLOW""p""$RESET""$ITALIC""-Postpone  ""$RED""n""$RESET""$ITALIC""-Not Required  ""$BLUE""a""$RESET""$ITALIC""-Add New  ""$GRAY""q""$RESET""$ITALIC""-Quit""$RESET"
    echo "$GRAY""$ITALIC""----------------------------------------""$RESET"
    echo ""
  fi
}

# Function to add a new task
add_task() {
  clear_screen
  
  echo ""
  echo "$BOLD""$CYAN""==== Add New Task ====""$RESET"
  echo ""
  
  echo "$BOLD""Enter task description:""$RESET"" "
  read task
  
  # Get today's date in dd/mm/yy format (POSIX-compliant)
  today=$(date +%d/%m/%y)
  
  echo ""
  echo "$BOLD""Enter due date (""$YELLOW""dd/mm/yy""$RESET""$BOLD"") [""$GREEN""Today: $today""$RESET""$BOLD""]:""$RESET"" "
  read due_date
  
  # Use today's date if user didn't enter anything
  if [ -z "$due_date" ]; then
    due_date="$today"
    echo "$BLUE""Using today's date: $today""$RESET"
  fi
  
  # Validate date format (simplified for POSIX)
  case "$due_date" in
    [0-9][0-9]/[0-9][0-9]/[0-9][0-9])
      echo "TODO:|$due_date|$task" >> "$TASKS_FILE"
      echo ""
      echo "$GREEN""Task added successfully!""$RESET"
      ;;
    *)
      echo ""
      echo "$RED""Invalid date format. Please use dd/mm/yy""$RESET"
      echo "$ITALIC""Press any key to try again...""$RESET"
      read dummy
      add_task
      return
      ;;
  esac
  
  echo "$ITALIC""Press any key to continue...""$RESET"
  read dummy
}

# Function to count tasks by status
count_tasks() {
  active_count=$(grep -v "^DONE:" "$TASKS_FILE" | wc -l)
  done_count=$(grep "^DONE:" "$TASKS_FILE" | wc -l)
  
  active_count=$(echo "$active_count" | tr -d ' ')
  done_count=$(echo "$done_count" | tr -d ' ')
  
  echo "$ITALIC""$BOLD""Status:""$RESET""$ITALIC"" ""$BLUE""$active_count""$RESET""$ITALIC"" active, ""$GREEN""$done_count""$RESET""$ITALIC"" completed""$RESET"
}

# Function to remove a task line from file
remove_line_from_file() {
  task_line="$1"
  temp_file="$TASKS_FILE.tmp"
  
  # Write all lines except the one to remove to a temp file
  awk -v line="$task_line" '$0 != line' "$TASKS_FILE" > "$temp_file"
  
  # Replace original with temp file
  mv "$temp_file" "$TASKS_FILE"
}

# Function to check for overdue tasks
check_overdue_tasks() {
  # Get today's date in dd/mm/yy format
  today=$(date +%d/%m/%y)
  
  # Convert today to comparable format (yymmdd)
  today_comparable=$(echo "$today" | awk -F'/' '{print $3$2$1}')
  
  # Count moved tasks
  moved_count=0
  
  # Create temporary file
  temp_file="$TASKS_FILE.tmp"
  > "$temp_file"
  
  # Check each task
  while IFS= read -r line; do
    # Only check active tasks (not completed ones)
    case "$line" in
      DONE:*)
        # Keep completed tasks as they are
        echo "$line" >> "$temp_file"
        ;;
      *)
        # Extract the date
        task_date=$(echo "$line" | cut -d'|' -f2)
        
        # Convert task date to comparable format (yymmdd)
        task_date_comparable=$(echo "$task_date" | awk -F'/' '{print $3$2$1}')
        
        # If task date is before today, update to today
        if [ -n "$task_date_comparable" ] && [ "$task_date_comparable" -lt "$today_comparable" ]; then
          # Replace the old date with today's date
          updated_line=$(echo "$line" | sed "s/|$task_date|/|$today|/")
          echo "$updated_line" >> "$temp_file"
          moved_count=$((moved_count + 1))
        else
          # Keep the original line
          echo "$line" >> "$temp_file"
        fi
        ;;
    esac
  done < "$TASKS_FILE"
  
  # Replace the original file with the updated one
  mv "$temp_file" "$TASKS_FILE"
  
  # Show notification if tasks were moved
  if [ "$moved_count" -gt 0 ]; then
    echo "$YELLOW""$moved_count overdue task(s) moved to today ($today).""$RESET"
    sleep 1
  fi
}

# Function to interact with tasks
interact_with_tasks() {
  # Check for overdue tasks first
  check_overdue_tasks
  
  display_tasks
  count_tasks
  
  # Get the list of all tasks (both active and completed)
  all_tasks=$(cat "$TASKS_FILE")
  task_count=$(echo "$all_tasks" | wc -l)
  task_count=$(echo "$task_count" | tr -d ' ')
  
  if [ "$task_count" -eq 0 ] || [ -z "$all_tasks" ]; then
    echo ""
    echo "$YELLOW""No tasks found.""$RESET"
    echo "$ITALIC""Press ""$BLUE""'a'""$RESET""$ITALIC"" to add a new task or ""$GRAY""'q'""$RESET""$ITALIC"" to quit.""$RESET"
    read choice
    case "$choice" in
      a) add_task && interact_with_tasks ;;
      q) clear_screen && exit 0 ;;
      *) interact_with_tasks ;;
    esac
    return
  fi
  
  echo ""
  echo "$ITALIC""$BOLD""Enter your choice:""$RESET""$ITALIC"" ""$RESET"
  read selection
  
  if [ "$selection" = "a" ]; then
    add_task
    interact_with_tasks
    return
  elif [ "$selection" = "q" ]; then
    clear_screen
    exit 0
  elif [ "$selection" -le "$task_count" ] 2>/dev/null && [ "$selection" -gt 0 ]; then
    # For numerical selections, we need to find which date and task this corresponds to
    
    # Find the current date being displayed
    current_date=$(date +%d/%m/%y)
    
    # Try to find a task for today first with this local number
    task_info=$(grep ":$current_date:" "$DATA_DIR/task_map.tmp" | grep ":$selection:" | head -1)
    
    # If not found for today, try to find it in any date
    if [ -z "$task_info" ]; then
      date_for_task=$(grep ":$selection:" "$DATA_DIR/task_map.tmp" | cut -d':' -f1 | head -1)
      task_info=$(grep "^$date_for_task:$selection:" "$DATA_DIR/task_map.tmp" | head -1)
    fi
    
    if [ -n "$task_info" ]; then
      # Extract task information
      selected_task_line=$(echo "$task_info" | cut -d':' -f4-)
      
      # Parse the selected line
      task_content=$(echo "$selected_task_line" | cut -d'|' -f3)
      task_status=$(echo "$selected_task_line" | cut -d'|' -f1)
      task_date=$(echo "$selected_task_line" | cut -d'|' -f2)
      
      # Check if the task is already completed
      if [ "$task_status" = "DONE:" ]; then
        echo ""
        echo "$BOLD""Selected:""$RESET"" ""$STRIKETHROUGH""$CYAN""$task_content""$RESET"" ""$GRAY""(already completed)""$RESET"
        echo ""
        echo "$ITALIC""$BOLD""What to do with this task?""$RESET""$ITALIC"
        echo "$YELLOW""r""$RESET""$ITALIC""-Restore  ""$RED""n""$RESET""$ITALIC""-Remove""$RESET"
        read action
        
        case "$action" in
          r)
            # Restore task (mark as active again)
            remove_line_from_file "$selected_task_line"
            echo "TODO:|$task_date|$task_content" >> "$TASKS_FILE"
            echo ""
            echo "$YELLOW""Task restored to active status.""$RESET"
            sleep 1
            ;;
          n)
            # Remove task
            echo ""
            echo "$RED""Are you sure you want to remove this task? (y/n)""$RESET"
            read confirm
            if [ "$confirm" = "y" ]; then
              remove_line_from_file "$selected_task_line"
              echo ""
              echo "$RED""Task removed.""$RESET"
              sleep 1
            fi
            ;;
          *)
            echo ""
            echo "$RED""Invalid option.""$RESET"
            sleep 1
            ;;
        esac
      else
        # Regular active task
        echo ""
        echo "$BOLD""Selected:""$RESET"" ""$CYAN""$task_content""$RESET"
        echo ""
        echo "$ITALIC""$BOLD""What to do with this task?""$RESET""$ITALIC"
        echo "$GREEN""d""$RESET""$ITALIC""-Done  ""$YELLOW""p""$RESET""$ITALIC""-Postpone  ""$RED""n""$RESET""$ITALIC""-Not Required""$RESET"
        read action
        
        case "$action" in
          d)
            # Mark as done - keep the same due date
            remove_line_from_file "$selected_task_line"
            echo "DONE:|$task_date|$task_content" >> "$TASKS_FILE"
            echo ""
            echo "$GREEN""Task marked as done!""$RESET"
            sleep 1
            ;;
          p)
            # Postpone task
            # Get today's date for reference
            today=$(date +%d/%m/%y)
            
            echo ""
            echo "$BOLD""Enter new due date (""$YELLOW""dd/mm/yy""$RESET""$BOLD"") [""$GREEN""Today: $today""$RESET""$BOLD""]:""$RESET"
            read new_date
            
            # Use today's date if user didn't enter anything
            if [ -z "$new_date" ]; then
              new_date="$today"
              echo "$BLUE""Using today's date: $today""$RESET"
            fi
            
            # Validate date format
            case "$new_date" in
              [0-9][0-9]/[0-9][0-9]/[0-9][0-9])
                remove_line_from_file "$selected_task_line"
                echo "TODO:|$new_date|$task_content" >> "$TASKS_FILE"
                echo ""
                echo "$YELLOW""Task postponed to $new_date.""$RESET"
                sleep 1
                ;;
              *)
                echo ""
                echo "$RED""Invalid date format. Please use dd/mm/yy""$RESET"
                sleep 2
                ;;
            esac
            ;;
          n)
            # Not required
            echo ""
            echo "$RED""Are you sure you want to remove this task? (y/n)""$RESET"
            read confirm
            if [ "$confirm" = "y" ]; then
              remove_line_from_file "$selected_task_line"
              echo ""
              echo "$RED""Task removed.""$RESET"
              sleep 1
            fi
            ;;
          *)
            echo ""
            echo "$RED""Invalid option.""$RESET"
            sleep 1
            ;;
        esac
      fi
    else
      # Fallback to old behavior (selected_task_line by number)
      i=0
      selected_task_line=""
      while IFS= read -r line; do
        i=$((i + 1))
        if [ "$i" -eq "$selection" ]; then
          selected_task_line="$line"
          break
        fi
      done << EOF
$all_tasks
EOF

      # Continue with your existing code using selected_task_line
      # Parse the selected line
      task_content=$(echo "$selected_task_line" | cut -d'|' -f3)
      task_status=$(echo "$selected_task_line" | cut -d'|' -f1)
      task_date=$(echo "$selected_task_line" | cut -d'|' -f2)
      
      # Check if the task is already completed
      if [ "$task_status" = "DONE:" ]; then
        echo ""
        echo "$BOLD""Selected:""$RESET"" ""$STRIKETHROUGH""$CYAN""$task_content""$RESET"" ""$GRAY""(already completed)""$RESET"
        echo ""
        echo "$ITALIC""$BOLD""What to do with this task?""$RESET""$ITALIC"
        echo "$YELLOW""r""$RESET""$ITALIC""-Restore  ""$RED""n""$RESET""$ITALIC""-Remove""$RESET"
        read action
        
        case "$action" in
          r)
            # Restore task (mark as active again)
            remove_line_from_file "$selected_task_line"
            echo "TODO:|$task_date|$task_content" >> "$TASKS_FILE"
            echo ""
            echo "$YELLOW""Task restored to active status.""$RESET"
            sleep 1
            ;;
          n)
            # Remove task
            echo ""
            echo "$RED""Are you sure you want to remove this task? (y/n)""$RESET"
            read confirm
            if [ "$confirm" = "y" ]; then
              remove_line_from_file "$selected_task_line"
              echo ""
              echo "$RED""Task removed.""$RESET"
              sleep 1
            fi
            ;;
          *)
            echo ""
            echo "$RED""Invalid option.""$RESET"
            sleep 1
            ;;
        esac
      else
        # Regular active task
        echo ""
        echo "$BOLD""Selected:""$RESET"" ""$CYAN""$task_content""$RESET"
        echo ""
        echo "$ITALIC""$BOLD""What to do with this task?""$RESET""$ITALIC"
        echo "$GREEN""d""$RESET""$ITALIC""-Done  ""$YELLOW""p""$RESET""$ITALIC""-Postpone  ""$RED""n""$RESET""$ITALIC""-Not Required""$RESET"
        read action
        
        case "$action" in
          d)
            # Mark as done - keep the same due date
            remove_line_from_file "$selected_task_line"
            echo "DONE:|$task_date|$task_content" >> "$TASKS_FILE"
            echo ""
            echo "$GREEN""Task marked as done!""$RESET"
            sleep 1
            ;;
          p)
            # Postpone task
            # Get today's date for reference
            today=$(date +%d/%m/%y)
            
            echo ""
            echo "$BOLD""Enter new due date (""$YELLOW""dd/mm/yy""$RESET""$BOLD"") [""$GREEN""Today: $today""$RESET""$BOLD""]:""$RESET"
            read new_date
            
            # Use today's date if user didn't enter anything
            if [ -z "$new_date" ]; then
              new_date="$today"
              echo "$BLUE""Using today's date: $today""$RESET"
            fi
            
            # Validate date format
            case "$new_date" in
              [0-9][0-9]/[0-9][0-9]/[0-9][0-9])
                remove_line_from_file "$selected_task_line"
                echo "TODO:|$new_date|$task_content" >> "$TASKS_FILE"
                echo ""
                echo "$YELLOW""Task postponed to $new_date.""$RESET"
                sleep 1
                ;;
              *)
                echo ""
                echo "$RED""Invalid date format. Please use dd/mm/yy""$RESET"
                sleep 2
                ;;
            esac
            ;;
          n)
            # Not required
            echo ""
            echo "$RED""Are you sure you want to remove this task? (y/n)""$RESET"
            read confirm
            if [ "$confirm" = "y" ]; then
              remove_line_from_file "$selected_task_line"
              echo ""
              echo "$RED""Task removed.""$RESET"
              sleep 1
            fi
            ;;
          *)
            echo ""
            echo "$RED""Invalid option.""$RESET"
            sleep 1
            ;;
        esac
      fi
    fi
  else
    echo ""
    echo "$RED""Invalid selection.""$RESET"
    sleep 1
  fi
  
  # Show tasks again
  interact_with_tasks
}

# Function to clear completed tasks
clear_completed() {
  done_count=$(grep "^DONE:" "$TASKS_FILE" | wc -l)
  done_count=$(echo "$done_count" | tr -d ' ')
  
  if [ "$done_count" -eq 0 ]; then
    echo "$YELLOW""No completed tasks to clear.""$RESET"
  else
    echo "$RED""Are you sure you want to clear $done_count completed tasks? (y/n)""$RESET"
    read confirm
    if [ "$confirm" = "y" ]; then
      grep -v "^DONE:" "$TASKS_FILE" > "$TASKS_FILE.tmp"
      mv "$TASKS_FILE.tmp" "$TASKS_FILE"
      echo "$GREEN""Completed tasks cleared.""$RESET"
    else
      echo "$YELLOW""Operation cancelled.""$RESET"
    fi
  fi
  
  echo "$ITALIC""Press any key to continue...""$RESET"
  read dummy
  interact_with_tasks
}

# Main program logic
case "$1" in
  add)
    add_task
    interact_with_tasks
    ;;
  clear)
    clear_completed
    ;;
  help)
    show_help
    ;;
  *)
    interact_with_tasks
    ;;
esac 