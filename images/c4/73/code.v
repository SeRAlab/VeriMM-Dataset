module counter_3bit (
  input clk,
  input reset,
  output reg [2:0] out
);

  always @(posedge clk) begin
    if (reset) begin
      out <= 3'b0;
    end else begin
      out <= out + 1;
    end
  end

endmodule
