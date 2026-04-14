module register_16bit (
	input clk,
	input load,
	input [15:0] load_value,
	output reg [15:0] data);

always @(posedge clk) begin
	if (load)
		data <= load_value;
	else
		data <= {1'b0, data[15:1]};
	end

endmodule