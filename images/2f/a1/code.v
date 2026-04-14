module neural_layer (
    input [7:0] x1, // first input
    input [7:0] x2, // second input
    input [7:0] w1, // weight for input 1
    input [7:0] w2, // weight for input 2
    input [7:0] b,   // bias
    output [7:0] y   // output
);
    wire [15:0] weighted_sum;
    assign weighted_sum = (x1 * w1) + (x2 * w2) + b;
    assign y = (weighted_sum > 0) ? (weighted_sum[7:0]) : 8'b0; // ReLU activation
endmodule