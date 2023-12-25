/**
 * @module Menu
 * @brief Implements a menu module for controlling a display with multiple tubes.
 *
 * The Menu module receives inputs such as clock, reset, state, and song, and generates outputs
 * to control the display tubes. It uses a scan counter to cycle through the tubes and a state machine
 * to determine which segments to light up on each tube based on the current state and song.
 *
 * Inputs:
 *   - clk: Clock signal
 *   - rst_n: Active-low reset signal
 *   - state: Current state of the menu
 *   - song: Current song being played
 *
 * Outputs:
 *   - seg_en: Segment enable signals for each tube
 *   - tube1: Data signals for tube 1
 *   - tube2: Data signals for tube 2
 *
 * Parameters:
 *   - period: Clock period for generating the clock output signal
 *
 * The module uses internal registers to keep track of the clock count, scan count, and the state of the display tubes.
 * It uses case statements to determine which segments to light up based on the current state and song.
 */
`include "Constants.vh"
module Menu(
    input clk, rst_n,
    input [`STATE_BITS-1:0] state,
    input [`SONG_BITS-1:0] song,
    output reg [`TUBE_BITS-1:0] seg_en,
    output reg [`TUBE_BITS-1:0] tube1,
    output reg [`TUBE_BITS-1:0] tube2
);

    reg clkout;
    reg [31:0] cnt;
    reg [2:0] scan_cnt;
    
    parameter period = 200000; // 500HZ
    
    always @(posedge clk, negedge rst_n) begin
        if(~rst_n) begin
            cnt <= 0;
            clkout <= 0;
        end else begin
            if(cnt == (period>>1)-1) begin
                clkout <= ~clkout;
                cnt <= 0;
            end else
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
        endcase
    end
    
    always @(state,seg_en) begin
        case(state) 
            `menu_mode:
                case(seg_en)
                    8'h01:tube1 = `S;
                    8'h02:tube1 = `t;
                    8'h04:tube1 = `A;
                    8'h08:tube1 = `r;
                    8'h10:tube2 = `t;
                    default: begin
                        tube1 = `emp;
                        tube2 = `emp;
                    end
                endcase
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
            default: tube1 = `emp;
        endcase
    end
    
    always @(*) begin
        case(state)
            `free_mode:tube2 = `emp;
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
                    default:tube2 = `emp;
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
                    default:tube2 = `emp;
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
                    default:tube2 = `emp;
                endcase
            `set:tube2 = `emp;
            default:tube2 = `emp;
        endcase
    end
            
endmodule