module top_module(alu_out, carry_out, a, b, func, clk);input [31:0]a;
input [31:0]b;
input [3:0]func;
input clk;
output [31:0]alu_out;
output carry_out;
reg [31:0] alu_value;
wire [32:0] temp;

assign alu_out = alu_value;
assign temp = {1'b0,a + 1'b0,b};
assign carry_out = temp[32];

always @ (posedge clk)
begin
     case(func)
	4'b0000: 
		alu_value = a+b;
	4'b0001:
		alu_value = a-b;
	4'b0010:
		alu_value = a*b;
	4'b0011:
		alu_value = a/b;
	4'b0100:
		alu_value = a<<1;
	4'b0101:
		alu_value = a>>1;
	4'b0110:
		alu_value = a|b;
	4'b0111:
		alu_value = a&b;
	4'b1000:
		alu_value = a^b;
	4'b1001:
		alu_value = ~(a^b);
	4'b1010:
		alu_value = ~(a&b);
	4'b1011:
		alu_value = ~(a|b);
	4'b1100:
		alu_value = {a[30:0],a[31]};
	4'b1101:
		alu_value = {a[0],a[31:1]};
	4'b1110:
		alu_value = (a>b) ? 32'd1 : 32'd0;
	4'b1111:
		alu_value = (a==b) ? 32'd1 : 32'd0;
       endcase

end
endmodule