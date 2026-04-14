module top_module(
	input [1:0] Br_type,
	input [31:0] val1,
	input [31:0] Src2_Val,

	output reg Br_taken
	);always @(*) begin
		if(Br_type == 2'b11) begin 
			Br_taken = 1'b1;
		end
		else if(Br_type == 2'b01) begin 
			if(val1 == 32'b0)
				Br_taken = 1'b1;
			else 
				Br_taken = 1'b0;
		end
		else if(Br_type == 2'b10) begin 
			if(val1 != Src2_Val)
				Br_taken = 1'b1;
			else 
				Br_taken = 1'b0;
		end
		else if(Br_type == 2'b00) begin 
			Br_taken = 1'b0;
		end
			
	end
endmodule