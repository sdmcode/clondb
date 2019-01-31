CC = gcc
CFLAGS = -I.

OBJ_DIR = objects

EXEC = build/clon.exe

SOURCE = $(wildcard src/*.c)
OBJECTS = $(patsubst $(SOURCE)/%.c, $(OBJ_DIR)/%.o, $(SOURCE))

$(EXEC): $(OBJECTS)
	$(CC) $(OBJECTS) -o $(EXEC)

$(OBJ_DIR)%.o: %.c
	mkdir -p $(@D)
	$(CC) -c $(CFLAGS) $< -o $@
