/**
 * @module Hit
 * @brief This module represents a hit in a musical instrument.
 *
 * The Hit module receives various inputs such as clock, enable, reset, octave, note key, length key, and system clock.
 * It generates outputs for octave, note, length, and clock.
 * The module includes logic to handle note and length key inputs, as well as pulse signals for octave increment and decrement.
 * The module also includes a pulse acknowledgement mechanism and a clock generation mechanism.
 */

`include "Pulse.v"
`include "Constants.vh"
module Hit(
    input clk, en, rst_n,
    input [`OCTAVE_BITS-1:0] octave_in,
    input oct_up, oct_down,
    input [`NOTE_KEY_BITS-1:0] note_key,
    input [`LENGTH_KEY_BITS-1:0] length_key,
    input [`CLOCK_BITS-1:0] system_clock,
    output [`CLOCK_BITS-1:0] clock,
    output [`OCTAVE_BITS-1:0] octave,
    output [`NOTE_BITS-1:0] note,
    output [`LENGTH_BITS-1:0] length
);
reg [`OCTAVE_BITS-1:0] now_octave;
reg [`NOTE_BITS-1:0] now_note;
reg [`LENGTH_BITS-1:0] now_length;
reg [`CLOCK_BITS-1:0] now_clock;
    always @(*) begin
        case (note_key)
            7'b0000001: now_note = 0;
            7'b0000010: now_note = 1;
            7'b0000100: now_note = 2;
            7'b0001000: now_note = 3;
            7'b0010000: now_note = 4;
            7'b0100000: now_note = 5;
            7'b1000000: now_note = 6;
            7'b0000000: now_note = 7;
            default: now_note = now_note;
        endcase
        case (length_key)
            7'b0000001: now_length = 0;
            7'b0000010: now_length = 1;
            7'b0000100: now_length = 2;
            7'b0001000: now_length = 3;
            7'b0010000: now_length = 4;
            7'b0100000: now_length = 5;
            7'b1000000: now_length = 6;
            default: now_length = now_length;
        endcase
    end
wire pulse_up, pulse_down;
    Pulse p_up(clk, rst_n, oct_up, pulse_up);
    Pulse p_down(clk, rst_n, oct_down, pulse_down);
reg pulse_ack;
    always @(posedge clk) begin
        if (en) begin
            if (now_clock == 0)
                now_clock <= system_clock;
            if (!pulse_ack) begin
                case ({pulse_up, pulse_down})
                    2'b01: now_octave = now_octave - 1;
                    2'b10: now_octave = now_octave + 1;
                    default: now_octave = now_octave;
                endcase
                pulse_ack <= pulse_up | pulse_down;
            end else begin
                pulse_ack <= pulse_up | pulse_down;
            end
        end else begin
            now_clock <= 0;
            now_octave <= octave_in;
            pulse_ack <= 0;
        end
    end
    assign octave = now_octave;
    assign note = now_note;
    assign length = now_length;
    assign clock = now_clock;
endmodule