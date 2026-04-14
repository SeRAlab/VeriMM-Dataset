module top_module(
  input [1:0] A,
  input [1:0] B,
  output reg out  // Change wire to reg
);always @* begin
    if (A >= B) begin
      out = 1;
    end
    else begin
      out = 0;
    end
  end

endmodule