module top_module(
  input a,
  input b,
  output reg out  // Change the output type to reg
);always @(*) begin
    out = (a & ~b) | (~a & b); // Use always block to assign to reg
  end

endmodule