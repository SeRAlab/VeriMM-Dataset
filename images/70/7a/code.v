module top_module(CLK, ADDR, D_IN, D_WE, D_OUT);input         CLK;
   input [31:0]   ADDR, D_IN;
   input 	  D_WE;
   output [31:0]  D_OUT;
   
   reg [31:0] 	  mem[1024*8-1:0]; 
   
   assign D_OUT  = mem[ADDR[14:2]];
   always @(posedge CLK) if(D_WE) mem[ADDR[14:2]] <= D_IN;endmodule