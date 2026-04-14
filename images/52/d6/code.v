module top_module(clk, rst, in1, in2, out);input clk, rst;
  input [15:0] in1, in2;
  output reg [15:0] out;
  
  always @(posedge clk) begin
    if (rst) begin
      out <= 16'b0;
    end else begin
      out <= in1 ^ in2;
    end
  end
endmodule