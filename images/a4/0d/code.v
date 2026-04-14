module top_module(
	input clk,
	output reg [7:0] johnson_count);

always @(posedge clk) begin
	johnson_count <= {~johnson_count[0], johnson_count[7:1]};
end
endmodule