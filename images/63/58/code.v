module parallel_to_serial (
	input clk,
	input reset,
	input [7:0] parallel_in,
	output reg serial_out);

	reg [7:0] data;
	reg [2:0] bit_index;

	always @(posedge clk or posedge reset) begin
		if (reset) begin
			data <= 8'b00000000;
			bit_index <= 3'b000;
			serial_out <= 1'b0;
		end else begin
			if (bit_index == 3'b000)
				data <= parallel_in;
				
			serial_out <= data[bit_index];
			bit_index <= bit_index + 1;
		end
	end
	
endmodule