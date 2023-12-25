/**
 * @module Pulse
 * @brief Generates a pulse signal based on the input signal 'pul' and the clock signal 'clk'.
 * 
 * The module has two processes. The first process generates a slow clock signal 'slow_clk' by dividing the input clock signal 'clk' by a factor of 1000000.
 * The second process detects the rising edge of the slow clock signal and generates a pulse signal 'pulse' based on the input signal 'pul'.
 * 
 * @param clk The clock input signal.
 * @param rst_n The active-low reset signal.
 * @param pul The input signal used to generate the pulse signal.
 * @param pulse The output pulse signal.
 */
module Pulse(
    input clk, rst_n,
    input pul,
    output reg pulse
);
...
endmodule
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