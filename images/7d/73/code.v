module top_module(
   
   rd_data,
   
   wr_clk, wr_write, wr_data, wr_addr, rd_addr
   );parameter  DW = 104;
   parameter  AW = 2;
   localparam MD = 1<<AW;

   
   
   
   input           wr_clk;      
   input           wr_write;   
   input [DW-1:0]  wr_data;
   input [AW-1:0]  wr_addr;
   input [AW-1:0]  rd_addr;

   
   
   
    output [DW-1:0] rd_data;

   
   
   
   reg [DW-1:0]     mem[MD-1:0];
   
   
   always @(posedge wr_clk)
     if(wr_write)
       mem[wr_addr[AW-1:0]] <= wr_data[DW-1:0];
   
   
   assign rd_data[DW-1:0] = mem[rd_addr[AW-1:0]];

endmodule