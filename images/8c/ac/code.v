module top_module(
output wire r,
output wire cout,
input wire a,
input wire b,
input wire cin
) ;assign r = (a ^ b) ^ (cin) ;
assign cout = (a & b) | ( a & cin ) | ( b & cin ) ;endmodule