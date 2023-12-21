`include "Constants.vh"
module Controller (
    input clk, rst_n,
    input submit,
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
        if (!rst_n) begin
            microsecond <= 0;
            system_clock <= 0;
        end else begin
            if (microsecond < 100000) begin
                microsecond <= microsecond + 1;
            end else begin
                microsecond <= 0;
                system_clock <= system_clock + 1;
            end
        end
    end
wire rw0, rw1;
    assign rw0 = rw & (mode == `set);
    assign rw1 = rw & (mode == `set);
wire [`NOTE_KEY_BITS-1:0] addr0;
wire [`LENGTH_KEY_BITS-1:0] addr1;
    assign addr0 = note_key;
    assign addr1 = length_key;
wire [`NOTE_KEY_BITS-1:0] in0;
wire [`LENGTH_KEY_BITS-1:0] in1;
wire [`NOTE_KEY_BITS-1:0] trans_note;
wire [`LENGTH_KEY_BITS-1:0] trans_length;
    RAM ram(rst_n, rw0, rw1, addr0, addr1, in0, in1, trans_note, trans_length);
wire en_set;
    Pulse pht(clk, rst_n, submit, en_set);
reg setted;
reg [`NOTE_BITS-1:0] cnt;
    always @(*) begin
        case(mode)
            `set: begin // TODO: reset cnt when mode changed
                if (en_set) begin
                    if (!setted && cnt < `NOTE_KEY_BITS) begin
                        rw0 = 1;
                        rw1 = 1;
                        in0 = (7'b1 << cnt);
                        in1 = (7'b1 << cnt);
                        setted = 1;
                        cnt = cnt + 1;
                    end else begin
                        rw0 = 0;
                        rw1 = 0;
                    end
                end else begin
                    setted = 0;
                end
            end
        endcase
    end
endmodule