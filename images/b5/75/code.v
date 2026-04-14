module top_module(
  input clk,
  input reset,
  input load,
  input [3:0] data_in,
  output reg [3:0] q
);always @(posedge clk or posedge reset) begin
    if (reset) begin
      q <= 4'b0;
    end else if (load) begin
      q <= data_in;
    end else begin
      q <= q + 1;
    end
  end

endmodule