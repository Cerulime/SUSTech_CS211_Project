module Freemode (
    input clk, en,
    input [2:0] octave,
    input [2:0] note,
    input [3:0] length,
    output reg [6:0] led,
    output buzzer
);
wire over;
    Sound sd(clk, en, octave, note, length, full_note, buzzer, over);
    Light lt(clk, en, note, led);

    // TODO: VGA
endmodule