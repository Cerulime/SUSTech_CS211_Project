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
            `little_star: track <= 42;
            `two_tigers: track <= 32;
            default: track <= 0;
        endcase
    end
    
    always @(song, cnt) begin
        case(song)
            `little_star: begin
                full_note = 3'b100;
                case (cnt)
                    0: begin
                        octave = 3'b100;
                        note = `do;
                        length = `quarter_note;
                    end
                    1: begin
                        octave = 3'b100;
                        note = `do;
                        length = `quarter_note;
                    end
                    2: begin
                        octave = 3'b100;
                        note = `so;
                        length = `quarter_note;
                    end
                    3: begin
                        octave = 3'b100;
                        note = `so;
                        length = `quarter_note;
                    end
                    4: begin
                        octave = 3'b100;
                        note = `la;
                        length = `quarter_note;
                    end
                    5: begin
                        octave = 3'b100;
                        note = `la;
                        length = `quarter_note;
                    end
                    6: begin
                        octave = 3'b100;
                        note = `so;
                        length = `half_note;
                    end
                    7: begin
                        octave = 3'b100;
                        note = `fa;
                        length = `quarter_note;
                    end
                    8: begin
                        octave = 3'b100;
                        note = `fa;
                        length = `quarter_note;
                    end
                    9: begin
                        octave = 3'b100;
                        note = `mi;
                        length = `quarter_note;
                    end
                    10: begin
                        octave = 3'b100;
                        note = `mi;
                        length = `quarter_note;
                    end
                    11: begin
                        octave = 3'b100;
                        note = `re;
                        length = `quarter_note;
                    end
                    12: begin
                        octave = 3'b100;
                        note = `re;
                        length = `quarter_note;
                    end
                    13: begin
                        octave = 3'b100;
                        note = `do;
                        length = `half_note;
                    end
                    14: begin
                        octave = 3'b100;
                        note = `so;
                        length = `quarter_note;
                    end
                    15: begin
                        octave = 3'b100;
                        note = `so;
                        length = `quarter_note;
                    end
                    16: begin
                        octave = 3'b100;
                        note = `fa;
                        length = `quarter_note;
                    end
                    17: begin
                        octave = 3'b100;
                        note = `fa;
                        length = `quarter_note;
                    end
                    18: begin
                        octave = 3'b100;
                        note = `mi;
                        length = `quarter_note;
                    end
                    19: begin
                        octave = 3'b100;
                        note = `mi;
                        length = `quarter_note;
                    end
                    20: begin
                        octave = 3'b100;
                        note = `re;
                        length = `half_note;
                    end
                    21: begin
                        octave = 3'b100;
                        note = `so;
                        length = `quarter_note;
                    end
                    22: begin
                        octave = 3'b100;
                        note = `so;
                        length = `quarter_note;
                    end
                    23: begin
                        octave = 3'b100;
                        note = `fa;
                        length = `quarter_note;
                    end
                    24: begin
                        octave = 3'b100;
                        note = `fa;
                        length = `quarter_note;
                    end
                    25: begin
                        octave = 3'b100;
                        note = `mi;
                        length = `quarter_note;
                    end
                    26: begin
                        octave = 3'b100;
                        note = `mi;
                        length = `quarter_note;
                    end
                    27: begin
                        octave = 3'b100;
                        note = `re;
                        length = `half_note;
                    end
                    28: begin
                        octave = 3'b100;
                        note = `do;
                        length = `quarter_note;
                    end
                    29: begin
                        octave = 3'b100;
                        note = `do;
                        length = `quarter_note;
                    end
                    30: begin
                        octave = 3'b100;
                        note = `so;
                        length = `quarter_note;
                    end
                    31: begin
                        octave = 3'b100;
                        note = `so;
                        length = `quarter_note;
                    end
                    32: begin
                        octave = 3'b100;
                        note = `la;
                        length = `quarter_note;
                    end
                    33: begin
                        octave = 3'b100;
                        note = `la;
                        length = `quarter_note;
                    end
                    34: begin
                        octave = 3'b100;
                        note = `so;
                        length = `half_note;
                    end
                    35: begin
                        octave = 3'b100;
                        note = `fa;
                        length = `quarter_note;
                    end
                    36: begin
                        octave = 3'b100;
                        note = `fa;
                        length = `quarter_note;
                    end
                    37: begin
                        octave = 3'b100;
                        note = `mi;
                        length = `quarter_note;
                    end
                    38: begin
                        octave = 3'b100;
                        note = `mi;
                        length = `quarter_note;
                    end
                    39: begin
                        octave = 3'b100;
                        note = `re;
                        length = `quarter_note;
                    end
                    40: begin
                        octave = 3'b100;
                        note = `re;
                        length = `quarter_note;
                    end
                    41: begin
                        octave = 3'b100;
                        note = `do;
                        length = `half_note;
                    end
                    default: begin
                        octave = 3'b100;
                        note = 3'b000;
                        length = 3'b000;
                    end
                endcase
            end
            `two_tigers: begin
                full_note = 3'b100;
                case(cnt) 
                    0: begin
                    octave = 3'b100;
                    note = `do;
                    length = `eighth_note;
                end
                1: begin
                    octave = 3'b100;
                    note = `re;
                    length = `eighth_note;
                end
                2: begin
                    octave = 3'b100;
                    note = `mi;
                    length = `eighth_note;
                end
                3: begin
                    octave = 3'b100;
                    note = `do;
                    length = `eighth_note;
                end
                4: begin
                    octave = 3'b100;
                    note = `do;
                    length = `eighth_note;
                end
                5: begin
                    octave = 3'b100;
                    note = `re;
                    length = `eighth_note;
                end
                6: begin
                    octave = 3'b100;
                    note = `mi;
                    length = `eighth_note;
                end
                7: begin
                    octave = 3'b100;
                    note = `do;
                    length = `eighth_note;
                end
                8: begin
                    octave = 3'b100;
                    note = `mi;
                    length = `eighth_note;
                end
                9: begin
                    octave = 3'b100;
                    note = `fa;
                    length = `eighth_note;
                end
                10: begin
                    octave = 3'b100;
                    note = `so;
                    length = `eighth_note;
                end
                11: begin
                    octave = 3'b100;
                    note = `mi;
                    length = `eighth_note;
                end
                12: begin
                    octave = 3'b100;
                    note = `fa;
                    length = `eighth_note;
                end
                13: begin
                    octave = 3'b100;
                    note = `so;
                    length = `eighth_note;
                end
                14: begin
                    octave = 3'b100;
                    note = `so;
                    length = `sixteenth_note;
                end
                15: begin
                    octave = 3'b100;
                    note = `la;
                    length = `sixteenth_note;
                end
                16: begin
                    octave = 3'b100;
                    note = `so;
                    length = `sixteenth_note;
                end
                17: begin
                    octave = 3'b100;
                    note = `fa;
                    length = `sixteenth_note;
                end
                18: begin
                    octave = 3'b100;
                    note = `mi;
                    length = `eighth_note;
                end
                19: begin
                    octave = 3'b100;
                    note = `do;
                    length = `eighth_note;
                end
                20: begin
                    octave = 3'b100;
                    note = `so;
                    length = `sixteenth_note;
                end
                21: begin
                    octave = 3'b100;
                    note = `la;
                    length = `sixteenth_note;
                end
                22: begin
                    octave = 3'b100;
                    note = `so;
                    length = `sixteenth_note;
                end
                23: begin
                    octave = 3'b100;
                    note = `fa;
                    length = `sixteenth_note;
                end
                24: begin
                    octave = 3'b100;
                    note = `mi;
                    length = `eighth_note;
                end
                25: begin
                    octave = 3'b100;
                    note = `do;
                    length = `eighth_note;
                end
                26: begin
                    octave = 3'b100;
                    note = `do;
                    length = `eighth_note;
                end
                27: begin
                    octave = 3'b011;
                    note = `so;
                    length = `eighth_note;
                end
                28: begin
                    octave = 3'b011;
                    note = `do;
                    length = `eighth_note;
                end
                29: begin
                    octave = 3'b100;
                    note = `do;
                    length = `eighth_note;
                end
                30: begin
                    octave = 3'b011;
                    note = `so;
                    length = `eighth_note;
                end
                31: begin
                    octave = 3'b011;
                    note = `do;
                    length = `eighth_note;
                end
                default: begin
                    octave = 3'b100;
                    note = 3'b000;
                    length = 3'b000;
                end   
                endcase
            end
            default: begin
                octave <= 3'b100;
                note <= 3'b000;
                length <= 3'b000;
            end
        endcase
    end
endmodule