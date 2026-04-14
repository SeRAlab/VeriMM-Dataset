module top_module(
    input [3:0] A,
    input [3:0] B,
    output result
);wire [3:0] sum;
    wire [3:0] diff;

    assign sum = A + ~B + 1;
    assign diff = A - B;

    assign result = (sum[3] & diff[3]) | (~diff[3] & sum[2]) | (~diff[3] & ~sum[3] & sum[1]) | (~diff[3] & ~sum[3] & ~sum[1] & sum[0]);

endmodule