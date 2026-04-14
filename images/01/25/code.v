module LinearRegression (
    input [7:0] x1,
    input [7:0] x2,
    input [7:0] x3,
    input [7:0] x4,
    output reg [15:0] y
);
    // Define weights
    parameter signed [7:0] w1 = 8'd2;
    parameter signed [7:0] w2 = 8'd3;
    parameter signed [7:0] w3 = 8'd1;
    parameter signed [7:0] w4 = 8'd4;

    always @(*) begin
        y = (w1 * x1) + (w2 * x2) + (w3 * x3) + (w4 * x4);
    end
endmodule