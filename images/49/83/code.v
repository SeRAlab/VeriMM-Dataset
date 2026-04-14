module decade_counter (
	input clk,
	input reset,
	output reg [7:0] count);

	always @(posedge clk) begin
		if (reset)
			count <= 8'b00000000;
		else if (count == 8'd9)
			count <= 8'b00000000;
		else
			count <= count + 1;
	end
	
endmodule