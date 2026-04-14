module top_module(
  input clk,
  input [3:0] binary,
  output reg [3:0] gray
);always @ (posedge clk) begin
    gray <= binary ^ (binary >> 1);
  end

endmodule