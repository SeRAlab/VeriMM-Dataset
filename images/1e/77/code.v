module logistic_regression (
    input wire x1,
    input wire x2,
    input wire x3,
    input wire x4,
    output wire y
);
    // Define weights
    parameter w1 = 3'b101; // weight for x1
    parameter w2 = 3'b010; // weight for x2
    parameter w3 = 3'b100; // weight for x3
    parameter w4 = 3'b001; // weight for x4

    wire [3:0] sum;
    
    assign sum = (w1 * x1) + (w2 * x2) + (w3 * x3) + (w4 * x4);
    assign y = (sum > 4) ? 1 : 0; // thresholding at 4 for binary output

endmodule