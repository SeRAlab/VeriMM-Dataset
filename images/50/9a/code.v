module top_module(
  input in,
  output reg out
);always @ (in) begin
    if (in == 1'b1) begin
      out <= 1'b1;
    end
    else begin
      out <= 1'b0;
    end
  end

endmodule