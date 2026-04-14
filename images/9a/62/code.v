module top_module(
  input a,
  input b,
  output reg out
);always @ (a or b) begin
    if (a || b) begin
      out = 1'b1;
    end
    else begin
      out = 1'b0;
    end
  end

endmodule