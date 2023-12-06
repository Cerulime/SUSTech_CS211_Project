module Light(
    input clk, en,
    input [2:0] note
    output reg [6:0] led
);
    always @(posedge clk) begin
        if(en) begin
            led <= 7'b0000001 << note;
        end else begin
            led <= 7'b0000000;
        end
    end
endmodule