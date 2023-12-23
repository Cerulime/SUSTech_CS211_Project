`include "Constants.vh"
module Scoreboard(
    input clk, en,
    input [20:0] combo,
    input [1:0] mod,
    input [3:0] difficutly,
    input [20:0] base_score,
    input [20:0] bonus_score,
    input [20:0] acc,
    input [2:0] level,
    output reg [`TUBE_BITS-1:0] seg_en,
    output ctr1,
    output [`TUBE_BITS-1:0] tube1,
    output ctr2,
    output [`TUBE_BITS-1:0] tube2
);
reg add_cnt, add_cnt2;
reg [20:0] cycle_cnt, reflesh_cnt, title_cnt, time_cnt;
    always @(posedge clk) begin
        if (en) begin
            cycle_cnt <= cycle_cnt + 1;
            if (cycle_cnt == 200000) begin
                cycle_cnt <= 0;
                add_cnt <= 1;
            end
            if (reflesh_cnt == 7) begin
                reflesh_cnt <= 0;
                add_cnt <= 0;
                time_cnt <= time_cnt + 1;
            end else begin
                reflesh_cnt <= reflesh_cnt + add_cnt;
                add_cnt <= 0;
                time_cnt <= time_cnt + 1;
            end
            if (time_cnt == 125) begin
                add_cnt2 <= 1;
                time_cnt <= 0;
            end
            if (title_cnt == 7) begin
                title_cnt <= 0;
                add_cnt2 <= 0;
            end else begin
                title_cnt <= title_cnt + add_cnt2;
                add_cnt2 <= 0;
            end
        end else begin
            add_cnt <= 0;
            add_cnt2 <= 0;
            cycle_cnt <= 0;
            reflesh_cnt <= 0;
            title_cnt <= 0;
        end
    end
reg [`TUBE_BITS-1:0] t0, t1, t2, t3, t4, t5, t6, t7;
reg [20:0] temp;
    Decompose decompose(temp, t0, t1, t2, t3, t4, t5, t6, t7);
    always @(*) begin
        case(reflesh_cnt)
            3'b000:seg_en = 8'h01;
            3'b001:seg_en = 8'h02;
            3'b010:seg_en = 8'h04;
            3'b011:seg_en = 8'h08;
            3'b100:seg_en = 8'h10;
            3'b101:seg_en = 8'h20;
            3'b110:seg_en = 8'h40;
            3'b111:seg_en = 8'h80;
        endcase
        case(seg_en)
            8'h01:begin ctr1 = 1; ctr2 = 0; end
            8'h02:begin ctr1 = 1; ctr2 = 0; end
            8'h04:begin ctr1 = 1; ctr2 = 0; end
            8'h08:begin ctr1 = 1; ctr2 = 0; end
            8'h10:begin ctr1 = 0; ctr2 = 1; end
            8'h20:begin ctr1 = 0; ctr2 = 1; end
            8'h40:begin ctr1 = 0; ctr2 = 1; end
            8'h80:begin ctr1 = 0; ctr2 = 1; end
        endcase
        case(seg_en)
            8'h01:tube1 = t0;
            8'h02:tube1 = t1;
            8'h04:tube1 = t2;
            8'h08:tube1 = t3;
            8'h10:tube2 = t4;
            8'h20:tube2 = t5;
            8'h40:tube2 = t6;
            8'h80:tube2 = t7;
        endcase
    end
    always @(*) begin
        case(title_cnt)
            3'b000:begin
                temp = combo;
            end
            3'b001:begin
                temp = base_score;
            end
            3'b010:begin
                temp = bonus_score;
            end
            3'b011:begin
                temp = acc;
            end
            3'b100:begin
                temp = mod;
            end
            3'b101:begin
                temp = difficutly;
            end
            3'b110:begin
                temp = level;
            end
        endcase
    end

endmodule