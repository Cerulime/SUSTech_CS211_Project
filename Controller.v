`include "Constants.vh"
module Controller (
    input clk, rst_n,
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
    
endmodule