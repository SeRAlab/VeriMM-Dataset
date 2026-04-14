module top_module(q, d, a, we, wclk);output q;
   input d;
   input [3:0] a;
   input we;
   input wclk;

   reg mem[15:0];

   assign q = mem[a];
   always @(posedge wclk) if (we) mem[a] = d;

endmodule