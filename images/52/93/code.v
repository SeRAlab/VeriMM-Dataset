module top_module(in, enable, clear, clk, out);input [5:0] in;
  input enable;
  input clear;
  input clk;
  output [5:0] out;
  
  reg [5:0] states;
  
  always @ (posedge clk) begin
    if(enable && clear) begin
      states = 6'b000000;
    end
    
    else if(enable) begin
      states <= in;
    end
  end
  
  assign out = states;
  
endmodule