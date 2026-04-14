module register (
	input [7:0] data_in,
	input enable,
	output reg [7:0] data_out);always @(posedge enable) begin
		data_out <= data_in;
	end
	
endmodule