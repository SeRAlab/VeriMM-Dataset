module top_module(
  output [15:0] counter,
  input clk,
  input up,
  input down);reg [15:0] result = 16'h0000;
  
  
  assign counter = result;
  
  always@(posedge clk) begin
    if(up) begin
      result <= result + 1;
    end
    if(down) begin
        result <= result - 1;
    end
  end
endmodule