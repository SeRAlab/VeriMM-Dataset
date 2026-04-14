module top_module(OUT, A, B, MODE);input [3:0] A, B;
input [1:0] MODE;
output [7:0] OUT;

wire [4:0] wire_add, wire_and, wire_if, wire_shift;
wire [7:0] add_enable, and_enable, if_enable, shift_enable;
wire not0, not1;
wire [7:0] yes;





assign wire_add = A+B;
assign wire_and = A&B;
assign wire_if = A>B?1:0;
assign wire_shift = A>>B;

assign not0 = ~MODE[0];
assign not1 = ~MODE[1];

assign add_enable = not0&not1? 8'b11111111:8'b00000000;
assign and_enable = MODE[0]&not1? 8'b11111111:8'b00000000;
assign if_enable = not0&MODE[1]? 8'b11111111:8'b00000000;
assign shift_enable = MODE[0]&MODE[1]? 8'b11111111:8'b00000000;

assign OUT = add_enable&wire_add | and_enable&wire_and | if_enable&wire_if | shift_enable&wire_shift;

endmodule