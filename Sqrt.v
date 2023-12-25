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
    reg [20:0] last, square;
    integer i;
    always @* begin
        last = 0;
        square = 0;
        for (i = 10; i >= 0; i = i - 1) begin
            last = last | (1 << i);
            square = last * last;
            if (square > x) begin
                last = last & ~(1 << i);
            end
        end
    end
    assign y = last;
endmodule