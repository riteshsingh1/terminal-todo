#!/bin/bash
# Demo script to showcase TTD features

echo "🚀 TTD - Terminal Todo Demo"
echo "=========================="

# Add some sample tasks
echo "Adding sample tasks..."
./ttd.py add "Review project proposal" --project "Work" --priority P1 --due "tomorrow"
./ttd.py add "Buy groceries" --project "Personal" --priority P2 --labels "shopping" --labels "errands"
./ttd.py add "Call dentist" --project "Personal" --priority P3 
./ttd.py add "Finish quarterly report" --project "Work" --priority P1 --due "friday"
./ttd.py add "Read new book" --project "Personal" --priority P4
./ttd.py add "Update resume" --project "Career" --priority P2
./ttd.py add "Plan weekend trip" --project "Personal" --priority P3 --labels "travel"

echo -e "\n📝 All tasks:"
./ttd.py list

echo -e "\n🏢 Work tasks only:"
./ttd.py list --project "Work"

echo -e "\n🔥 High priority tasks (P1 & P2):"
./ttd.py list --priority P1
./ttd.py list --priority P2

echo -e "\n✅ Completing some tasks..."
./ttd.py complete 2
./ttd.py complete 5

echo -e "\n📊 Statistics:"
./ttd.py stats

echo -e "\n🏷️ Projects:"
./ttd.py projects

echo -e "\n🔍 Search for 'project' tasks:"
./ttd.py list --search "project"

echo -e "\n✅ Completed tasks:"
./ttd.py list --completed

echo -e "\n📋 Pending tasks:"
./ttd.py list --pending

echo -e "\nDemo complete! Try the interactive mode with: ./ttd.py"