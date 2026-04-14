module johnson_counter (
	input clk,
	input reset,
	output reg [11:0] count);

always @(posedge clk or posedge reset) begin
	if (reset)
		count <= 12'b0;
	else
		count <= {count[10:0], ~count[11]};
	end

endmodule