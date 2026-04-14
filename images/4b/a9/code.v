module top_module(
  input I,
  output reg O,
  input CE,
  input R
);reg [1:0] q;
  wire d = (R) ? 1'b0 : q[0];

  always @(posedge CE) begin
    if (R) begin
      q <= 2'b0;
      O <= 1'b0;
    end
    else begin
      q <= {q[0], I};
      O <= q[1];
    end
  end

endmodule