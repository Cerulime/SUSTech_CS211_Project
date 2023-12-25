`include "Constants.vh"
module Record(
    input rw, en,
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
    always @(en) begin
        if (en) begin
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