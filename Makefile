NAME = inception

all:
	@echo "Launching $(NAME)..."
	@mkdir -p /home/masenche/data/mariadb
	@mkdir -p /home/masenche/data/wordpress
	@docker compose -f srcs/docker-compose.yml up -d --build

down:
	@echo "Stopping $(NAME)..."
	@docker compose -f srcs/docker-compose.yml down

re: down all

clean: down
	@echo "Cleaning configuration $(NAME)..."
	@docker system prune -a

fclean: clean
	@echo "Full cleaning..."
	@docker volume rm $$(docker volume ls -q) 2>/dev/null || true
	@sudo rm -rf /home/masenche/data/mariadb
	@sudo rm -rf /home/masenche/data/wordpress

.PHONY: all down re clean fclean
