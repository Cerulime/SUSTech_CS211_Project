`include "Constants.vh"
module Controller (
    input clk, rst_n, rw,
    input oct_up, oct_down,
    input [`NOTE_KEY_BITS-1:0] note_key,
    input [`LENGTH_KEY_BITS-1:0] length_key,
    input [2:0] mode,
    output buzzer,
    output ctr1,
    output [`TUBE_BITS-1:0] tube1,
    output ctr2,
    output [`TUBE_BITS-1:0] tube2
);
reg [20:0] microsecond;
reg [`CLOCK_BITS-1:0] system_clock;
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
reg [`NOTE_BITS-1:0] trans_note [`NOTE_KEY_BITS-1:0];
reg [`LENGTH_BITS-1:0] trans_length [`LENGTH_KEY_BITS-1:0];
integer i;
    always @* begin
        if (!rst_n) begin
            for (i = 0; i < `NOTE_KEY_BITS-1; i = i + 1) begin
                trans_note[i] = i;
                trans_length[i] = i;
            end
        end else begin
            if (rw) begin // TODO: write with pulse
                for (i = 0; i < `NOTE_KEY_BITS-1; i = i + 1) begin
                    if (note_key & (7'b1 << i))
                        trans_note[i] = new_note;
                    if (length_key & (7'b1 << i))
                        trans_length[i] = new_length;
                end
            end
        end
    end
endmodule