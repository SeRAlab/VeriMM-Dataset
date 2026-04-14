module top_module(
  input clk,
  input reset,
  input en,
  output reg [2:0] count
);always @(posedge clk) begin
    if (reset) begin
      count <= 3'b0;
    end else if (en) begin
      count <= count + 3'b1;
    end else begin
      count <= count - 3'b1;
    end
  end

endmodule