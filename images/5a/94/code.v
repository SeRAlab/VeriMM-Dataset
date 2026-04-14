module top_module(CLOCK_50, LEDG);input CLOCK_50;
	output [7:0] LEDG;
	
	parameter n = 31;
	
	reg [n:0] data = 0;
	
	always @ (posedge CLOCK_50) begin
		data <= data + 1;
	end
	
	assign LEDG[7] = data[n];
	assign LEDG[6] = data[n - 1];
	assign LEDG[5] = data[n - 2];
	assign LEDG[4] = data[n - 3];
	assign LEDG[3] = data[n - 4];
	assign LEDG[2] = data[n - 5];
	assign LEDG[1] = data[n - 6];
	assign LEDG[0] = data[n - 7];
endmodule