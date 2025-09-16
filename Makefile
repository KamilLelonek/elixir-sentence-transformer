SOLUTION_ZIP := solution.zip
DOCKER_COMPOSE := docker-compose.yml
DB_SERVICE := db
LIVEBOOK_SERVICE := livebook

.PHONY: help setup start stop restart db-logs livebook-logs zip docker-clean

help:
	@echo "  setup         - set up the environment"
	@echo "  start         - start the services"
	@echo "  stop          - stop all services"
	@echo "  restart       - restart all services"
	@echo "  db-logs       - show database logs"
	@echo "  livebook-logs - show livebook logs"
	@echo ""
	@echo "  zip           - create solution archive for submission"
	@echo ""
	@echo "  docker-clean  - clean up docker containers and volumes"

setup:
	@echo "setting up environment..."
	@docker-compose pull
	@echo "Setup complete!"

start:
	@echo "starting services..."
	@docker-compose up -d
	@echo "services started. Use 'make db-logs' or 'make livebook-logs' to view logs of given service."

stop:
	@echo "stopping services..."
	@docker-compose down

restart: stop start

db-logs:
	@docker-compose logs -f $(DB_SERVICE)

livebook-logs:
	@docker-compose logs -f $(LIVEBOOK_SERVICE)

zip:
	@echo "creating solution archive..."
	@rm -f $(SOLUTION_ZIP)
	@zip -r $(SOLUTION_ZIP) .
	@echo "solution archive created: $(SOLUTION_ZIP)"
	@ls -lh $(SOLUTION_ZIP)

docker-clean: stop
	@echo "cleaning docker resources..."
	@docker-compose down -v --remove-orphans
	@docker system prune -f
	@echo "docker cleanup complete"
