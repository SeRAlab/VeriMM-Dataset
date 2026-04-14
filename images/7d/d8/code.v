module top_module(
	input wire clock,
	input wire[31:0] in,
	input wire reset,
	output reg[31:0] out
);reg[31:0] temp;

		
	always @ (negedge clock) begin
		temp <= in;
	end
	
	always @ (posedge clock) begin
		if(reset == 0)begin
			out <= temp;
		end
		else begin
			out <= 32'b0;
		end
	end

endmodule