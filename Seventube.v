`include "Constants.vh"
module Seventube(
    input clk, rst_n,
    input [2:0]state,
    input [2:0]song,
    output reg [7:0] seg_en,
    output reg [7:0] tube1,
    output reg [7:0] tube2
);

    reg clkout;
    reg [31:0] cnt;
    reg [2:0] scan_cnt;
    
    parameter period = 200000;//500HZ
    
    always @(posedge clk, negedge rst_n) begin
        if(~rst_n) begin
            cnt <= 0;
            clkout <= 0;
        end
        else begin
            if(cnt == (period>>1)-1) begin
                clkout <= ~clkout;
                cnt <= 0;
            end
            else
                cnt <= cnt + 1;
        end
    end
    
    always @(posedge clkout, negedge rst_n) begin
        if(~rst_n)
            scan_cnt <= 0;
        else begin
            if(scan_cnt == 3'd7)
                scan_cnt <= 0;
            else
                scan_cnt <= scan_cnt + 1;
        end
    end
    
    always @(scan_cnt) begin
        case(scan_cnt)
            3'b000:seg_en = 8'h01;
            3'b001:seg_en = 8'h02;
            3'b010:seg_en = 8'h04;
            3'b011:seg_en = 8'h08;
            3'b100:seg_en = 8'h10;
            3'b101:seg_en = 8'h20;
            3'b110:seg_en = 8'h40;
            3'b111:seg_en = 8'h80;
            default: seg_en = 8'h00;
        endcase
    end
    
    always @(state,seg_en) begin
        case(state) 
            `free_mode:   
                case(seg_en)
                    8'h01:tube1 = `F;
                    8'h02:tube1 = `r;
                    8'h04:tube1 = `E;
                    8'h08:tube1 = `E;
                    default: tube1 = `emp;
                endcase
            `auto_mode: 
                case(seg_en)
                    8'h01:tube1 = `A;
                    8'h02:tube1 = `u;
                    8'h04:tube1 = `t;
                    8'h08:tube1 = `o;
                    default: tube1 = `emp;
                endcase
            `stdy_mode:
                case(seg_en)
                    8'h01:tube1 = `S;
                    8'h02:tube1 = `t;
                    8'h04:tube1 = `d;
                    8'h08:tube1 = `y;
                    default: tube1 = `emp;
                endcase
            `play_mode:
                case(seg_en)
                    8'h01:tube1 = `p;
                    8'h02:tube1 = `L;
                    8'h04:tube1 = `A;
                    8'h08:tube1 = `y;
                    default: tube1 = `emp;
                endcase
            `set:
                case(seg_en)
                    8'h01:tube1 = `S;
                    8'h02:tube1 = `E;
                    8'h04:tube1 = `t;
                    default: tube1 = `emp;
                endcase
            default: tube1 = 8'b00000000;
        endcase
    end
    
    always @(*) begin
        case(state)
            `free_mode:tube2 = 8'b00000000;
            `auto_mode:
                case(song)
                    `little_star:
                        case(seg_en)
                            8'h80:tube2 = `one;
                            default:tube2 = `emp;
                        endcase
                    `two_tigers:
                        case(seg_en)
                            8'h80:tube2 = `two;
                            default:tube2 = `emp;
                        endcase
                endcase
            `stdy_mode:
                case(song)
                    `little_star:
                        case(seg_en)
                            8'h80:tube2 = `one;
                            default:tube2 = `emp;
                        endcase
                    `two_tigers:
                        case(seg_en)
                            8'h80:tube2 = `two;
                            default:tube2 = `emp;
                        endcase
                endcase
            `play_mode:
                case(song)
                    `little_star:
                        case(seg_en)
                            8'h80:tube2 = `one;
                            default:tube2 = `emp;
                        endcase
                    `two_tigers:
                        case(seg_en)
                            8'h80:tube2 = `two;
                            default:tube2 = `emp;
                        endcase
                endcase
            `set:tube2 = `emp;
            default:tube2 = `emp;
        endcase
    end
            
endmodule