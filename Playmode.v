/**
 * @module Playmode
 * @brief This module represents the play mode of a game.
 *
 * The Playmode module controls the gameplay logic, including handling user input,
 * generating sound, scoring, and displaying LED indicators. It interacts with other
 * modules such as Pulse, Hit, Sound, Song, Scoring, Light, Scoreboard, and Max.
 *
 * @param clk The clock input
 * @param en The enable input
 * @param rst_n The active-low reset input
 * @param en_hit The enable hit input
 * @param oct_up The octave up input
 * @param oct_down The octave down input
 * @param note_key The note key input
 * @param length_key The length key input
 * @param system_clock The system clock input
 * @param song The song input
 * @param user The user input
 * @param mod The mod input
 * @param difficulty The difficulty input
 * @param note_led The note LED output
 * @param level_led The level LED output
 * @param buzzer The buzzer output
 * @param seg_en The segment enable output
 * @param tube1 The tube 1 output
 * @param tube2 The tube 2 output
 */

`include "Hit.v"
`include "Pulse.v"
`include "Sound.v"
`include "Song.v"
`include "Scoring.v"
`include "Light.v"
`include "Scoreboard.v"
`include "Max.v"
`include "Constants.vh"
module Playmode(
    input clk, en, rst_n,
    input en_hit, oct_up, oct_down,
    input [`NOTE_KEY_BITS-1:0] note_key,
    input [`LENGTH_KEY_BITS-1:0] length_key,
    input [`CLOCK_BITS-1:0] system_clock,
    input [`SONG_BITS-1:0] song,
    input [`USER_BITS-1:0] user,
    input [1:0] mod,
    input [3:0] difficutly,
    output [`NOTE_KEY_BITS-1:0] note_led,
    output [`NOTE_KEY_BITS-1:0] level_led,
    output reg buzzer,
    output reg [`TUBE_BITS-1:0] seg_en,
    output reg [`TUBE_BITS-1:0] tube1,
    output reg [`TUBE_BITS-1:0] tube2
);
wire [`CLOCK_BITS-1:0] clock;
wire [`OCTAVE_BITS-1:0] octave;
wire [`NOTE_BITS-1:0] note;
wire [`LENGTH_BITS-1:0] length;
reg [`OCTAVE_BITS-1:0] octave_in;
wire over;
    Hit ht(clk, ~over, rst_n, octave_in, oct_up, oct_down, note_key, length_key, system_clock, 
           clock, octave, note, length);
    always @(*) begin
        if (en) begin
            octave_in = octave;
        end else begin
            octave_in = 3'b100;
        end
    end
wire [`FULL_NOTE_BITS-1:0] full_note;
reg [`FULL_NOTE_BITS-1:0] full_note_mod;
    always @(*) begin
        case (mod)
            2'b10: full_note_mod = full_note * 2; // Half Time
            2'b11: full_note_mod = full_note / 2; // Double Time
            default: full_note_mod = full_note;
        endcase
    end
wire [`OCTAVE_BITS-1:0] goal_octave;
wire [`NOTE_BITS-1:0] goal_note;
wire [`LENGTH_BITS-1:0] goal_length;
wire buzzer_sd;
    Sound sd(clk, en, goal_octave, goal_note, goal_length, full_note_mod, buzzer_sd, over);
reg [`SONG_BITS-1:0] song_input;
reg [`SONG_CNT_BITS-1:0] cnt;
wire [`SONG_CNT_BITS-1:0] track;
    Song sg(song_input, cnt, track, goal_octave, goal_note, goal_length, full_note);
    Light nlt(en, goal_note, note_led);
reg [`CLOCK_BITS-1:0] goal_clock;
    always @(posedge clk) begin
        if (en) begin
            if (over) begin
                if (cnt < track) begin
                    cnt <= cnt + 1;
                    goal_clock <= system_clock;
                end
            end
        end else begin
            cnt <= 0;
            song_input <= song;
            goal_clock <= 0;
        end
    end
reg [`MAX_NUM-1:0] base_score, bonus_score, last_combo;
wire [`MAX_NUM-1:0] base_temp, bonus_temp, combo;
wire [`MAX_NUM-1:0] acc;
wire [2:0] level;
    Scoring sc(clk, clock, octave, note, length, 
               goal_clock, goal_octave, goal_note, goal_length, 
               last_combo, cnt, track, mod, difficutly, base_score, 
               base_temp, bonus_temp, combo, acc, level);
    Light llt(en, level, level_led);
wire [`TUBE_BITS-1:0] pl_seg_en, pl_tube1, pl_tube2;
    Scoreboard sb(clk, en, 
                  combo, mod, difficutly, base_score, bonus_score, acc, level, 
                  pl_seg_en, pl_tube1, pl_tube2);
wire [`TUBE_BITS-1:0] usr_seg_en, usr_tube1, usr_tube2;
    Scoreboard high(clk, en, 
                    combo_user[user], mod, difficutly, base_score_user[user], bonus_score_user[user], acc_user[user], level_user[user], 
                    usr_seg_en, usr_tube1, usr_tube2);
    always @(*) begin
        if (cnt == track) begin
            seg_en = usr_seg_en;
            tube1 = usr_tube1;
            tube2 = usr_tube2;
            buzzer = 0;
        end else begin
            seg_en = pl_seg_en;
            tube1 = pl_tube1;
            tube2 = pl_tube2;
            buzzer = buzzer_sd;
        end
    end
reg can_add;
    always @(posedge clk) begin
        if (en) begin
            if (over == 0 && can_add && note_key != 7) begin
                base_score <= base_score + base_temp;
                bonus_score <= bonus_score + bonus_temp;
                last_combo <= combo;
                can_add <= 0;
            end else if (over) begin
                can_add <= 1;
            end
        end else begin
            base_score <= 0;
            bonus_score <= 0;
            last_combo <= 0;
            can_add <= 0;
        end
    end
reg [`MAX_NUM-1:0] combo_user [(1<<`USER_BITS)-1:0];
reg [`MAX_NUM-1:0] acc_user [(1<<`USER_BITS)-1:0];
reg [2:0] level_user [(1<<`USER_BITS)-1:0];
reg [`MAX_NUM-1:0] base_score_user [(1<<`USER_BITS)-1:0];
reg [`MAX_NUM-1:0] bonus_score_user [(1<<`USER_BITS)-1:0];
wire [`MAX_NUM-1:0] combo_user_new;
wire [`MAX_NUM-1:0] acc_user_new;
wire [2:0] level_user_new;
wire [`MAX_NUM-1:0] base_score_user_new;
wire [`MAX_NUM-1:0] bonus_score_user_new;
    Max max_combo(combo_user[user], last_combo, combo_user_new);
    Max max_acc(acc_user[user], acc, acc_user_new);
    Max max_level({18'b0, level_user[user]}, level, level_user_new);
    Max max_base_score(base_score_user[user], base_score, base_score_user_new);
    Max max_bonus_score(bonus_score_user[user], bonus_score, bonus_score_user_new);
integer i;
    always @(posedge clk, negedge rst_n) begin
        if (~rst_n) begin
            for (i = 0; i < (1<<`USER_BITS); i = i + 1) begin
                combo_user[i] <= 0;
                acc_user[i] <= 0;
                level_user[i] <= 0;
                base_score_user[i] <= 0;
                bonus_score_user[i] <= 0;
            end
        end else begin
            if (en) begin
                if (cnt == track) begin
                    combo_user[user] <= combo_user_new;
                    acc_user[user] <= base_score_user_new * 10 / (track * 3);
                    level_user[user] <= level;
                    base_score_user[user] <= base_score_user_new;
                    bonus_score_user[user] <= bonus_score_user_new;
                end
            end
        end
    end
endmodule