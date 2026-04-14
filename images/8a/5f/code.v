module top_module(
	   input 		       clk,
	   input 		       we,
	   input [ADDR_WIDTH - 1 : 0]  waddr,
	   input [DATA_WIDTH - 1 : 0]  d,
	   input 		       re,
	   input [ADDR_WIDTH - 1 : 0]  raddr,
	   output [DATA_WIDTH - 1 : 0] q
	   );parameter ADDR_WIDTH = 8;
   parameter DATA_WIDTH = 16;
   
   localparam DEPTH = 1  << ADDR_WIDTH;
   
   reg [DATA_WIDTH - 1 : 0] 	       mem [DEPTH - 1 : 0];
   reg [DATA_WIDTH - 1 : 0] 	       _q = 0;
   
   assign q = _q;
   
   always @ (posedge clk)
     begin
	if (we)
	  begin
	     mem[waddr] <= d;
	  end

	if (re)
	  begin
	     _q <= mem[raddr];
	  end
     end 
   
endmodule