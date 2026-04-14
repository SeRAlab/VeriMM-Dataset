module top_module(
  input clk,
  input reset,
  input enable,
  input load,
  input [3:0] data_in,
  output reg [3:0] q,
  output reg overflow
);always @(posedge clk) begin
    if (reset) begin
      q <= 4'b0;
      overflow <= 1'b0;
    end else if (load) begin
      q <= data_in;
      overflow <= (data_in == 4'hf);
    end else if (enable) begin
      q <= q + 4'b1;
      overflow <= (q == 4'hf);
    end else begin
      overflow <= (q == 4'hf);
    end
  end

endmodule