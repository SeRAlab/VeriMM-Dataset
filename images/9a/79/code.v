module ring_counter (
	input clk,
	input load,
	input [3:0] load_value,
	output reg [3:0] count);

always @(posedge clk) begin
	if (load)
		count <= load_value;
	else
		count <= {count[2:0], count[3]};
	end

endmodule