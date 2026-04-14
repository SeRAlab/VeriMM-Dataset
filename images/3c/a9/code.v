module logistic_regression (
    input [7:0] x0, 
    input [7:0] x1, 
    input [7:0] x2, 
    input [7:0] x3, 
    input [7:0] x4,
    output reg y
);
    // Fixed weights and bias
    localparam signed [7:0] w0 = 8'd1;
    localparam signed [7:0] w1 = 8'd2;
    localparam signed [7:0] w2 = 8'd3;
    localparam signed [7:0] w3 = 8'd4;
    localparam signed [7:0] w4 = 8'd5;
    localparam signed [7:0] b  = 8'd1;

    // Intermediate signal
    wire signed [15:0] z;

    // Compute linear combination
    assign z = (w0 * x0) + (w1 * x1) + (w2 * x2) + (w3 * x3) + (w4 * x4) + b;

    // Compute the output using a simple comparisons for thresholding
    always @(*) begin
        if (z > 8'd0) begin
            y = 1'b1; // Class 1
        end else begin
            y = 1'b0; // Class 0
        end
    end
endmodule