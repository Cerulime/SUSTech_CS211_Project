/**
 * @module Controller
 * @brief This module represents the controller for a digital piano.
 *
 * The Controller module handles various modes of operation, including menu mode, free mode, auto mode, study mode, and play mode.
 * It receives input signals such as clock, reset, submit, cancel, octave up, octave down, note key, length key, reset, and is_rw.
 * It generates output signals such as buzzer, tube1, tube2, seg_en, led, led_aux, and T1.
 * The module also instantiates other modules such as Pulse, Sound, Menu, Automode, Freemode, Playmode, and Stdymode to perform specific tasks.
 */

`include "Pulse.v"
`include "Sound.v"
`include "Menu.v"
`include "Automode.v"
`include "Freemode.v"
`include "Playmode.v"
`include "Stdymode.v"
`include "Constants.vh"
module Controller (
    input clk, rst_n,
    input submit, cancel, 
    input oct_up, oct_down,
    input [`NOTE_KEY_BITS-1:0] note_key,
    input [`LENGTH_KEY_BITS-1:0] length_key,
    input reset, is_rw,
    output reg buzzer,
    output reg [`TUBE_BITS-1:0] tube1,
    output reg [`TUBE_BITS-1:0] tube2,
    output reg [`TUBE_BITS-1:0] seg_en,
    output reg [`NOTE_KEY_BITS-1:0] led,
    output reg [`NOTE_KEY_BITS-1:0] led_aux,
    output T1
);
    assign T1 = 0;

reg [20:0] microsecond;
reg [`CLOCK_BITS-1:0] system_clock;
wire [`CLOCK_BITS-1:0] system_clk;
    assign system_clk = system_clock;
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

wire en_set;
    Pulse pht(clk, rst_n, submit, en_set);
reg last_en_set, cache_set;
wire en_back;
    Pulse phk(clk, rst_n, cancel, en_back);

wire buzzer_sd, over;
reg en_sd;
reg [`NOTE_BITS-1:0] cnt;
    Sound sd(clk, en_sd, 3'b100, cnt, 3'b000, 3'b100, buzzer_sd, over);

reg [`STATE_BITS-1:0] state;
reg [`SONG_BITS-1:0] song;
reg [`SONG_BITS-1:0] menu_song;
wire [`TUBE_BITS-1:0] mn_seg_en, mn_tube1, mn_tube2;
    Menu menu(clk, rst_n, state, menu_song, mn_seg_en, mn_tube1, mn_tube2);

wire Auto_buzzer, Free_buzzer, Play_buzzer, Stdy_buzzer;
wire [`NOTE_KEY_BITS-1:0] Auto_led, Free_led, Play_led, Play_led_aux, Stdy_led, Stdy_led_aux;
reg en_Auto, en_Free, en_Play, en_Stdy;
wire [`NOTE_KEY_BITS-1:0] trans_note;
    Automode automode(clk, en_Auto, song, Auto_led, Auto_buzzer);
    Freemode freemode(clk, en_Free, rst_n, submit, oct_up, oct_down, trans_note, length_key, system_clk,
                      Free_led, Free_buzzer);
reg [1:0] mod;
reg [3:0] difficutly;
wire pulse_up, pulse_down;
    Pulse p_up(clk, rst_n, oct_up, pulse_up);
    Pulse p_down(clk, rst_n, oct_down, pulse_down);
reg pulse_ack;
reg [`USER_BITS-1:0] user;
wire [`TUBE_BITS-1:0] pl_seg_en, pl_tube1, pl_tube2;
    Playmode playmode(clk, en_Play, rst_n, submit, oct_up, oct_down, trans_note, length_key, system_clk,
                      song, user, mod, difficutly, Play_led, Play_led_aux, Play_buzzer, pl_seg_en, pl_tube1, pl_tube2);
    Stdymode stdymode(clk, en_Stdy, rst_n, submit, oct_up, oct_down, trans_note, length_key, system_clk,
                      song, reset, is_rw, Stdy_led, Stdy_led_aux, Stdy_buzzer);
reg rw;
wire [`NOTE_KEY_BITS-1:0] addr;
    assign addr = note_key;
reg [`NOTE_KEY_BITS-1:0] in;
reg ram_rst;
    RAM ram(ram_rst, rw, addr, in, trans_note);
reg setted;

    always @(posedge clk, negedge rst_n) begin
        if (!rst_n) begin
            state <= `menu_mode;
            en_Auto <= 0;
            en_Free <= 0;
            en_Play <= 0;
            en_Stdy <= 0;
        end else begin
            last_en_set <= en_set;
            if (last_en_set ^ en_set) begin
                cache_set <= en_set;
            end else begin
                cache_set <= 0;
            end
            if (en_back && state > 0) begin
                state <= `menu_mode;
                en_Auto <= 0;
                en_Free <= 0;
                en_Play <= 0;
                en_Stdy <= 0;
            end else begin
                case(state)
                    `menu_mode: begin
                        ram_rst <= rst_n;
                        if (cache_set) begin
                            case(note_key)
                                7'b0000001: begin state <= `free_mode; en_Free <= 1; end
                                7'b0000010: begin state <= `auto_mode; en_Auto <= 0; song <= 0; end
                                7'b0000100: begin state <= `stdy_mode; en_Stdy <= 0; song <= 0; end
                                7'b0001000: begin state <= `play_mode; en_Play <= 0; song <= 0; difficutly <= 4; pulse_ack <= 0; end
                                7'b0010000: begin state <= `set; cnt <= 3'b000; end 
                                default: begin
                                    state <= `menu_mode;
                                    en_Auto <= 0;
                                    en_Free <= 0;
                                    en_Play <= 0;
                                    en_Stdy <= 0;
                                end
                            endcase
                            cache_set <= 0;
                        end
                        led <= 7'b0;
                        led_aux <= 7'b0;
                        buzzer <= 0;
                        seg_en <= mn_seg_en;
                        tube1 <= mn_tube1;
                        tube2 <= mn_tube2;
                    end
                    `free_mode: begin
                        led <= Free_led;
                        buzzer <= Free_buzzer;
                        seg_en <= mn_seg_en;
                        tube1 <= mn_tube1;
                        tube2 <= mn_tube2;
                    end
                    `auto_mode: begin
                        if (song == `no_song) begin
                            if (cache_set) begin
                                case(note_key)
                                    7'b0000001: song <= `little_star;
                                    7'b0000010: song <= `two_tigers;
                                    7'b0000100: song <= `happy_birthday;
                                    default: song <= `no_song;
                                endcase
                                cache_set <= 0;
                            end else begin
                                case(note_key)
                                    7'b0000001: menu_song <= `little_star;
                                    7'b0000010: menu_song <= `two_tigers;
                                    7'b0000100: menu_song <= `happy_birthday;
                                    default: menu_song <= `no_song;
                                endcase
                            end
                        end else begin
                            menu_song <= song;
                            en_Auto <= 1;
                            led <= Auto_led;
                            buzzer <= Auto_buzzer;
                        end
                        seg_en <= mn_seg_en;
                        tube1 <= mn_tube1;
                        tube2 <= mn_tube2;
                    end
                    `stdy_mode: begin
                        if (song == `no_song && ~reset) begin
                            if (cache_set) begin
                                case(note_key)
                                    7'b0000001: song <= `little_star;
                                    7'b0000010: song <= `two_tigers;
                                    7'b0000100: song <= `happy_birthday;
                                    default: song <= `no_song;
                                endcase
                                cache_set <= 0;
                            end else begin
                                case(note_key)
                                    7'b0000001: menu_song <= `little_star;
                                    7'b0000010: menu_song <= `two_tigers;
                                    7'b0000100: menu_song <= `happy_birthday;
                                    default: menu_song <= `no_song;
                                endcase
                            end
                        end else begin
                            menu_song <= song;
                            en_Stdy <= 1;
                            led <= Stdy_led;
                            led_aux <= Stdy_led_aux;
                            buzzer <= Stdy_buzzer;
                        end
                        seg_en <= mn_seg_en;
                        tube1 <= mn_tube1;
                        tube2 <= mn_tube2;
                    end
                    `play_mode: begin
                        if (song == `no_song) begin
                            led <= 7'b1 << difficutly;
                            if (!pulse_ack) begin
                                case({pulse_up, pulse_down})
                                    2'b01: difficutly <= difficutly - 1;
                                    2'b10: difficutly <= difficutly + 1;
                                    default: difficutly <= difficutly;
                                endcase
                                pulse_ack <= pulse_up | pulse_down;
                            end else begin
                                pulse_ack <= pulse_up | pulse_down;
                            end
                            if (cache_set) begin
                                case(note_key)
                                    7'b0000001: song <= `little_star;
                                    7'b0000010: song <= `two_tigers;
                                    7'b0000100: song <= `happy_birthday;
                                    7'b1000000: user <= 1;
                                    7'b0100000: user <= 2;
                                    default: song <= `no_song;
                                endcase
                                case(length_key)
                                    7'b0000001: mod <= 0;
                                    7'b0000010: mod <= 1;
                                    7'b0000100: mod <= 2;
                                    7'b0001000: mod <= 3;
                                    default: mod <= 0;
                                endcase
                                cache_set <= 0;
                            end
                            seg_en <= mn_seg_en;
                            tube1 <= mn_tube1;
                            tube2 <= mn_tube2;
                        end else begin
                            en_Play <= 1;
                            led <= Play_led;
                            led_aux <= Play_led_aux;
                            buzzer <= Play_buzzer;
                            seg_en <= pl_seg_en;
                            tube1 <= pl_tube1;
                            tube2 <= pl_tube2;
                        end
                    end
                    `set: begin
                        if (cnt == `NOTE_KEY_BITS) begin
                            state <= `menu_mode;
                            cnt <= 0;
                            en_sd <= 0;
                        end else begin
                            if (cache_set & reset) begin
                                ram_rst <= 0;
                                state <= `menu_mode;
                                cnt <= 0;
                                cache_set <= 0;
                            end else begin
                                ram_rst <= rst_n;
                            end
                            en_sd <= cache_set | ~over;
                            if (cache_set & over & !reset) begin
                                if (!setted && cnt < `NOTE_KEY_BITS) begin
                                    rw <= 1;
                                    in <= (7'b1 << cnt);
                                    setted <= 1;
                                    cnt <= cnt + 1;
                                    cache_set <= 0;
                                end else begin
                                    rw <= 0;
                                end
                            end else begin
                                setted <= 0;
                                rw <= 0;
                            end
                        end
                        seg_en <= mn_seg_en;
                        tube1 <= mn_tube1;
                        tube2 <= mn_tube2;
                    end
                endcase
            end
        end
    end
endmodule