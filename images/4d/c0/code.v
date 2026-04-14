module top_module(clock, subOut, Mul_In, div_output, op1);input        clock;
input  [47:0] subOut;
input  [47:0] div_output;

output [47:0] Mul_In;
output [47:0] op1;

wire   [47:0] Mul_In;
wire   [47:0] op1;

reg [47:0] d16,d17,d18,d19;

always@(posedge clock)
begin
	d16 <= subOut;
	d17 <= d16;
	d18 <= d17;
	d19 <= d18;
end
assign Mul_In = d19;
assign op1 = div_output;

endmodule