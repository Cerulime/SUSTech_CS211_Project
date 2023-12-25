/**
 * @module Stdymode
 * @brief This module represents the main control logic for the steady mode operation.
 *
 * The Stdymode module takes various inputs such as clock, enable, reset, hit signals, octave and note keys,
 * length key, system clock, song selection, record and read/write flags, and generates the necessary control
 * signals for the operation of the system. It also interfaces with other modules such as Hit, Pulse, Sound,
 * Song, Record, and Light to perform specific tasks related to sound generation, song playback, recording,
 * and LED display.
 *
 * @param clk The clock signal.
 * @param en The enable signal.
 * @param rst_n The active low reset signal.
 * @param en_hit The enable signal for hit detection.
 * @param oct_up The octave up signal.
 * @param oct_down The octave down signal.
 * @param note_key The input for note keys.
 * @param length_key The input for length keys.
 * @param system_clock The input for the system clock.
 * @param song The input for song selection.
 * @param is_record The record flag.
 * @param is_rw The read/write flag.
 * @param note_led The output for note LED display.
 * @param buzzer The output for the buzzer signal.
 */

`include "Hit.v"
`include "Pulse.v"
`include "Sound.v"
`include "Song.v"
`include "Record.v"
`include "Light.v"
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
    output buzzer
);
wire [`CLOCK_BITS-1:0] clock;
wire [`OCTAVE_BITS-1:0] octave;
wire [`NOTE_BITS-1:0] note;
wire [`LENGTH_BITS-1:0] length;
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
wire en_sd_out;
reg en_sd;
    Pulse psd(clk, rst_n, en_hit, en_sd_out);
reg [`OCTAVE_BITS-1:0] octave_sd;
reg [`NOTE_BITS-1:0] note_sd;
reg [`LENGTH_BITS-1:0] length_sd;
wire [`FULL_NOTE_BITS-1:0] full_note;
wire over;
    Sound sd(clk, en_sd, octave_sd, note_sd, length_sd, full_note, buzzer, over);
    always @(*) begin
        en_sd = en_sd_out | ~over;
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
    Record rc(rst_n, is_rw, en_rec, rec_cnt, octave, note, length, full_note, 
              rec_octave, rec_note, rec_length, rec_full_note);
    Light nlt(en, goal_note, note_led);
reg can_add;
reg is_sound;
    always @(posedge clk) begin
        if (en) begin
            if (!is_record) begin
                en_rec <= 0;
                rec_cnt <= 0;
                octave_sd <= octave;
                note_sd <= note;
                length_sd <= length;
                if (over & is_sound) begin
                    if (cnt < track) begin
                        cnt <= cnt + 1;
                        song_input <= song;
                    end else begin
                        cnt <= 0;
                        song_input <= 0;
                    end
                    is_sound <= 0;
                end else if (!over) begin
                    cnt <= cnt;
                    song_input <= song;
                    is_sound <= 1;
                end
            end else begin
                octave_sd <= rec_octave;
                note_sd <= rec_note;
                length_sd <= rec_length;
                if (is_rw) begin
                    if (en_sd) begin
                        en_rec <= 1;
                    end else begin
                        en_rec <= 0;
                    end
                    if (en_sd_out) begin
                        if (can_add) begin
                            if (rec_cnt < (1<<`REC_CNT_BITS)-1) begin
                                rec_cnt <= rec_cnt + can_add;
                                can_add <= 0;
                            end else begin
                                rec_cnt <= 0;
                                can_add <= 0;
                            end
                        end
                    end else begin
                        can_add <= 1;
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
            en_rec <= 0;
            rec_cnt <= 0;
            is_sound <= 1;
        end
    end
endmodule