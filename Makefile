NAME = Zpacker

SRC = main.c endian.c file.c iterators.c packer.c safe.c elf64_viewer.c\
	  pack_step/adjust_references.c \
	  pack_step/adjust_sizes.c \
	  pack_step/change_entry.c \
	  pack_step/copy_clone_file.c \
	  pack_step/define_shift.c \
	  pack_step/find_entry.c \
	  pack_step/load_code.c \
	  encrypt.s \
	  load_code.s


SRCDIR = src

OBJDIR = obj

OBJC = $(addprefix ${OBJDIR}/,$(SRC:.c=.o))

OBJ = $(OBJC:.s=.o)

CC = gcc

DEP = $(addprefix ${OBJDIR}/, $(SRC:.c=.d))

CFLAGS=  -Wall -Wextra -g -MMD 

AS = nasm

ASFLAGS= -f elf64 -g

LDFLAGS = -I includes/


############################## RULES ###########################################
all:${NAME}

${NAME}:${OBJ}
	@echo  compiling and linking [${OBJ}]...
	@${CC} ${CFLAGS} ${LDFLAGS}  -o $@ ${OBJ}
	@echo Success"   "[${NAME}]${X}

${OBJDIR}/%.o: ${SRCDIR}/%.s
	@echo Compiling [$@]...${X}
	@/bin/mkdir -p ${OBJDIR} 
	@${AS} ${ASFLAGS} -o $@ $< 
	@printf 

${OBJDIR}/%.o: ${SRCDIR}/%.c
	@echo  compiling [$@]...
	@/bin/mkdir -p ${OBJDIR} ${OBJDIR}/pack_step
	@${CC} ${CFLAGS} ${LDFLAGS} -c -o $@ $<
	@echo Success"   "[$@]
	@printf 

############################## GENERAL #########################################

exist = $(shell if [ -f $(NAME) ]; then echo "exist"; else echo "notexist"; fi;)

.PHONY: all clean 
clean:
	@echo Cleaning"  "[${OBJ}]...${X}
	@/bin/rm -Rf ${OBJDIR}
ifeq (${exist}, exist)
	@/bin/rm ${NAME}
endif

-include ${DEP}
