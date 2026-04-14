module top_module(
  input [12:0] A,
  input clk,
  input ce,
  input rst,
  output reg [20:0] Y
);reg [20:0] acc;
  
  always @ (posedge clk) begin
    if (rst) begin
      acc <= 0;
    end else if (ce) begin
      acc <= acc + A;
    end
  end
  
  assign Y = acc;
  
endmodule