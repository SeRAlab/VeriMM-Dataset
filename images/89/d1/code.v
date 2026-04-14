module top_module(
  input clk,
  input reset,
  input pl,
  input [3:0] d,
  output reg [3:0] q
);always @(posedge clk) begin
    if (reset) begin
      q <= 4'b0;
    end else if (pl) begin
      q <= d;
    end else begin
      q <= {q[2:0], q[3]};
    end
  end

endmodule