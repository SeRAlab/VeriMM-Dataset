module top_module(
    input [3:0] A,
    input [3:0] B,
    output EQ,
    output GT,
    output LT
);wire [3:0] difference;

    assign difference = A - B;

    assign EQ = (difference == 4'b0000);
    assign GT = (difference < 4'b0000);
    assign LT = (difference > 4'b0000);
endmodule