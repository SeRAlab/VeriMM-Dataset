module top_module(
	input 	   [7:0] 	addr,
	input 				   clock,
	output reg  [15:0] 	q);(* ram_init_file = "verilog/rom_contents.mif" *) reg [15:0] M [0:255];
   
   always @(posedge clock)
      q <= M[addr];
      
endmodule