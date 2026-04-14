module top_module(
   clk,
   we,
   waddr,
   wdata,
   raddr,
   rdata
   );parameter WIDTH = 8;
   parameter DEPTH = 256;
   parameter ADDR_WIDTH = $clog2(DEPTH);
   
   input we, clk;
   input [ADDR_WIDTH - 1:0] waddr, raddr;
   input [WIDTH - 1:0] 	    wdata;
   output reg [WIDTH - 1:0] rdata;
   reg [WIDTH - 1:0] 	    ram [DEPTH - 1:0];
   
   always @(posedge clk) begin 
      if (we)
	ram[waddr] <= wdata;
      rdata <= ram[raddr];
   end

endmodule