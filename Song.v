`include "Constants.vh"
module Song(
    input [`SONG_BITS-1:0] song,
    input [`SONG_CNT_BITS-1:0] cnt,
    output [`SONG_CNT_BITS-1:0] track,
    output reg [`OCTAVE_BITS-1:0] octave,
    output reg [`NOTE_BITS-1:0] note,
    output reg [`LENGTH_BITS-1:0] length,
    output reg [`FULL_NOTE_BITS-1:0] full_note
);
    always @(song) begin
        case(song)
            0: track <= 10;
            default: track <= 10;
        endcase
    end
    
    always @(song, cnt) begin
        case(song)
            0: begin
                case (cnt)
                    0: begin
                        octave <= 3'b100;
                        note <= 3'b000;
                        length <= 4'b0000;
                        full_note <= 3'b100;
                    end
                    1: begin
                        octave <= 3'b100;
                        note <= 3'b001;
                        length <= 4'b0000;
                        full_note <= 3'b100;
                    end
                    default: begin
                        octave <= 3'b100;
                        note <= 3'b000;
                        length <= 4'b0000;
                        full_note <= 3'b100;
                    end
                endcase
            end
            default: begin
                octave <= 3'b100;
                note <= 3'b000;
                length <= 4'b0000;
                full_note <= 3'b100;
            end
        endcase
    end
endmodule