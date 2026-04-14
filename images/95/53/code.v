module top_module(
	data0x,
	data1x,
	sel,
	result);input	[3:0]  data0x;
	input	[3:0]  data1x;
	input	  sel;
	output	[3:0]  result;

	reg [3:0] counter;

	always @(*) begin
		if (sel == 1'b0) begin
			counter <= data0x;
		end else begin
			counter <= counter + data1x;
		end
	end

	assign result = counter;

endmodule