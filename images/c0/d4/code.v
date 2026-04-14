module seg7led_interface(
input clk,rst,
input [7:0]din,
output reg [7:0]dout,
input wr,rd ,
input [2:0]wr_addr,
input [2:0]rd_addr,
output reg [7:0] seg7_sel,
output reg [7:0] seg7_data
);  
reg [7:0]buff[0:7];
always @ (posedge clk)if (wr)buff[wr_addr] = din;
always @(posedge clk)if (rd)dout = buff[rd_addr] ;else dout=0;
reg  [22:0] cntr ;
always @ (posedge clk)
cntr = cntr +1;
reg  [2:0]sel ;
always @ (posedge clk)
sel= cntr[22:19];
always @(posedge clk)
  case (sel)
   0:seg7_data=buff[0];
   1:seg7_data=buff[1];
   2:seg7_data=buff[2];
   3:seg7_data=buff[3];
   4:seg7_data=buff[4];
   5:seg7_data=buff[5];
   6:seg7_data=buff[6];
   7:seg7_data=buff[7];   
  endcase   
  always @(posedge clk)  
   seg7_sel = 1<<sel;    
endmodule