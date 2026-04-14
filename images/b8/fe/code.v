module parallel_load_shift_register (
	input clk,
	input reset,
	input [7:0] parallel_in,
	input load,
	input serial_in,
	output reg [7:0] parallel_out);

	always @(posedge clk or posedge reset) begin
		if (reset)
			parallel_out <= 8'b00000000;
		else if (load)
			parallel_out <= parallel_in;
		else
			parallel_out <= {parallel_out[6:0], serial_in};
	end
	
endmodule