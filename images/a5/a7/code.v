module top_module(
	input clk,
	input load,
	input [3:0] data_in,
	output reg [3:0] data);

always @(posedge clk) begin
	if (load) begin
		data <= data_in;
	end else begin
		data <= {1'b0, data[3:1]};
	end
end

endmodule