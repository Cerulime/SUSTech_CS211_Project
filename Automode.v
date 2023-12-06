module Automode (
    input clk, en,
    input [2:0] song,
    output [6:0] led,
    output buzzer
);
wire [2:0] octave;
wire [2:0] note;
wire [3:0] length;
wire [2:0] full_note;
wire over;
    Sound sd(clk, en, octave, note, length, full_note, buzzer, over);
reg [2:0] song_input;
reg [31:0] cnt;
wire [31:0] track;
    Song sg(song_input, cnt, track, octave, note, length, full_note);
    Light lt(clk, en, note, led);
    always @(posedge clk) begin
        if (en) begin
            if (over) begin
                if (cnt < track) begin
                    cnt <= cnt + 1;
                end else begin
                    cnt <= 0;
                    song_input <= song_input + 1;
                end
            end
        end else begin
            cnt <= 0;
            song_input <= song;
        end
    end
endmodule