`include "Constants.vh"
module Playmode(
    input clk, en, rst_n,
    input en_hit, oct_up, oct_down,
    input [`NOTE_KEY_BITS-1:0] note_key,
    input [`LENGTH_KEY_BITS-1:0] length_key,
    input [`CLOCK_BITS-1:0] system_clock,
    input [`SONG_BITS-1:0] song,
    input [1:0] mod,
    input [3:0] difficutly,
    output [`NOTE_KEY_BITS-1:0] note_led,
    output [6:0] level_led,
    output buzzer,
    output [`TUBE_BITS-1:0] seg_en,
    output ctr1,
    output [`TUBE_BITS-1:0] tube1,
    output ctr2,
    output [`TUBE_BITS:0] tube2
);
reg can_hit;
wire [`CLOCK_BITS-1:0] clock;
wire [`OCTAVE_BITS-1:0] octave;
wire [`NOTE_BITS-1:0] note;
wire [`LENGTH_BITS-1:0] length;
wire en_sd_out;
reg en_sd;
    Pulse pht(clk, rst_n, en_hit & can_hit, en_sd_out);
reg [`OCTAVE_BITS-1:0] octave_in;
    Hit ht(clk, en, rst_n, octave_in, oct_up, oct_down, note_key, length_key, system_clock, 
           clock, octave, note, length);
    always @(*) begin
        if (en) begin
            octave_in = octave;
        end else begin
            octave_in = 3'b100;
        end
    end
wire [`FULL_NOTE_BITS-1:0] full_note;
wire over;
    Sound sd(clk, en_sd, octave, note, length, full_note, buzzer, over);
    always @(*) begin
        en_sd <= en_sd_out | ~over;
    end
reg [`SONG_BITS-1:0] song_input;
reg [`SONG_CNT_BITS-1:0] cnt;
wire [`SONG_CNT_BITS-1:0] track;
wire [`OCTAVE_BITS-1:0] goal_octave;
wire [`NOTE_BITS-1:0] goal_note;
wire [`LENGTH_BITS-1:0] goal_length;
    Song sg(song_input, cnt, track, goal_octave, goal_note, goal_length, full_note);
    Light nlt(en_sd, goal_note, note_led);
reg [`CLOCK_BITS-1:0] goal_clock;
    always @(posedge clk) begin
        if (en) begin
            if (over) begin
                if (cnt < track) begin
                    cnt <= cnt + 1;
                    goal_clock <= system_clock;
                end else begin
                    cnt <= 0;
                    song_input <= 0;
                end
            end else begin
                cnt <= cnt;
                song_input <= song;
                goal_clock <= goal_clock;
            end
        end else begin
            cnt <= 0;
            song_input <= song;
            goal_clock <= 0;
        end
    end
//not checked
reg [20:0] base_score, bonus_score, last_combo;
wire [20:0] base_temp, bonus_temp, combo;
wire [20:0] acc;
wire [2:0] level;
    Scoring sc(clock, octave, note, length, 
               goal_clock, goal_octave, goal_note, goal_length, 
               last_combo, cnt, track, mod, difficutly, base_score, 
               base_temp, bonus_temp, combo, acc, level);
    Light llt( en, level, level_led);
    Scoreboard sb(clk, en, 
                  combo, mod, difficutly, base_score, bonus_score, acc, level, 
                  seg_en, ctr1, tube1, ctr2, tube2);
    always @(posedge clk) begin
        if (en) begin
            if (over) begin
                base_score <= base_score + base_temp;
                bonus_score <= bonus_score + bonus_temp;
                last_combo <= combo;
                can_hit <= 0;
            end else begin
                can_hit <= 1;
            end
        end else begin
            base_score <= 0;
            bonus_score <= 0;
            last_combo <= 0;
            can_hit <= 0;
        end
    end
endmodule