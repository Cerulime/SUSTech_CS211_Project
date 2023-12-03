module Freemode (
    input clk, en,
    input [2:0] octave,
    input [2:0] note,
    input [3:0] length,
    input [2:0] time,
    output reg [6:0] led,
    output buzzer
);
    Sound sd(clk, en, octave, note, length, time, full_note, buzzer);
    always @(posedge clk) begin
        if(en) begin
            led <= 7'b0000001 << note;
        end else begin
            led <= 7'b0000000;
        end
    end

    // TODO: VGA
endmodule