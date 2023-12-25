/**
 * Scoring module calculates the score, bonus, combo, accuracy, and level based on the input parameters.
 *
 * @module Scoring
 * @param clock The clock signal.
 * @param octave The current octave.
 * @param note The current note.
 * @param length The length of the current note.
 * @param goal_clock The goal clock signal.
 * @param goal_octave The goal octave.
 * @param goal_note The goal note.
 * @param goal_length The length of the goal note.
 * @param last_combo The previous combo value.
 * @param now_cnt The current count.
 * @param total_note The total number of notes.
 * @param mod The game mode.
 * @param difficulty The game difficulty.
 * @param last_base_score The previous base score.
 * @param base_score The calculated base score.
 * @param bonus_score The calculated bonus score.
 * @param combo The current combo.
 * @param acc The accuracy.
 * @param level The game level.
 */

`include "Sqrt.v"
`include "Constants.vh"
module Scoring(
    input [`CLOCK_BITS-1:0] clock,
    input [`OCTAVE_BITS-1:0] octave,
    input [`NOTE_BITS-1:0] note,
    input [`LENGTH_BITS-1:0] length,
    input [`CLOCK_BITS-1:0] goal_clock,
    input [`OCTAVE_BITS-1:0] goal_octave,
    input [`NOTE_BITS-1:0] goal_note,
    input [`LENGTH_BITS-1:0] goal_length,
    input [20:0] last_combo,
    input [20:0] now_cnt,
    input [20:0] total_note,
    input [1:0] mod,
    input [3:0] difficutly,
    input [20:0] last_base_score,
    output reg [20:0] base_score,
    output reg [20:0] bonus_score,
    output reg [20:0] combo,
    output reg [20:0] acc,
    output reg [2:0] level
);
reg [6:0] mod_mutiplier, mod_divider;
    always @(mod) begin
        case (mod)
            2'b00: begin // Normal
                mod_mutiplier = 100;
                mod_divider = 100;
            end
            2'b01: begin // No Fail
                mod_mutiplier = 50;
                mod_divider = 100;
            end
            2'b10: begin // Half Time
                mod_mutiplier = 50;
                mod_divider = 100;
            end
            2'b11: begin // Double Time
                mod_mutiplier = 100;
                mod_divider = 110;
            end
        endcase
    end
reg [20:0] hit_score;
reg [20:0] hit_bonus;
reg [20:0] timer;
reg [20:0] one_hit_score;
localparam P = 16, S = 64, A = 97, B = 127, C = 188;
wire [20:0] sqrt_combo;
    Sqrt sqrt(combo, sqrt_combo);
    always @(*) begin
        if (clock < goal_clock) begin
            timer = goal_clock - clock;
        end else begin
            timer = clock - goal_clock;
        end
        // if (octave != goal_octave || note != goal_note || length != goal_length) begin
        if (note != goal_note) begin
            hit_score = 0;
            hit_bonus = 0;
            combo = 0;
        end else begin
            if (timer < P) begin
                hit_score = 320;
                hit_bonus = 32;
                combo = last_combo + 2;
            end else if (timer < S - difficutly * 3) begin
                hit_score = 300;
                hit_bonus = 32;
                combo = last_combo + 1;
            end else if (timer < A - difficutly * 3) begin
                hit_score = 200;
                hit_bonus = 16;
                combo = (last_combo - 8) * 100 / mod_divider;
            end else if (timer < B - difficutly * 3) begin
                hit_score = 100;
                hit_bonus = 8;
                combo = (last_combo - 24) * 100 / mod_divider;
            end else if (timer < C - difficutly * 3) begin
                hit_score = 50;
                hit_bonus = 4;
                combo = (last_combo - 44) * 100 / mod_divider;
            end else begin
                hit_score = 0;
                hit_bonus = 0;
                combo = 0;
            end
        end
        one_hit_score = 5000 * mod_mutiplier / total_note;
        base_score = one_hit_score * hit_score / 320;
        bonus_score = one_hit_score * hit_bonus * sqrt_combo / 32;
        if (now_cnt == 0)
            acc = 10000;
        else
            acc = {5'b0, last_base_score} * 10 / (now_cnt * 3);
        if (acc >= 10000 && mod_divider > 100) begin
            level = 0;
        end else if (acc >= 10000) begin
            level = 1;
        end else if (acc >= 9500) begin
            level = 2;
        end else if (acc >= 9000) begin
            level = 3;
        end else if (acc >= 8000) begin
            level = 4;
        end else if (acc >= 7000) begin
            level = 5;
        end else begin
            level = 6;
        end
    end
endmodule