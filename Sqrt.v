module sqrt(
    input [20:0] x,
    output reg [20:0] y
);
    reg [20:0] temp, last, ans;
    integer i;
    always @* begin
        temp = 0;
        last = 0;
        ans = 0;
        for (i = 10; i >= 0; i = i - 1) begin
            temp = last + (1 << i);
            if (temp * temp < x) begin
                last = temp;
                ans = ans + (1 << i);
            end
        end
        y = ans;
    end
endmodule