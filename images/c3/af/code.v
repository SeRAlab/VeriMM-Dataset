module constant_enable (
  input clk,
  input reset,
  input enable,
  output reg out
);

  always @(posedge clk, posedge reset) begin
    if (reset) begin
      out <= 0;
    end else if (enable) begin
      out <= 1;
    end else begin
      out <= 0;
    end
  end
  
endmodule
