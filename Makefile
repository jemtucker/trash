CC := clang
SOURCES := $(wildcard src/*.m)
OBJECTS := $(patsubst src/%.m,target/%.m.o,$(SOURCES))
INCLUDE := -I include
FRAMEWORKS := -framework Foundation -framework CoreFoundation 
CFLAGS := -g -Wall -Werror -fobjc-arc 
OUT := -o target/trash

all: $(SOURCES) $(OUT)

$(OUT): $(OBJECTS)
	$(CC) $(OBJECTS) $@ $(CFLAGS) $(FRAMEWORKS) $(OUT)

target/%.m.o: src/%.m target 
	$(CC) -c $(CFLAGS) $(INCLUDE) $< -o $@

target: 
	mkdir target

clean:
	rm -r target/ 
