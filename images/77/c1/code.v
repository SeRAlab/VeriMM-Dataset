module top_module(
           input [31:0]      memdata, 
           input             clk, 
           output reg [31:0] memdatareg
          );always @ (posedge clk)
      memdatareg <= memdata;
endmodule