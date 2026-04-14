module top_module(
	clock,
	data,
	rdaddress,
	wraddress,
	wren,
	q);input	  clock;
	input	[15:0]  data;
	input	[11:0]  rdaddress;
	input	[11:0]  wraddress;
	input	  wren;
	output	reg [15:0]  q; // Change output declaration to reg

	reg [15:0] mem [0:(1<<12)-1];

	always @(posedge clock) begin
		if (wren) begin
			mem[wraddress] <= data;
		end 
		// Always update 'q' on the rising edge of the clock, regardless of wren
		q <= mem[rdaddress]; 
	end

endmodule