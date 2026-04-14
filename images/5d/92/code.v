module top_module(in, out, inAddr, outAddr, writeSel, clk);parameter depth=1024, width=16, logDepth=10;

   input [width-1:0]    in;
   input [logDepth-1:0] inAddr, outAddr;
   input 	        writeSel, clk;
   output [width-1:0] 	out;
   reg [width-1:0] 	out;

   

   reg [width-1:0] 	mem[depth-1:0];

   always @(posedge clk) begin
      out <= mem[outAddr];

      if (writeSel)
        mem[inAddr] <= in;
   end
endmodule