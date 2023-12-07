module Playmode(
    input clk, en,
    input oct_up, oct_down,
    input [6:0] note_key,
    input [6:0] length_key,
    input [2:0] song,
    input [1:0] mod,
    input [3:0] difficutly,
    output reg [6:0] note_led,
    output reg [6:0] level_led,
    output buzzer,
    output ctr1,
    output [7:0] tube1,
    output ctr2,
    output [7:0] tube2
);
reg [20:0] microsecond;
reg [31:0] system_clock;
reg [31:0] goal_clock;
    always @(posedge clk) begin
        if (en) begin
            if (microsecond < 100000) begin
                microsecond <= microsecond + 1;
            end else begin
                microsecond <= 0;
                system_clock <= system_clock + 1;
            end
        end else begin
            microsecond <= 0;
            system_clock <= 0;
        end
    end
wire [31:0] clock;
wire [2:0] octave;
wire [2:0] note;
wire [3:0] length;
reg en_hit;
    Hit ht(clk, en_hit, oct_up, oct_down, note_key, length_key, system_clock, 
           clock, octave, note, length);
wire [2:0] full_note;
wire over;
    Sound sd(clk, en, octave, note, length, full_note, buzzer, over);
reg [2:0] song_input;
reg [20:0] cnt;
wire [20:0] track;
wire [2:0] goal_octave;
wire [2:0] goal_note;
wire [3:0] goal_length;
    Song sg(song_input, cnt, track, goal_octave, goal_note, goal_length, full_note);
    Light nlt(clk, en, goal_note, note_led);
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
            end
        end else begin
            cnt <= 0;
            song_input <= song;
            en_hit <= 0;
        end
    end
wire [6:0] mod_mutiplier [3:0];
wire [6:0] mod_divider [3:0];
assign mod_mutiplier[0] = 100; // Normal
assign mod_divider[0] = 100;
assign mod_mutiplier[1] = 50; // NoFail
assign mod_divider[1] = 100;
assign mod_mutiplier[2] = 50; // HalfTime
assign mod_divider[2] = 100;
assign mod_mutiplier[3] = 100; // DoubleTime
assign mod_divider[3] = 110;
reg [20:0] base_score, bonus_score, last_combo;
wire [20:0] base_temp, bonus_temp, combo;
wire [20:0] acc;
wire [2:0] level;
    Scoring sc(clock, octave, note, length, 
               goal_clock, goal_octave, goal_note, goal_length, 
               last_combo, cnt, track, mod_mutiplier[mod], mod_divider[mod], difficutly, base_score, 
               base_temp, bonus_temp, combo, acc, level);
    Light llt(clk, en, level, level_led);
    Scoreboard sb(clk, en, 
                  combo, mod, difficutly, base_score, bonus_score, acc, level, 
                  ctr1, tube1, ctr2, tube2);
    always @(posedge clk) begin
        if (en) begin
            if (over) begin
                base_score <= base_score + base_temp;
                bonus_score <= bonus_score + bonus_temp;
                last_combo <= combo;
                en_hit <= 1;
            end else begin
                en_hit <= 0;
            end
        end else begin
            base_score <= 0;
            bonus_score <= 0;
        end
    end
endmodule