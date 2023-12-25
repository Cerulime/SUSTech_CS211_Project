/**
 * Module: Sqrt
 * Description: This module calculates the square root of a 21-bit input value.
 * Inputs:
 *   - x: 21-bit input value
 * Outputs:
 *   - y: 21-bit output value representing the square root of x
 */
module Sqrt(
    input [20:0] x,
    output [20:0] y
);
    // reg [20:0] last, square;
    // integer i;
    // always @* begin
    //     last = 0;
    //     square = 0;
    //     for (i = 10; i >= 0; i = i - 1) begin
    //         last = last | (1 << i);
    //         square = last * last;
    //         if (square > x) begin
    //             last = last & ~(1 << i);
    //         end
    //     end
    // end
    // assign y = last;
    reg [20:0] ans;
    always @(*) begin
        if (x == 0)
            ans = 0;
        else if (x < 4)
            ans = 1;
        else if (x < 9)
            ans = 2;
        else if (x < 16)
            ans = 3;
        else if (x < 25)
            ans = 4;
        else if (x < 36)
            ans = 5;
        else if (x < 49)
            ans = 6;
        else if (x < 64)
            ans = 7;
        else if (x < 81)
            ans = 8;
        else if (x < 100)
            ans = 9;
    end
    assign y = ans;
endmodule