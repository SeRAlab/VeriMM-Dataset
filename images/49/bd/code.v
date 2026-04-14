module top_module(
	input clk,
	output reg [2:0] count = 3'b001);

always @(posedge clk) begin
	count <= {count[1:0], ~count[2]};
end

endmodule