module Pulse(
    input clk, rst_n,
    input pul,
    output reg pulse
);
reg [22:0] clk_cnt;
reg slow_clk;
    always @(posedge clk, negedge rst_n) begin
        if (!rst_n) begin
            clk_cnt <= 0;
            slow_clk <= 0;
        end else begin
            if (clk_cnt < 1000000)
                clk_cnt <= clk_cnt + 1;
            else begin
                clk_cnt <= 0;
                slow_clk <= ~slow_clk;
            end
        end
    end
reg last_sclk;
reg last_pul;
    always @(posedge clk, negedge rst_n) begin
        if (!rst_n) begin
            last_sclk <= 0;
            last_pul <= 0;
            pulse <= 0;
        end else begin
            last_sclk <= slow_clk;
            if (slow_clk & ~last_sclk)
                last_pul <= pul;
                pulse <= pul & ~last_pul;
        end
    end
endmodule