_RED=\033[31m
_GREEN=\033[32m
_BLUE=\033[34m
_BOLD=\033[1m
_DEFAULT=\033[0m

NAME = woody_woodpacker

SRC = main.c error_input.c parser.c woody.c elf.c code_cave.c expand.c creat_segment.c
SRC_ASM = rc4.asm
SRC_PAYLOAD = end.asm message.asm prep.asm rc4.asm

OBJ = $(SRC:.c=.o)
OBJ_PAYLOAD = $(SRC_PAYLOAD:.asm=.o)

SRC_DIR = ./srcs
OBJ_DIR = ./objs
INC_DIR = ./include
ASM_DIR = $(SRC_DIR)/rc4
PAYLOAD_DIR = ./asm_src

OBJS = $(OBJ:%=$(OBJ_DIR)/%)
OBJS_PAYLOAD = $(OBJ_PAYLOAD:%=$(OBJ_DIR)/%)

INC = woody.h

HEAD = $(INC_DIR)/$(INC)

LIBFT = libft.a
LIB_DIR = ./libft
LFT = $(LIB_DIR)/$(LIBFT)
LIB = -L $(LIB_DIR) -l$(LIBFT:lib%.a=%)

FLG = -Wno-format -Wall -Werror -Wextra -fanalyzer
MAKEFLAGS += -s

CC = gcc

.PHONY: update

all:
	$(MAKE) -C $(LIB_DIR)
	$(MAKE) update
	$(MAKE) $(NAME)
	printf "${_BOLD}${_BLUE}[$(NAME) ${_GREEN}ok${_BLUE}]${_DEFAULT}\n"

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c
	mkdir -p $(OBJ_DIR)
	printf "${_BOLD}${_BLUE}[$(NAME)]${_DEFAULT} $(CC) $(FLG) -I $(INC_DIR) -o $@ -c -fPIC $<\n"
	$(CC) $(FLG) -I $(INC_DIR) -o $@ -c -fPIC $<

$(OBJ_DIR)/%.o: $(PAYLOAD_DIR)/%.asm
	mkdir -p $(OBJ_DIR)
	printf "${_BOLD}${_BLUE}[$(NAME)]${_DEFAULT} nasm -elf64 $< -o $@\n"
	nasm -felf64 $< -o $@

$(OBJS): $(HEAD)

update: $(OBJS_PAYLOAD)
	printf "${_BOLD}${_BLUE}[$(NAME)]${_DEFAULT} ./update_script\n"
	./update_script

$(NAME): $(OBJS)
	rm -rf woody
	printf "${_BOLD}${_BLUE}[$(NAME)]${_DEFAULT} rm -rf woody\n"
	nasm -felf64 $(ASM_DIR)/$(SRC_ASM)
	printf "${_BOLD}${_BLUE}[$(NAME)]${_DEFAULT} nasm -felf64 $(ASM_DIR)/$(SRC_ASM)\n"
	clang $(ASM_DIR)/rc4.o $(OBJS) -o $@ $(LIB)
	printf "${_BOLD}${_BLUE}[$(NAME)]${_DEFAULT} clang $(ASM_DIR)/rc4.o $(OBJS) -o $@ $(LIB)\n"

clean:
	rm -rf $(OBJ_DIR)
	$(MAKE) $@ -C $(LIB_DIR)

fclean: clean
	rm -rf woody
	rm -rf $(NAME)
	$(MAKE) $@ -C $(LIB_DIR)

re:
	$(MAKE) fclean
	$(MAKE) all

