module Song(
    input [2:0] song,
    input [20:0] cnt,
    output [20:0] track,
    output reg [2:0] octave,
    output reg [2:0] note,
    output reg [3:0] length,
    output reg [2:0] full_note
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