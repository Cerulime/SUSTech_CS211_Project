module Hit(
    input clk, en,
    input oct_up, oct_down,
    input [6:0] note_key,
    input [6:0] length_key,
    input [31:0] system_clock,
    output [31:0] clock,
    output [2:0] octave,
    output [2:0] note,
    output [3:0] length
);
reg [2:0] now_octave;
reg [2:0] now_note;
reg [3:0] now_length;
reg [31:0] now_clock;
integer i;
    always @(posedge clk) begin
        if (en) begin
            case ({oct_up, oct_down})
                2'b01: now_octave <= now_octave - 1;
                2'b10: now_octave <= now_octave + 1;
                default: now_octave <= now_octave;
            endcase
            for (i = 0; i < 7; i = i + 1) begin
                if (note_key[i]) begin
                    now_note <= i;
                end
                if (length_key[i]) begin
                    now_length <= i;
                end
            end
            now_clock <= system_clock;
        end else begin
            now_octave <= 4;
            now_note <= 0;
            now_length <= 0;
            now_clock <= 0;
        end
    end
    assign octave = now_octave;
    assign note = now_note;
    assign length = now_length;
    assign clock = now_clock;
endmodule