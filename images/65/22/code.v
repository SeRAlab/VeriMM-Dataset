module top_module(
    data, 
    clk, 
    out_en, 
    address, 
    rd_en, 
    wr_en );inout [7:0] data;
   input clk;
   input out_en;
   input rd_en, wr_en;
   input [3:0] address;
   reg [7:0] memory [15:0];
   reg [7:0] data_out;


   assign data = out_en ? data_out : 8'bZ;
   
   always@(posedge clk) 
     begin : mem
    if(rd_en)
      data_out = memory[address];
    else if (wr_en)
      memory[address] = data;
    else data_out = 8'bx;
     end
   
    

endmodule