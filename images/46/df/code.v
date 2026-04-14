module top_module(
  input clk_in,
  input [7:0] delay,
  output reg clk_out      // Changed clk_out to reg type
);reg [7:0] delay_count;
  reg delayed_clk;

  always @(posedge clk_in) begin
    if (delay_count == delay) begin
      delayed_clk <= 1'b1;
      delay_count <= 0;
    end else begin
      delayed_clk <= 1'b0;
      delay_count <= delay_count + 1;
    end
  end

  always @(posedge delayed_clk) begin
    clk_out <= 1'b1;         // This assignment is now valid
  end

endmodule