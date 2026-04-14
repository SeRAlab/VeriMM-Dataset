module top_module(
  input         clk,
  input         rst,
  input         rg_wrt_enable,
  input [2:0]   rg_wrt_dest,
  input[15:0]   rg_wrt_data,
  input [2:0]   rg_rd_addr1,
  output [15:0] rg_rd_data1,
  input [2:0]   rg_rd_addr2,
  output [15:0] rg_rd_data2
);reg [15:0] DataRegister [7:0];
  
  always@(posedge rst, posedge clk)begin
  
    DataRegister[0][15:0] = 16'b0;
    
    if(rst)begin
       DataRegister[7][15:0] = 16'b0;
       DataRegister[6][15:0] = 16'b0;
       DataRegister[5][15:0] = 16'b0;
       DataRegister[4][15:0] = 16'b0;
       DataRegister[3][15:0] = 16'b0;
       DataRegister[2][15:0] = 16'b0;
       DataRegister[1][15:0] = 16'b0;
       DataRegister[0][15:0] = 16'b0;
    end
    else if(rg_wrt_enable && rg_wrt_dest != 0)
      DataRegister[rg_wrt_dest] = rg_wrt_data;
    end
  
  assign rg_rd_data1 = DataRegister[rg_rd_addr1];
  assign rg_rd_data2 = DataRegister[rg_rd_addr2];
    
endmodule