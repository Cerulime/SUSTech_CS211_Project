`include "Constants.vh"
module Light(
    input clk, en,
    input [`NOTE_BITS-1:0] note
    output reg [`NOTE_KEY_BITS-1:0] led
);
    always @(posedge clk) begin
        if(en) begin
            led <= 7'b0000001 << note;
        end else begin
            led <= 7'b0000000;
        end
    end
endmodule