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
    input clk, rst_n, rw,
    input [`NOTE_KEY_BITS-1:0] addr,
    input [`NOTE_KEY_BITS-1:0] in,
    output [`NOTE_KEY_BITS-1:0] out
);
reg [`NOTE_KEY_BITS-1:0] mem [`NOTE_KEY_BITS-1:0];
reg [`NOTE_KEY_BITS-1:0] get;

    always @(posedge clk, negedge rst_n) begin
        if (!rst_n) begin
            mem[0] <= 7'b0000001;
            mem[1] <= 7'b0000010;
            mem[2] <= 7'b0000100;
            mem[3] <= 7'b0001000;
            mem[4] <= 7'b0010000;
            mem[5] <= 7'b0100000;
            mem[6] <= 7'b1000000;
        end else begin
            if (rw) begin
                case (addr)
                    7'b0000001: mem[0] <= in;
                    7'b0000010: mem[1] <= in;
                    7'b0000100: mem[2] <= in;
                    7'b0001000: mem[3] <= in;
                    7'b0010000: mem[4] <= in;
                    7'b0100000: mem[5] <= in;
                    7'b1000000: mem[6] <= in;
                    default: mem[0] <= mem[0];
                endcase
            end
            case (addr)
                7'b0000001: get <= mem[0];
                7'b0000010: get <= mem[1];
                7'b0000100: get <= mem[2];
                7'b0001000: get <= mem[3];
                7'b0010000: get <= mem[4];
                7'b0100000: get <= mem[5];
                7'b1000000: get <= mem[6];
                default: get <= 7'b0000000;
            endcase
        end
    end

    assign out = get;
endmodule