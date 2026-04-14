module top_module(
  input a,
  input b,
  input c,
  input d,
  output reg f
);always @* begin
    if ((a & b) | (c & ~d)) begin
      f = 1'b1;
    end
    else begin
      f = 1'b0;
    end
  end

endmodule