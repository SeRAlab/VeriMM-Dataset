module top_module(
  input clock,
  input reset,
  output reg [3:0] out
);always @(posedge clock) begin
    if (reset) begin
      out <= 4'b0000;
    end
    else if (out == 4'b1111) begin
      out <= 4'b0000;
    end
    else begin
      out <= out + 1;
    end
  end

endmodule