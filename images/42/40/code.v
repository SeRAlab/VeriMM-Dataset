module top_module(
   
   sio_ce, sio_ce_x4,
   
   clk, arst_n
   );output          sio_ce;      
   output          sio_ce_x4;   

   input           clk;
   input           arst_n;

   reg             sio_ce;
   reg             sio_ce_x4;
   
   parameter       br_38400_16MHz = 103; 
   parameter       br_31250_40MHz = 319; 
   parameter       br_31250_60MHz = 479; 
   parameter       br_57600_40MHz = 173; 
   parameter       br_57600_60MHz = 260; 




`define BRX4pre &{brx4_cntr[8],brx4_cntr[2]}   

   reg [8:0]       brx4_cntr;
   reg [1:0]       br_cntr;
                   
   always @ (posedge clk or negedge arst_n)
     if (~arst_n)
       brx4_cntr <= 0;
     else if (`BRX4pre)
       brx4_cntr <= 0;
     else
       brx4_cntr <= brx4_cntr + 1'b1;

   always @ (posedge clk or negedge arst_n)
     if (~arst_n)
       br_cntr <= 0;
     else if (`BRX4pre)
       br_cntr <= br_cntr + 1'b1;

   always @ (posedge clk or negedge arst_n)
     if (~arst_n)
       begin
          sio_ce_x4 <= 1'b0;
          sio_ce    <= 1'b0;
       end
     else
       begin
          sio_ce_x4 <= `BRX4pre;
          sio_ce    <= (&br_cntr) & (`BRX4pre);
       end
   
endmodule