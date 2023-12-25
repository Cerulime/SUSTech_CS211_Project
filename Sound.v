/**
 * @module Sound
 * @brief This module generates a sound signal based on the input parameters.
 *
 * The Sound module takes in various input signals such as clk, en, octave, note, length, and full_note,
 * and generates a sound signal on the buzzer output. The sound signal is generated using a PWM technique
 * based on the octave and note values. The length of the sound signal is controlled by the length and full_note
 * parameters. The module also includes internal registers and counters to control the timing and duration of the sound signal.
 */
`include "Constants.vh"
module Sound(
    input clk, en,
    input [`OCTAVE_BITS-1:0] octave,
    input [`NOTE_BITS-1:0] note,
    input [`LENGTH_BITS-1:0] length,
    input [`FULL_NOTE_BITS-1:0] full_note,
    output buzzer,
    output reg over
);
wire [7:0] pow [6:0];
assign pow[0] = 1;
assign pow[1] = 2;
assign pow[2] = 4;
assign pow[3] = 8;
assign pow[4] = 16;
assign pow[5] = 32;
assign pow[6] = 64;

wire [20:0] center[6:0];
assign center[0] = 382219;
assign center[1] = 340530;
assign center[2] = 303370;
assign center[3] = 286344;
assign center[4] = 255102;
assign center[5] = 227273;
assign center[6] = 202478;
reg [20:0] pwm;
    always @(*) begin
        case (octave)
            3'b000: pwm = center[note] * 16;
            3'b001: pwm = center[note] * 8;
            3'b010: pwm = center[note] * 4;
            3'b011: pwm = center[note] * 2;
            3'b100: pwm = center[note];
            3'b101: pwm = center[note] / 2;
            3'b110: pwm = center[note] / 4;
            3'b111: pwm = center[note] / 8;
        endcase
    end

reg [20:0] pwm_counter;
reg [31:0] length_counter;
reg buzz_state;

    always @(posedge clk) begin
        if(en) begin
            if(pwm_counter >= pwm) begin
                pwm_counter <= 0;
                buzz_state <= ~buzz_state;
            end else begin
                pwm_counter <= pwm_counter + (1-over);
            end

            if(length_counter >= (full_note * 100000000 / pow[length])) begin
                length_counter <= 0;
                over <= 1;
            end else begin
                length_counter <= length_counter + 1;
                over <= 0;
            end
        end else begin
            pwm_counter <= 0;
            length_counter <= 0;
            buzz_state <= 0;
            over <= 1;
        end
    end

    assign buzzer = buzz_state & ~over & ~(note==`null);

endmodule