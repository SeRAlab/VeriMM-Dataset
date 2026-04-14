module linear_regression (
    input [15:0] x,
    input [15:0] m,
    input [15:0] c,
    output reg [31:0] y
);
    always @(*) begin
        y = (m * x) + c;
    end
endmodule