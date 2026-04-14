module top_module(clk, acc_update, X, acc, rst);input clk;
	input acc_update;
	input [7:0] X;
	input rst;
	
	output [7:0] acc;
	
	reg [7:0] reg_acc;
	assign acc = reg_acc;
	
	
	
		
			
	
	
	always @(*)
	begin
		if (clk) begin	
			if (rst == 1)
				reg_acc = 0;
			else begin
				if (acc_update)
					reg_acc = X;
				else
					reg_acc = acc;
			end
		end
	end
				
endmodule