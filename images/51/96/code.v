module top_module(CA,CB,clk_in,deciout);input [3:0] CA,CB;
input clk_in;
output [7:0] deciout;
reg [7:0] deciout;


	always @(posedge clk_in) begin
		deciout = CB*10+CB;
		end
		

endmodule