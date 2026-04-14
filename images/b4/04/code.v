module top_module(
output reg [3:0] n_ascci,
input clk,
input add_ascci,
input reset_ascci
 );reg [3:0] temp;
always @(posedge clk) begin
		if (reset_ascci == 1)	temp <= 4'b0000;
		else if (add_ascci == 1) temp <= temp+1;
			else temp<=temp;
		end	
always @(temp) begin
		n_ascci <= temp;
	end
endmodule