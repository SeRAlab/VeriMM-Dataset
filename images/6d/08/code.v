module johnson_counter (
	input clk,
	output reg [1:0] state);always @(posedge clk) begin
	state <= {~state[0], state[1]};
end
endmodule