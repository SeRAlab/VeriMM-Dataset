module top_module(clk,out,rst,valid_in);input clk,rst,valid_in;
	output [20:0] out;
	reg [20:0] i;
always @(posedge clk or negedge rst)
begin
 if (!rst)
	 i<= 16'd0;
	else if (!valid_in) begin
	i<= 16'd0;
	end
	else i = i +16'd1;
end
assign out = i;
endmodule