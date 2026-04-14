module top_module(
    input [3:0] A,
    input [3:0] B,
    input C_in,
    output [3:0] S,
    output C_out
);wire [3:0] sum;
    wire C_out1;
    
    assign sum = A + B + C_in;
    assign S = sum[3:0];
    assign C_out = sum[4] | C_out1;
    assign C_out1 = sum[3] & sum[2] | (sum[3] | sum[2]) & sum[1] | (sum[3] | sum[2] | sum[1]) & sum[0];
    
endmodule