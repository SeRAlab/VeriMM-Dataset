module top_module(
  input clk,
  input reset,
  output reg [2:0] out
);reg [2:0] q;

  always @(posedge clk) begin
    if (reset) begin
      q <= 3'b000;
    end else begin
      q <= {q[1:0], q[2]};
    end
  end

  assign out = q;

endmodule