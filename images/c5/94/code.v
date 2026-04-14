module counter (
  input clk,
  input reset,
  input enable,
  output reg [3:0] out
);

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      out <= 0;
    end else if (enable) begin
      out <= out + 1;
    end
  end

endmodule