module top_module(
  input clk,
  input sen,
  input ena,
  input [10:0] d, // Resize according to the total input bit width
  output reg [10:0] q // Resize according to the total output bit width
);always @(posedge clk) begin
    if (ena) begin
      q <= d; // Sample data when enabled
    end
  end
endmodule