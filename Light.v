`include "Constants.vh"

/**
 * @module Light
 * @brief Controls the LED based on the input note and enable signal.
 *
 * @param en    : input wire, enable signal
 * @param note  : input wire, note value
 * @param led   : output reg, LED control signal
 */
module Light(
    input en,
    input [`NOTE_BITS-1:0] note,
    output reg [`NOTE_KEY_BITS-1:0] led
);
    always @(*) begin
        if(en) begin
            led <= 7'b0000001 << note;
        end else begin
            led <= 7'b0000000;
        end
    end
endmodule