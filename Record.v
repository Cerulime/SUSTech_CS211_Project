`include "Constants.vh"
module Record(
    input rst_n, rw, en,
    input [`REC_CNT_BITS-1:0] cnt,
    input [`OCTAVE_BITS-1:0] octave,
    input [`NOTE_BITS-1:0] note,
    input [`LENGTH_BITS-1:0] length,
    input [`FULL_NOTE_BITS-1:0] full_note,
    output [`OCTAVE_BITS-1:0] octave_r,
    output [`NOTE_BITS-1:0] note_r,
    output [`LENGTH_BITS-1:0] length_r,
    output [`FULL_NOTE_BITS-1:0] full_note_r
);
reg [`OCTAVE_BITS-1:0] rec_oct[(1<<`REC_CNT_BITS)-1:0];
reg [`NOTE_BITS-1:0] rec_note[(1<<`REC_CNT_BITS)-1:0];
reg [`LENGTH_BITS-1:0] rec_length[(1<<`REC_CNT_BITS)-1:0];
reg [`FULL_NOTE_BITS-1:0] rec_full_note[(1<<`REC_CNT_BITS)-1:0];
integer i;
    always @(*) begin
        if (~rst_n) begin
            for (i = 0; i < (1<<`REC_CNT_BITS); i = i + 1) begin
                rec_oct[i] = 3'b100;
                rec_note[i] = 3'b000;
                rec_length[i] = 3'b000;
                rec_full_note[i] = 3'b100;
            end
        end else if (en) begin
            if (rw) begin
                rec_oct[cnt] = octave;
                rec_note[cnt] = note;
                rec_length[cnt] = length;
                rec_full_note[cnt] = full_note;
            end
        end
    end
    assign octave_r = rec_oct[cnt];
    assign note_r = rec_note[cnt];
    assign length_r = rec_length[cnt];
    assign full_note_r = rec_full_note[cnt];
endmodule