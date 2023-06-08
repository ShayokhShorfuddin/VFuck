import os { input }
fn main() {
	mut pointer := 0
	mut position := 0
	mut stack := [] int{}
	mut table := map[int] int{}
	mut memory := [] int{len: 30000}
	code := input('Brainfuck - ')

	for pos, instruction in code.runes() {
		if instruction == `[` {
			stack << pos
		}
		if instruction == `]` {
			begin_index := stack.pop()
			table[begin_index] = pos
			table[pos] = begin_index
		}
	}

	if stack.len != 0 {
		println('Error: Invalid loop syntax.')
		exit(0)
	}

	for position < code.len {
		current_instruction := code[position].ascii_str()

		// Invalid Instruction
		if !'.,+-<>[]'.contains(current_instruction) {
			position += 1
			continue
		}

		// Add (+)
		if current_instruction == '+' {
			memory[pointer] += 1
			if memory[pointer] == 256 {
				memory[pointer] = 0
			}
		}

		// Subtract (-)
		if current_instruction == '-' {
			memory[pointer] -= 1
			if memory[pointer] == -1 {
				memory[pointer] = 255
			}
		}

		// Pointer Right (>)
		if current_instruction == '>' {
			pointer += 1
			if pointer == 30000 {
				pointer = 0
			}
		}

		// Pointer left (<)
		if current_instruction == '<' {
			pointer -= 1
			if pointer == -1 {
				pointer = 29999
			}
		}

		// Output (.)
		if current_instruction == '.' {
			print(rune(memory[pointer]))
		}
		
		// Input (,)
		if current_instruction == ',' {
			mut input_string := input('')
			
			if input_string.len == 0 || input_string.len > 1 {
				println("Error: Input is empty or more than 1 char.")
				exit(0)
			}

			memory[pointer] = int(input_string.runes()[0])
		}
		
		// Left brace ([)
		if current_instruction == "[" {
			if memory[pointer] == 0 {
				position = table[position]
			}
		}

		// Left brace ([)
		if current_instruction == "]" {
			if memory[pointer] != 0 {
				position = table[position]
			}
		}

		position += 1
	}
}