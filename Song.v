/**
 * @module Song
 * @brief Module for playing different songs
 *
 * This module takes a song input and generates the corresponding musical notes and lengths
 * for the output. It supports multiple songs including "Little Star" and "Two Tigers".
 *
 * @param song Input signal representing the selected song
 * @param cnt Input signal representing the count of the current note in the song
 * @param track Output signal representing the track number of the selected song
 * @param octave Output signal representing the octave of the current note
 * @param note Output signal representing the musical note of the current note
 * @param length Output signal representing the length of the current note
 * @param full_note Output signal representing the full note value of the selected song
 */
`include "Constants.vh"
module Song(
    input [`SONG_BITS-1:0] song,
    input [`SONG_CNT_BITS-1:0] cnt,
    output reg [`SONG_CNT_BITS-1:0] track,
    output reg [`OCTAVE_BITS-1:0] octave,
    output reg [`NOTE_BITS-1:0] note,
    output reg [`LENGTH_BITS-1:0] length,
    output reg [`FULL_NOTE_BITS-1:0] full_note
);

    always @(song) begin
        case(song)
            `little_star: track = 86;
            `two_tigers: track = 74;
            `happy_birthday: track = 52;
            default: track = 0;
        endcase
    end
    
    always @(*) begin
        case(song)
            `little_star: begin
                full_note = 3'b010;
                case (cnt)
                    2: begin
                        octave = 3'b100;
                        note = `do;
                        length = `quarter_note;
                    end
                    4: begin
                        octave = 3'b100;
                        note = `do;
                        length = `quarter_note;
                    end
                    6: begin
                        octave = 3'b100;
                        note = `so;
                        length = `quarter_note;
                    end
                    8: begin
                        octave = 3'b100;
                        note = `so;
                        length = `quarter_note;
                    end
                    10: begin
                        octave = 3'b100;
                        note = `la;
                        length = `quarter_note;
                    end
                    12: begin
                        octave = 3'b100;
                        note = `la;
                        length = `quarter_note;
                    end
                    14: begin
                        octave = 3'b100;
                        note = `so;
                        length = `half_note;
                    end
                    16: begin
                        octave = 3'b100;
                        note = `fa;
                        length = `quarter_note;
                    end
                    18: begin
                        octave = 3'b100;
                        note = `fa;
                        length = `quarter_note;
                    end
                    20: begin
                        octave = 3'b100;
                        note = `mi;
                        length = `quarter_note;
                    end
                    22: begin
                        octave = 3'b100;
                        note = `mi;
                        length = `quarter_note;
                    end
                    24: begin
                        octave = 3'b100;
                        note = `re;
                        length = `quarter_note;
                    end
                    26: begin
                        octave = 3'b100;
                        note = `re;
                        length = `quarter_note;
                    end
                    28: begin
                        octave = 3'b100;
                        note = `do;
                        length = `half_note;
                    end
                    30: begin
                        octave = 3'b100;
                        note = `so;
                        length = `quarter_note;
                    end
                    32: begin
                        octave = 3'b100;
                        note = `so;
                        length = `quarter_note;
                    end
                    34: begin
                        octave = 3'b100;
                        note = `fa;
                        length = `quarter_note;
                    end
                    36: begin
                        octave = 3'b100;
                        note = `fa;
                        length = `quarter_note;
                    end
                    38: begin
                        octave = 3'b100;
                        note = `mi;
                        length = `quarter_note;
                    end
                    40: begin
                        octave = 3'b100;
                        note = `mi;
                        length = `quarter_note;
                    end
                    42: begin
                        octave = 3'b100;
                        note = `re;
                        length = `half_note;
                    end
                    44: begin
                        octave = 3'b100;
                        note = `so;
                        length = `quarter_note;
                    end
                    46: begin
                        octave = 3'b100;
                        note = `so;
                        length = `quarter_note;
                    end
                    48: begin
                        octave = 3'b100;
                        note = `fa;
                        length = `quarter_note;
                    end
                    50: begin
                        octave = 3'b100;
                        note = `fa;
                        length = `quarter_note;
                    end
                    52: begin
                        octave = 3'b100;
                        note = `mi;
                        length = `quarter_note;
                    end
                    54: begin
                        octave = 3'b100;
                        note = `mi;
                        length = `quarter_note;
                    end
                    56: begin
                        octave = 3'b100;
                        note = `re;
                        length = `half_note;
                    end
                    58: begin
                        octave = 3'b100;
                        note = `do;
                        length = `quarter_note;
                    end
                    60: begin
                        octave = 3'b100;
                        note = `do;
                        length = `quarter_note;
                    end
                    62: begin
                        octave = 3'b100;
                        note = `so;
                        length = `quarter_note;
                    end
                    64: begin
                        octave = 3'b100;
                        note = `so;
                        length = `quarter_note;
                    end
                    66: begin
                        octave = 3'b100;
                        note = `la;
                        length = `quarter_note;
                    end
                    68: begin
                        octave = 3'b100;
                        note = `la;
                        length = `quarter_note;
                    end
                    70: begin
                        octave = 3'b100;
                        note = `so;
                        length = `half_note;
                    end
                    72: begin
                        octave = 3'b100;
                        note = `fa;
                        length = `quarter_note;
                    end
                    74: begin
                        octave = 3'b100;
                        note = `fa;
                        length = `quarter_note;
                    end
                    76: begin
                        octave = 3'b100;
                        note = `mi;
                        length = `quarter_note;
                    end
                    78: begin
                        octave = 3'b100;
                        note = `mi;
                        length = `quarter_note;
                    end
                    80: begin
                        octave = 3'b100;
                        note = `re;
                        length = `quarter_note;
                    end
                    82: begin
                        octave = 3'b100;
                        note = `re;
                        length = `quarter_note;
                    end
                    84: begin
                        octave = 3'b100;
                        note = `do;
                        length = `half_note;
                    end
                    default: begin
                        octave = 3'b100;
                        note = `null;
                        length = `sixty_fourth_note;
                    end
                endcase
            end
            `two_tigers: begin
                full_note = 3'b010;
                case(cnt) 
                    2: begin
                    octave = 3'b100;
                    note = `do;
                    length = `eighth_note;
                end
                4: begin
                    octave = 3'b100;
                    note = `re;
                    length = `eighth_note;
                end
                6: begin
                    octave = 3'b100;
                    note = `mi;
                    length = `eighth_note;
                end
                8: begin
                    octave = 3'b100;
                    note = `do;
                    length = `eighth_note;
                end
                10: begin
                    octave = 3'b100;
                    note = `do;
                    length = `eighth_note;
                end
                12: begin
                    octave = 3'b100;
                    note = `re;
                    length = `eighth_note;
                end
                14: begin
                    octave = 3'b100;
                    note = `mi;
                    length = `eighth_note;
                end
                16: begin
                    octave = 3'b100;
                    note = `do;
                    length = `eighth_note;
                end
                18: begin
                    octave = 3'b100;
                    note = `mi;
                    length = `eighth_note;
                end
                20: begin
                    octave = 3'b100;
                    note = `fa;
                    length = `eighth_note;
                end
                22: begin
                    octave = 3'b100;
                    note = `so;
                    length = `eighth_note;
                end
                24: begin
                        octave = 3'b100;
                        note = `null;
                        length = `eighth_note;
                    end
                26: begin
                    octave = 3'b100;
                    note = `mi;
                    length = `eighth_note;
                end
                28: begin
                    octave = 3'b100;
                    note = `fa;
                    length = `eighth_note;
                end
                30: begin
                    octave = 3'b100;
                    note = `so;
                    length = `eighth_note;
                end
                32: begin
                        octave = 3'b100;
                        note = `null;
                        length = `eighth_note;
                    end
                34: begin
                    octave = 3'b100;
                    note = `so;
                    length = `sixteenth_note;
                end
                36: begin
                    octave = 3'b100;
                    note = `la;
                    length = `sixteenth_note;
                end
                38: begin
                    octave = 3'b100;
                    note = `so;
                    length = `sixteenth_note;
                end
                40: begin
                    octave = 3'b100;
                    note = `fa;
                    length = `sixteenth_note;
                end
                42: begin
                    octave = 3'b100;
                    note = `mi;
                    length = `eighth_note;
                end
                44: begin
                    octave = 3'b100;
                    note = `do;
                    length = `eighth_note;
                end
                46: begin
                    octave = 3'b100;
                    note = `so;
                    length = `sixteenth_note;
                end
                48: begin
                    octave = 3'b100;
                    note = `la;
                    length = `sixteenth_note;
                end
                50: begin
                    octave = 3'b100;
                    note = `so;
                    length = `sixteenth_note;
                end
                52: begin
                    octave = 3'b100;
                    note = `fa;
                    length = `sixteenth_note;
                end
                54: begin
                    octave = 3'b100;
                    note = `mi;
                    length = `eighth_note;
                end
                56: begin
                    octave = 3'b100;
                    note = `do;
                    length = `eighth_note;
                end
                58: begin
                    octave = 3'b100;
                    note = `do;
                    length = `eighth_note;
                end
                60: begin
                    octave = 3'b011;
                    note = `so;
                    length = `eighth_note;
                end
                62: begin
                    octave = 3'b100;
                    note = `do;
                    length = `eighth_note;
                end
                64: begin
                        octave = 3'b100;
                        note = `null;
                        length = `sixteenth_note;
                    end
                66: begin
                    octave = 3'b100;
                    note = `do;
                    length = `eighth_note;
                end
                70: begin
                    octave = 3'b011;
                    note = `so;
                    length = `eighth_note;
                end
                72: begin
                    octave = 3'b100;
                    note = `do;
                    length = `eighth_note;
                end
                default: begin
                    octave = 3'b100;
                    note = `null;
                    length = `sixty_fourth_note;
                end
            endcase
            end
            `happy_birthday: begin
                full_note = 3'b010;
                case(cnt)
                    2: begin
                    octave = 3'b011;
                    note = `so;
                    length = `eighth_note;
                end
                4: begin
                    octave = 3'b011;
                    note = `so;
                    length = `eighth_note;
                end
                6: begin
                    octave = 3'b011;
                    note = `la;
                    length = `quarter_note;
                end
                8: begin
                    octave = 3'b011;
                    note = `so;
                    length = `quarter_note;
                end
                10: begin
                    octave = 3'b100;
                    note = `do;
                    length = `quarter_note;
                end
                12: begin
                    octave = 3'b011;
                    note = `xi;
                    length = `half_note;
                end
                14: begin
                    octave = 3'b011;
                    note = `so;
                    length = `eighth_note;
                end
                16: begin
                    octave = 3'b011;
                    note = `so;
                    length = `eighth_note;
                end
                18: begin
                    octave = 3'b011;
                    note = `la;
                    length = `quarter_note;
                end
                20: begin
                    octave = 3'b011;
                    note = `so;
                    length = `quarter_note;
                end
                22: begin
                    octave = 3'b100;
                    note = `re;
                    length = `quarter_note;
                end
                24: begin
                    octave = 3'b100;
                    note = `do;
                    length = `half_note;
                end
                26: begin
                    octave = 3'b011;
                    note = `so;
                    length = `eighth_note;
                end
                28: begin
                    octave = 3'b011;
                    note = `so;
                    length = `eighth_note;
                end
                30: begin
                    octave = 3'b100;
                    note = `so;
                    length = `quarter_note;
                end
                32: begin
                    octave = 3'b100;
                    note = `mi;
                    length = `quarter_note;
                end
                34: begin
                    octave = 3'b100;
                    note = `do;
                    length = `quarter_note;
                end
                36: begin
                    octave = 3'b011;
                    note = `xi;
                    length = `quarter_note;
                end
                38: begin
                    octave = 3'b011;
                    note = `la;
                    length = `quarter_note;
                end
                40: begin
                    octave = 3'b100;
                    note = `fa;
                    length = `eighth_note;
                end
                42: begin
                    octave = 3'b100;
                    note = `fa;
                    length = `eighth_note;
                end
                44: begin
                    octave = 3'b100;
                    note = `mi;
                    length = `quarter_note;
                end
                46: begin
                    octave = 3'b100;
                    note = `do;
                    length = `quarter_note;
                end
                48: begin
                    octave = 3'b100;
                    note = `re;
                    length = `quarter_note;
                end
                50: begin
                    octave = 3'b100;
                    note = `do;
                    length = `half_note;
                end
                default: begin
                    octave <= 3'b100;
                    note <= `null;
                    length <= `sixty_fourth_note;
                end
            endcase
        end
            default: begin
                octave <= 3'b100;
                note <= `null;
                length <= `full_note;
            end
        endcase
    end
endmodule