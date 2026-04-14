module top_module( clk, reset, ld_en, pc_load, pc_inc, pc_out );input		         clk, reset;
	input			      ld_en, pc_inc;
	input  	  [15:0] pc_load;
	
	output reg [15:0] pc_out;

	
	always @ (posedge clk, posedge reset) begin
		if(reset == 1'b1) 
			pc_out <= 16'b0;
		else if(ld_en)
			pc_out <= pc_load;
		else if(pc_inc)
			pc_out <= pc_out + 16'b1;
		else
			pc_out <= pc_out;
		
	end
		
endmodule