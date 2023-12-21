`include "Constants.vh"
module Freemode (
    input clk, en, rst_n,
    input en_hit, oct_up, oct_down,
    input [`NOTE_KEY_BITS-1:0] note_key,
    input [`LENGTH_KEY_BITS-1:0] length_key,
    input [`CLOCK_BITS-1:0] system_clock,
    output reg [`NOTE_KEY_BITS-1:0] led,
    output buzzer
);
wire [`CLOCK_BITS-1:0] clock;
wire [`OCTAVE_BITS-1:0] octave;
wire [`NOTE_BITS-1:0] note;
wire [`LENGTH_BITS-1:0] length;
    Hit ht(clk, en, rst_n, oct_up, oct_down, note_key, length_key, system_clock, 
           clock, octave, note, length);
wire en_sd_out;
reg en_sd;
    Pulse psd(clk, rst_n, en_hit, en_sd_out);
wire over;
    Sound sd(clk, en_sd, octave, note, length, 3'b100, buzzer, over);
    always @(*) begin
        en_sd <= en_sd_out | ~over;
    end
    Light lt(en_sd, note, led);
endmodule