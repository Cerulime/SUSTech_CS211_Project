/**
 * Decompose module takes a 21-bit input number 'x' and decomposes it into individual digits.
 * The decomposed digits are stored in the output registers l0, l1, l2, l3, l4, l5, l6, and l7.
 * The input number 'x' is divided by powers of 10 to extract each digit, which are then assigned to the corresponding output registers.
 * The output registers are assigned values based on the extracted digits using a case statement.
 * If the extracted digit is 0, the corresponding output register is assigned the value of `zero.
 * If the extracted digit is 1, the corresponding output register is assigned the value of `one.
 * If the extracted digit is 2, the corresponding output register is assigned the value of `two.
 * If the extracted digit is 3, the corresponding output register is assigned the value of `three.
 * If the extracted digit is 4, the corresponding output register is assigned the value of `four.
 * If the extracted digit is 5, the corresponding output register is assigned the value of `five.
 * If the extracted digit is 6, the corresponding output register is assigned the value of `six.
 * If the extracted digit is 7, the corresponding output register is assigned the value of `seven.
 * If the extracted digit is 8, the corresponding output register is assigned the value of `eight.
 * If the extracted digit is 9, the corresponding output register is assigned the value of `nine.
 * If the extracted digit is not in the range of 0 to 9, the corresponding output register is assigned the value of `emp.
 */
`include "Constants.vh"
module Decompose(
    input [20:0] x,
    output reg [`TUBE_BITS-1:0] l0, l1, l2, l3, l4, l5, l6, l7
);
reg [3:0] r0, r1, r2, r3, r4, r5, r6, r7;
    always @* begin
        r0 = x % 10;
        r1 = (x / 10) % 10;
        r2 = (x / 100) % 10;
        r3 = (x / 1000) % 10;
        r4 = (x / 10000) % 10;
        r5 = (x / 100000) % 10;
        r6 = (x / 1000000) % 10;
        r7 = (x / 10000000) % 10;
        case(r0)
            0: l0 = `zero;
            1: l0 = `one;
            2: l0 = `two;
            3: l0 = `three;
            4: l0 = `four;
            5: l0 = `five;
            6: l0 = `six;
            7: l0 = `seven;
            8: l0 = `eight;
            9: l0 = `nine;
            default: l0 = `emp;
        endcase
        case(r1)
            0: l1 = `zero;
            1: l1 = `one;
            2: l1 = `two;
            3: l1 = `three;
            4: l1 = `four;
            5: l1 = `five;
            6: l1 = `six;
            7: l1 = `seven;
            8: l1 = `eight;
            9: l1 = `nine;
            default: l1 = `emp;
        endcase
        case(r2)
            0: l2 = `zero;
            1: l2 = `one;
            2: l2 = `two;
            3: l2 = `three;
            4: l2 = `four;
            5: l2 = `five;
            6: l2 = `six;
            7: l2 = `seven;
            8: l2 = `eight;
            9: l2 = `nine;
            default: l2 = `emp;
        endcase
        case(r3)
            0: l3 = `zero;
            1: l3 = `one;
            2: l3 = `two;
            3: l3 = `three;
            4: l3 = `four;
            5: l3 = `five;
            6: l3 = `six;
            7: l3 = `seven;
            8: l3 = `eight;
            9: l3 = `nine;
            default: l3 = `emp;
        endcase
        case(r4)
            0: l4 = `zero;
            1: l4 = `one;
            2: l4 = `two;
            3: l4 = `three;
            4: l4 = `four;
            5: l4 = `five;
            6: l4 = `six;
            7: l4 = `seven;
            8: l4 = `eight;
            9: l4 = `nine;
            default: l4 = `emp;
        endcase
        case(r5)
            0: l5 = `zero;
            1: l5 = `one;
            2: l5 = `two;
            3: l5 = `three;
            4: l5 = `four;
            5: l5 = `five;
            6: l5 = `six;
            7: l5 = `seven;
            8: l5 = `eight;
            9: l5 = `nine;
            default: l5 = `emp;
        endcase
        case(r6)
            0: l6 = `zero;
            1: l6 = `one;
            2: l6 = `two;
            3: l6 = `three;
            4: l6 = `four;
            5: l6 = `five;
            6: l6 = `six;
            7: l6 = `seven;
            8: l6 = `eight;
            9: l6 = `nine;
            default: l6 = `emp;
        endcase
        case(r7)
            0: l7 = `zero;
            1: l7 = `one;
            2: l7 = `two;
            3: l7 = `three;
            4: l7 = `four;
            5: l7 = `five;
            6: l7 = `six;
            7: l7 = `seven;
            8: l7 = `eight;
            9: l7 = `nine;
            default: l7 = `emp;
        endcase
    end
endmodule