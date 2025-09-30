.PHONY: install test demo clean run help

# TTD - Terminal Todo Makefile

help:
	@echo "TTD - Terminal Todo Application"
	@echo "=============================="
	@echo ""
	@echo "Available commands:"
	@echo "  make install    - Install dependencies and set up the application"
	@echo "  make test       - Run unit tests"
	@echo "  make demo       - Run the demo script"
	@echo "  make run        - Start interactive mode"
	@echo "  make clean      - Clean temporary files and cache"
	@echo "  make help       - Show this help message"

install:
	@echo "Installing TTD..."
	pip3 install -r requirements.txt
	chmod +x ttd.py
	chmod +x demo.sh
	@echo "Installation complete!"
	@echo "Run 'make demo' to see the features or './ttd.py' to start using it."

test:
	@echo "Running tests..."
	python3 test_ttd.py

demo:
	@echo "Running demo..."
	./demo.sh

run:
	@echo "Starting TTD interactive mode..."
	./ttd.py

clean:
	@echo "Cleaning up..."
	find . -name "*.pyc" -delete
	find . -name "__pycache__" -type d -exec rm -rf {} +
	@echo "Clean complete!"

# Shortcuts for common tasks
add:
	./ttd.py add "$(TASK)" --project "$(PROJECT)" --priority "$(PRIORITY)"

list:
	./ttd.py list

stats:
	./ttd.py stats