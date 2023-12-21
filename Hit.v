`include "Constants.vh"
module Hit(
    input clk, en, rst_n,
    input oct_up, oct_down,
    input [`NOTE_KEY_BITS-1:0] note_key,
    input [`LENGTH_KEY_BITS-1:0] length_key,
    input [`CLOCK_BITS-1:0] system_clock,
    output [`CLOCK_BITS-1:0] clock,
    output [`OCTAVE_BITS-1:0] octave,
    output [`NOTE_BITS-1:0] note,
    output [`LENGTH_BITS-1:0] length
);
reg pulse_up, pulse_down;
    Pulse p_up(clk, rst_n, oct_up, pulse_up);
    Pulse p_down(clk, rst_n, oct_down, pulse_down);
reg [`OCTAVE_BITS-1:0] now_octave;
reg [`NOTE_BITS-1:0] now_note;
reg [`LENGTH_BITS-1:0] now_length;
reg [`CLOCK_BITS-1:0] now_clock;
integer i;
    always @(oct_up, oct_down, note_key, length_key) begin
        case ({oct_up, oct_down})
            2'b01: now_octave = now_octave - 1;
            2'b10: now_octave = now_octave + 1;
            default: now_octave = now_octave;
        endcase
        for (i = 0; i < `NOTE_KEY_BITS-1; i = i + 1) begin
            if (note_key & (7'b1 << i)) begin
                now_note = i;
            end
            if (length_key & (7'b1 << i)) begin
                now_length = i;
            end
        end
    end
    always @(posedge clk) begin
        if (en) begin
            if (now_clock == 0)
                now_clock <= system_clock;
        end else begin
            now_clock <= 0;
        end
    end
    assign octave = now_octave;
    assign note = now_note;
    assign length = now_length;
    assign clock = now_clock;
endmodule