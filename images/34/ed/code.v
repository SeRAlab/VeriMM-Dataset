module DWT (
    input [3:0] a,
    output reg [3:0] approx,
    output reg [3:0] detail
);
    always @(*) begin
        approx = (a[0] + a[1] + a[2] + a[3]) >> 1; // Division by 2
        detail = (a[0] - a[1] + a[2] - a[3]) >> 1; // Division by 2
    end
endmodule