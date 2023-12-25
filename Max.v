`include "Constants.vh"
module Max(
    input [`MAX_NUM-1:0] x, y,
    output [`MAX_NUM-1:0] z
);
    assign z = x > y ? x : y;
endmodule