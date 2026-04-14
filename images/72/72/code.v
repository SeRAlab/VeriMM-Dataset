module top_module(address, Instructions);input [7:0] address;
	output reg [31:0] Instructions;
	
	always @ (address)
	begin
		
		case (address)
			
			8'd0: Instructions = 32'h8c080000;
			8'd1: Instructions = 32'h8c090004;
			8'd2: Instructions = 32'h01095020;
			8'd3: Instructions = 32'hac0a0008;
			8'd4: Instructions = 32'h01095822;
			8'd5: Instructions = 32'hac0a000c;
			
			default: Instructions = 32'h00000000;
			
		endcase
	end
endmodule