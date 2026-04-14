module top_module(
  input clk,
  input reset,
  input enable,
  output reg max_reached,
  output reg [3:0] count
);always @(posedge clk) begin
    if (reset) begin
      count <= 4'b0000;
      max_reached <= 1'b0;
    end
    else if (enable) begin
      count <= count + 1;
      if (count == 4'b1111) begin
        max_reached <= 1'b1;
      end
      else begin
        max_reached <= 1'b0;
      end
    end
  end

endmodule