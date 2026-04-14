module top_module(
  input clk,
  input reset,
  input enable,
  output reg [3:0] count
);always @(posedge clk) begin
    if (reset) begin
      count <= 4'b0000;
    end
    else if (enable) begin
      count <= count + 1;
    end
  end

  always @(*) begin
    if (count == 4'b1111 && enable) begin
      count <= 4'b0000;
    end
  end

endmodule