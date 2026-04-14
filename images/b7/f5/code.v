module top_module(
  input clk,
  input reset_n,
  input [3:0] switches,
  output reg [3:0] data_out
);always @(posedge clk or negedge reset_n) begin
    if (~reset_n) begin
      data_out <= 0;
    end else begin
      data_out <= switches;
    end
  end

endmodule