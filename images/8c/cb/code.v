module top_module(
  input INP,
  output reg ZN
);always @(*) begin
    ZN = ~INP; // Direct negation of INP instead of using INVX1
  end

endmodule