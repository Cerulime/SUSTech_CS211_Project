module Max(
    input [20:0] x, y,
    output [20:0] z
);
    assign z = x > y ? x : y;
endmodule