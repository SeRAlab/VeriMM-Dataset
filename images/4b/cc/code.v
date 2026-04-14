module top_module(
  input clk,
  input rst_n,
  input in,
  output reg [5:0] q
);always @(posedge clk) begin
    if (~rst_n) begin
      q <= 6'b0;
    end else begin
      q <= {q[4:0], in};
    end
  end

endmodule