module top_module(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] S,
    output Cout
);wire [3:0] sum;
wire overflow;

assign sum = A + B + Cin;
assign Cout = (sum > 4'hF) ? 1 : 0;
assign S = (overflow) ? sum[2:0] : sum[3:0];

endmodule