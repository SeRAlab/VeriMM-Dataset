module top_module(clk, we, d, q);input [31:0] d;
   input 	clk;
   input 	we;
   
   output [31:0] q;
   
   wire 	 clk;
   wire 	 we;
   wire [31:0] 	 d;
   
   reg [31:0] 	 q;
   
   always @ (posedge clk)
     if (we) q <= d;
endmodule