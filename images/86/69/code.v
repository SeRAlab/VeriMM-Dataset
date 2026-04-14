module johnson_counter (
	input clk,
	input rst,
	output reg [1:0] count);

	always @(posedge clk) begin
		if (rst)
			count <= 2'b00;
		else
			count <= {count[0], ~count[1]};
	end
	
endmodule