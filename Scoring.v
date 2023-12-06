module Scoring(
    input [31:0] clock,
    input [2:0] octave,
    input [2:0] note,
    input [3:0] length,
    input [31:0] goal_clock,
    input [2:0] goal_octave,
    input [2:0] goal_note,
    input [3:0] goal_length,
    input [20:0] last_combo,
    input [20:0] now_cnt,
    input [20:0] total_note,
    input [6:0] mod_mutiplier,
    input [6:0] mod_divider,
    input [3:0] difficutly,
    input [20:0] last_base_score,
    output reg [20:0] base_score,
    output reg [20:0] bonus_score,
    output reg [20:0] combo,
    output reg [2:0] level
);
reg [20:0] hit_score;
reg [20:0] hit_bonus;
reg [20:0] timer;
reg [20:0] one_hit_score;
localparam P = 16, S = 64, A = 97, B = 127, C = 188;
wire [20:0] sqrt_combo;
    Sqrt sqrt(combo, sqrt_combo);
reg [20:0] acc;
    always @(*) begin
        if (clock < goal_clock) begin
            timer = goal_clock - clock;
        end else begin
            timer = clock - goal_clock;
        end
        if (octave != goal_octave || note != goal_note || length != goal_length) begin
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
        one_hit_score = 500000 * mod_mutiplier / 100 / total_note;
        base_score = one_hit_score * hit_score / 320;
        bonus_score = one_hit_score * hit_bonus * sqrt_combo / 32;
        acc = {10'b0, last_base_score} * 1000 / (now_cnt * 300);
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