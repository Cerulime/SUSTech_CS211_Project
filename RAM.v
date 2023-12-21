`include "Constants.vh"
module RAM(
    input rst_n, rw0, rw1
    input [`NOTE_KEY_BITS-1:0] addr0,
    input [`LENGTH_KEY_BITS-1:0] addr1,
    input [`NOTE_KEY_BITS-1:0] in0,
    input [`LENGTH_KEY_BITS-1:0] in1,
    output [`NOTE_KEY_BITS-1:0] out0,
    output [`LENGTH_KEY_BITS-1:0] out1,
);
reg [`NOTE_KEY_BITS-1:0] mem0 [`NOTE_KEY_BITS-1:0];
reg [`LENGTH_KEY_BITS-1:0] mem1 [`LENGTH_KEY_BITS-1:0];
integer i;
    always @* begin
        if (!rst_n) begin
            for (i = 0; i < `NOTE_KEY_BITS-1; i = i + 1)
                mem0[i] = (7'b1 << i);
            for (i = 0; i < `LENGTH_KEY_BITS-1; i = i + 1)
                mem1[i] = (7'b1 << i);
        end else begin
            if (rw0) begin
                for (i = 0; i < `NOTE_KEY_BITS-1; i = i + 1)
                    if (addr0 & (7'b1 << i))
                        mem0[i] = in0;
            end
            if (rw1) begin
                for (i = 0; i < `LENGTH_KEY_BITS-1; i = i + 1)
                    if (addr1 & (7'b1 << i))
                        mem1[i] = in1;
            end
        end
    end
    assign out0 = mem0[addr0];
    assign out1 = mem1[addr1];
endmodule