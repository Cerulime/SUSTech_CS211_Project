/**
 * Automode module
 *
 * This module implements an automatic mode for playing songs on a device. It takes inputs for clock signal, enable signal, song selection, and outputs LED display and buzzer control signals.
 *
 * Inputs:
 * - clk: Clock signal
 * - en: Enable signal
 * - song: Song selection
 *
 * Outputs:
 * - led: LED display control signal
 * - buzzer: Buzzer control signal
 *
 * Modules used:
 * - Sound: Generates sound signals based on inputs
 * - Song: Manages song playback and timing
 * - Light: Controls LED display based on note inputs
 */

`include "Sound.v"
`include "Song.v"
`include "Light.v"
`include "Constants.vh"
module Automode (
    input clk, en,
    input [`SONG_BITS-1:0] song,
    output [`NOTE_KEY_BITS-1:0] led,
    output buzzer
);
wire [`OCTAVE_BITS-1:0] octave;
wire [`NOTE_BITS-1:0] note;
wire [`LENGTH_BITS-1:0] length;
wire [`FULL_NOTE_BITS-1:0] full_note;
wire over;
    Sound sd(clk, en, octave, note, length, full_note, buzzer, over);
reg [`SONG_BITS-1:0] song_input;
reg [`SONG_CNT_BITS-1:0] cnt;
wire [`SONG_CNT_BITS-1:0] track;
    Song sg(song_input, cnt, track, octave, note, length, full_note);
    Light lt(en, note, led);
    always @(posedge clk) begin
        if (en) begin
            if (song_input != `no_song) begin
                if (over) begin
                    if (cnt < track) begin
                        cnt <= cnt + 1;
                    end else begin
                        cnt <= 0;
                        song_input <= song_input + 1;
                    end
                end
            end
        end else begin
            cnt <= 0;
            song_input <= song;
        end
    end
endmodule