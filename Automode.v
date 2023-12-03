module Automode (
    input clk, en,
    input [2:0] song,
    output reg [6:0] led,
    output buzzer
);
wire [2:0] octave;
wire [2:0] note;
wire [3:0] length;
wire [2:0] full_note;
    Sound sd(clk, en, octave, note, length, full_note, buzzer);
    always @(song) begin
        case(song)
            0: begin
                octave <= 3'b100;
                note <= 3'b000;
                length <= 4'b0000;
                full_note <= 3'b100;
            end
            1: begin
                octave <= 3'b100;
                note <= 3'b001;
                length <= 4'b0000;
                full_note <= 3'b100;
            end
            2: begin
                octave <= 3'b100;
                note <= 3'b010;
                length <= 4'b0000;
                full_note <= 3'b100;
            end
            3: begin
                octave <= 3'b100;
                note <= 3'b011;
                length <= 4'b0000;
                full_note <= 3'b100;
            end
            4: begin
                octave <= 3'b100;
                note <= 3'b100;
                length <= 4'b0000;
                full_note <= 3'b100;
            end
            5: begin
                octave <= 3'b100;
                note <= 3'b101;
                length <= 4'b0000;
                full_note <= 3'b100;
            end
            6: begin
                octave <= 3'b100;
                note <= 3'b110;
                length <= 4'b0000;
                full_note <= 3'b100;
            end
            7: begin
                octave <= 3'b100;
                note <= 3'b111;
                length <= 4'b0000;
                full_note <= 3'b100;
            end
        endcase
    end
endmodule