@R1
D=M          // Load divisor (R1) into D

@DIVIDE_BY_ZERO
D;JEQ        // If it's zero, can't divide, jump to DIVIDE_BY_ZERO

@R0
D=M          // Load dividend (R0)
@R5
M=0          // Set flag R5 to 0 → assume R0 is positive first

@SKIP_R0_NEG
D;JGE        // If R0 is positive, skip
@R5
M=1          // R0 is negative → mark R5 as 1
(SKIP_R0_NEG)

@R0
D=M
@ABS_R0
M=D          // Save R0 to ABS_R0

@SKIP_R0_ABS
D;JGE        // If already positive, skip
@ABS_R0
M=-D         // Make ABS_R0 positive
(SKIP_R0_ABS)

@R1
D=M
@R6
M=0          // Set flag R6 to 0 → assume R1 is positive first

@SKIP_R1_NEG
D;JGE
@R6
M=1          // R1 is negative → mark R6 as 1
(SKIP_R1_NEG)

@R1
D=M
@ABS_R1
M=D          // Save R1 to ABS_R1

@SKIP_R1_ABS
D;JGE
@ABS_R1
M=-D         // Make ABS_R1 positive
(SKIP_R1_ABS)

@ABS_R0
D=M
@32768
D=D-A
@CHECK_OVERFLOW
D;JEQ        // If ABS_R0 is exactly 32768 → possible overflow → jump

@START_DIVISION
0;JMP

(CHECK_OVERFLOW)
@ABS_R1
D=M
@1
D=D-A
@OVERFLOW_ERROR
D;JEQ        // If ABS_R1 is 1, division would overflow → jump

@TEMP
M=0          // Clear TEMP register → just to make sure it's clean
@START_DIVISION
0;JMP

(START_DIVISION)
@ABS_R0
D=M
@R3
M=D          // Copy ABS_R0 → this will be our remainder
@R2
M=0          // Reset quotient (R2)

@R7
M=0          // Clear R7 → extra space just in case

(LOOP)
@ABS_R1
D=M
@R3
D=M-D
@END_LOOP
D;JLT        // If remainder < ABS_R1 → division finished

@ABS_R1
D=M
@R3
M=M-D        // Subtract ABS_R1 from remainder

@R2
M=M+1        // Increase quotient by 1
@LOOP
0;JMP

(END_LOOP)
@R5
D=M
@R6
D=D-M
@SET_NEGATIVE_QUOTIENT
D;JNE        // If signs are different → need to make quotient negative

@SET_REMAINDER_SIGN
0;JMP

(SET_NEGATIVE_QUOTIENT)
@R2
M=-M         // Make quotient negative

(SET_REMAINDER_SIGN)
@R5
D=M
@SKIP_REMAINDER_NEG
D;JEQ        // If R0 was positive, skip
@R3
M=-M         // Else make remainder negative

(SKIP_REMAINDER_NEG)
@R4
M=0          // Set result status OK

@R9
M=0          // Clear R9 → just for tidiness

@END
0;JMP

(DIVIDE_BY_ZERO)
@R2
M=0
@R3
M=0
@R4
M=1          // Division by zero → set error status

@R10
M=0          // Clear R10 → just in case

@END
0;JMP

(OVERFLOW_ERROR)
@R2
M=0
@R3
M=0
@R4
M=1          // Overflow happened → set error status

@R11
M=0          // Clear R11 → keep clean

@END
0;JMP

(END)
@END
0;JMP        // Done → stay here forever