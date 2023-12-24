`include "Constants.vh"
module RAM(
    input rst_n, rw,
    input [`NOTE_KEY_BITS-1:0] addr,
    input [`NOTE_KEY_BITS-1:0] in,
    output [`NOTE_KEY_BITS-1:0] out
);
reg [`NOTE_KEY_BITS-1:0] mem [`NOTE_KEY_BITS-1:0];
integer i;
    always @* begin
        if (!rst_n) begin
            for (i = 0; i < `NOTE_KEY_BITS; i = i + 1)
                mem[i] = (7'b1 << i);
        end else begin
            if (rw) begin
                for (i = 0; i < `NOTE_KEY_BITS; i = i + 1)
                    if (addr & (7'b1 << i))
                        mem[i] = in;
            end
        end
    end
    assign out = mem[addr];
endmodule