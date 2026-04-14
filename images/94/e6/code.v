module top_module(
              
              q,
              
              en, i, rstn
              );parameter LATCH_BITS = 8;
   parameter RESET_VALUE = {LATCH_BITS{1'b0}};

   localparam LATCH_MSB= LATCH_BITS-1;

   input en;
   input [LATCH_MSB:0] i;
   input rstn;
   output [LATCH_MSB:0] q;
   reg    [LATCH_MSB:0] q;

   always @* begin
      if(rstn == 1'b0)
        q <= RESET_VALUE;
      else
        if(en)
          q <= i;

   end
endmodule