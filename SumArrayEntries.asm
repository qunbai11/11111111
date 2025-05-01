@R2
M=0         // Reset sum (R2) to 0 before we start

@R1
D=M
@END
D;JLE       // If R1 <= 0 → no need to loop → jump to END

@R3
M=0         // Reset counter (R3) to 0

@R0
D=M
@R4
M=D         // Load starting address from R0 and save it to R4 (pointer)

@R7
M=0         // Clear R7 → for later use or tidiness

(LOOP)
@R3
D=M
@R1
D=D-M
@END_LOOP
D;JEQ       // If counter == R1 → done → jump to END_LOOP

@R4
A=M
D=M
@R2
M=D+M       // Add value at address R4 to sum (R2)

@R4
M=M+1       // Move pointer to next address

@R3
M=M+1       // Increase counter by 1

@R8
M=0         // Clear R8 → just to keep memory clean and organized

@LOOP
0;JMP       // Repeat loop

(END_LOOP)
@R9
M=0         // Clear R9 → optional, keeping it clean

(END)
@END
0;JMP       // Finished → stop here