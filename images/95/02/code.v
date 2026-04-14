module shift_register(
	input wire clk,
	input wire reset,
	input wire load,
	input wire [3:0] parallel_in,
	input wire serial_in,
	output reg [3:0] data_out
);always @(posedge clk or posedge reset) begin
		if (reset)
			data_out <= 4'b0000;
		else if (load)
			data_out <= parallel_in;
		else
			data_out <= {data_out[2:0], serial_in};
	end
endmodule