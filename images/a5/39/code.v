module top_module(input clk, input rst,
   input xon_rcvd, input xoff_rcvd, output reg inhibit_tx);reg [15:0] state;
   always @(posedge clk)
     if(rst)
       state <= 0;
     else if(xoff_rcvd)
       state <= 255;
     else if(xon_rcvd)
       state <= 0;
     else if(state !=0)
       state <= state - 1;

   always @(posedge clk)
     inhibit_tx <= (state != 0);
   
endmodule