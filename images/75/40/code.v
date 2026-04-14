module top_module(SUM, COUT, A, B, CIN);input [3:0] A, B;
input CIN;
output [3:0] SUM;
output COUT;

wire [3:0] temp_sum;
wire carry;

assign temp_sum = A + B + CIN;

assign SUM = temp_sum[3:0];
assign COUT = temp_sum[4];

endmodule