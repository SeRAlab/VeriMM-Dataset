module top_module(input clock,
			input [31:0] mem_input,
			input load,
			input clear,
			output reg [31:0] memreg
);always @ (posedge clock) begin
			if (clear) begin
			
				
				memreg = {{7{4'b1111}},4'b0000};
				
			end else if (load) begin
			
				memreg = mem_input;
			
			end 
			
	end
endmodule