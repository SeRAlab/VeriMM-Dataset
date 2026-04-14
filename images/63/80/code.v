module top_module(
  input a,
  input b,
  input c,
  output reg Z1,
  output reg Z2,
  output reg Z3
);always @*
    begin
      Z1 = a & b;
      Z2 = a | c;
      Z3 = b ^ c;
    end

endmodule