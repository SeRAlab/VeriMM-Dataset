module top_module(
  input wire a1, b1, c1,
  input wire a2, b2, c2,
  input wire a3, b3, c3,
  output reg out1,
  output reg out2,
  output reg out3
);always @*
    begin
      out1 = ~(a1 & b1 & c1);
      out2 = ~(a2 & b2 & c2);
      out3 = ~(a3 & b3 & c3);
    end

endmodule