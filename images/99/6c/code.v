module top_module(
  input clk,
  input reset,
  input [7:0] data_in,
  output reg [8:0] byte_out
);always @(posedge clk or posedge reset) begin
    if (reset) begin
      byte_out <= 9'b0;
    end else begin
      byte_out[8] <= ^data_in;
      byte_out[7:0] <= data_in;
    end
  end
  
endmodule