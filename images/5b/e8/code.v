module top_module(
    input clk,
    input [1023:0]idata,
    input [4:0]raddr,
    output [31:0] rdata
    );assign rdata=idata[raddr*32+:32];
  
endmodule