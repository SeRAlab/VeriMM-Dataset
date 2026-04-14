module top_module(
	input clk,
	input reset,
	output reg [2:0] count);

always @(posedge clk) begin
		if (reset)
			count <= 3'b000;
		else
			case(count)
				3'b000: count <= 3'b001;
				3'b001: count <= 3'b011;
				3'b011: count <= 3'b010;
				3'b010: count <= 3'b110;
				3'b110: count <= 3'b111;
				3'b111: count <= 3'b101;
				3'b101: count <= 3'b100;
				3'b100: count <= 3'b000;
				default: count <= 3'b000;
			endcase
	end
	
endmodule