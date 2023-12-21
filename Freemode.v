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
reg en_sd;
    Pulse psd(clk, rst_n, en_hit, en_sd);
wire over;
    Sound sd(clk, en_sd, octave, note, length, full_note, buzzer, over);
    always @(over) begin
        en_sd <= en_sd | ~over;
    end
    Light lt(en_sd, note, led);
    always @(posedge clk) begin
        if (en) begin
            if (over) begin
                en_hit <= 1;
            end else begin
                en_hit <= 0;
            end
        end else begin
            en_hit <= 0;
        end
    end

    // TODO: VGA
endmodule