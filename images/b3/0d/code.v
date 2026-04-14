module top_module(
  input clk,
  input [3:0] bin_in,
  output reg [3:0] gray_out
);always @(posedge clk) begin
    gray_out[0] <= bin_in[0];
    gray_out[1] <= bin_in[0] ^ bin_in[1];
    gray_out[2] <= bin_in[1] ^ bin_in[2];
    gray_out[3] <= bin_in[2] ^ bin_in[3];
  end

endmodule