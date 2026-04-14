module top_module(COUNT, LATCHLSB, LATCHMSB, LATCHCNT);input         LATCHCNT;
   input [15:0]  COUNT;

   output [ 7:0] LATCHLSB,
                 LATCHMSB;
  
   assign {LATCHMSB,LATCHLSB} = COUNT;endmodule