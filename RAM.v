`include "Constants.vh"

/**
 * RAM module
 *
 * This module represents a RAM (Random Access Memory) block.
 * It stores and retrieves data based on the provided address.
 *
 * @param rst_n     Reset signal (active low)
 * @param rw        Read/Write control signal
 * @param addr      Address input
 * @param in        Data input
 * @param out       Data output
 */
module RAM(
    input rst_n, rw,
    input [`NOTE_KEY_BITS-1:0] addr,
    input [`NOTE_KEY_BITS-1:0] in,
    output [`NOTE_KEY_BITS-1:0] out
);
reg [`NOTE_KEY_BITS-1:0] mem [`NOTE_KEY_BITS-1:0];
integer i;

    /**
     * RAM behavior
     *
     * This always block describes the behavior of the RAM module.
     * It handles the reset, read, and write operations.
     */
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