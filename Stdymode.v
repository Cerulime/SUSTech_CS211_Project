`include "Constants.vh"
module Stdymode(
    input clk, en, rst_n,
    input en_hit, oct_up, oct_down,
    input [`NOTE_KEY_BITS-1:0] note_key,
    input [`LENGTH_KEY_BITS-1:0] length_key,
    input [`CLOCK_BITS-1:0] system_clock,
    input [`SONG_BITS-1:0] song,
    input is_record, is_rw,
    output [`NOTE_KEY_BITS-1:0] note_led,
    output buzzer,
    output ctr1,
    output [`TUBE_BITS-1:0] tube1,
    output ctr2,
    output [`TUBE_BITS-1:0] tube2
);
wire [`CLOCK_BITS-1:0] clock;
wire [`OCTAVE_BITS-1:0] octave;
wire [`NOTE_BITS-1:0] note;
wire [`LENGTH_BITS-1:0] length;
    Hit ht(clk, en, rst_n, oct_up, oct_down, note_key, length_key, system_clock, 
           clock, octave, note, length);
reg en_sd;
    Pulse psd(clk, rst_n, en_hit, en_sd);
wire [`FULL_NOTE_BITS-1:0] full_note;
wire over;
    Sound sd(clk, en_sd, octave, note, length, full_note, buzzer, over);
    always @(over) begin
        en_sd <= en_sd | ~over;
    end
reg [`SONG_BITS-1:0] song_input;
reg [`SONG_CNT_BITS-1:0] cnt;
wire [`SONG_CNT_BITS-1:0] track;
wire [`OCTAVE_BITS-1:0] goal_octave;
wire [`NOTE_BITS-1:0] goal_note;
wire [`LENGTH_BITS-1:0] goal_length;
    Song sg(song_input, cnt, track, goal_octave, goal_note, goal_length, full_note);
reg en_rec;
reg [`REC_CNT_BITS-1:0] rec_cnt;
wire [`OCTAVE_BITS-1:0] rec_octave;
wire [`NOTE_BITS-1:0] rec_note;
wire [`LENGTH_BITS-1:0] rec_length;
wire [`FULL_NOTE_BITS-1:0] rec_full_note;
    Record rc(is_rw, en_rec, rec_cnt, octave, note, length, full_note, 
              rec_octave, rec_note, rec_length, rec_full_note);
    Light nlt(clk, en, goal_note, note_led);
    always @(posedge clk) begin
        if (en) begin
            if (!is_record) begin
                en_rec <= 0;
                rec_cnt <= 0;
                if (over) begin
                    if (cnt < track) begin
                        cnt <= cnt + 1;
                        song_input <= song;
                    end else begin
                        cnt <= 0;
                        song_input <= 0;
                    end
                end
            end else begin
                if (is_rw) begin
                    if (en_sd) begin
                        en_rec <= 1;
                    end else begin
                        en_rec <= 0;
                    end
                    if (rec_cnt < (1<<`REC_CNT_BITS)-1) begin
                        rec_cnt <= rec_cnt + 1;
                    end else begin
                        rec_cnt <= 0;
                    end
                end else begin
                    en_rec <= 1;
                    if (over) begin
                        if (rec_cnt < (1<<`REC_CNT_BITS)-1) begin
                            rec_cnt <= rec_cnt + 1;
                        end else begin
                            rec_cnt <= 0;
                        end
                    end
                end
            end
        end else begin
            cnt <= 0;
            song_input <= song;
            en_hit <= 0;
            en_rec <= 0;
            rec_cnt <= 0;
        end
    end
endmodule