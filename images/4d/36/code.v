module top_module(r_bus_addr_out, w_bus_addr_in, w_clock, w_reset);input [7:0] w_bus_addr_in;				
	input w_clock, w_reset;					

	output reg [7:0] r_bus_addr_out;			

	always @ (posedge w_clock)				
		if (w_reset) r_bus_addr_out <= 8'b0;		
		else r_bus_addr_out <= w_bus_addr_in;		
endmodule