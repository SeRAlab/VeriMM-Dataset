module top_module(
  input clk,
  input reset,
  input enable,
  output reg [4:0] count
);always @(posedge clk) begin
    if (reset) begin
      count <= 5'b00000;
    end else if (enable) begin
      count <= {count[3:0], ~count[4]};
    end
  end

endmodule