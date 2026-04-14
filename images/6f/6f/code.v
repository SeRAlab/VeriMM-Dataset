module top_module(next_pc,rst,clk);output [0:31] next_pc;
	
	
	
	
	
	
	
	input clk;
	
	input rst;
	
	
	
	
	
	
	
	
	
	



	
	
	
	reg [0:31] next_pc;		
	reg [0:31] temp_pc;		
	
	
	
	
	
	always @(posedge clk)
	begin
		
		if(rst)
		begin
			
			next_pc<=32'd0;
			temp_pc<=32'd0;
		end
		else
		begin
			temp_pc<=temp_pc+32'd4;
			next_pc<=temp_pc>>2;
		end
	end
	
	
	
	
endmodule