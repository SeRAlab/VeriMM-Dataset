module neural_layer (
    input [3:0] input1,
    input [3:0] input2,
    input [3:0] input3,
    output [3:0] output1,
    output [3:0] output2
);
    // Weights and Biases
    parameter W11 = 4'd2, W12 = 4'd3, W13 = 4'd1, Bias1 = 4'd1;
    parameter W21 = 4'd1, W22 = 4'd2, W23 = 4'd2, Bias2 = 4'd2;

    // Intermediate calculations
    wire [7:0] net1, net2; // To hold the summed values before ReLU
    assign net1 = (W11 * input1) + (W12 * input2) + (W13 * input3) + Bias1;
    assign net2 = (W21 * input1) + (W22 * input2) + (W23 * input3) + Bias2;

    // ReLU activation function
    assign output1 = (net1[7:0] > 0) ? net1[3:0] : 4'd0;
    assign output2 = (net2[7:0] > 0) ? net2[3:0] : 4'd0;
endmodule