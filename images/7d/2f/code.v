module top_module(r_bus_addr_out, w_bus_addr_in, w_clock, w_reset);input [7:0] w_bus_addr_in;				// 8 bit address bus input
	input w_clock, w_reset;					// clock and reset variables

	output reg [7:0] r_bus_addr_out;			// 8 bit address bus output

	always @ (posedge w_clock)				// on positive edge of clock pulse:
		if (w_reset) r_bus_addr_out <= 8'b0;		// reset to 0 synchronously
		else r_bus_addr_out <= w_bus_addr_in;		// output what is on the input
endmodule