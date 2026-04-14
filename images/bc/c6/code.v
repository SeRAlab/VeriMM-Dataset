module shift_register (
  input clk,
  input reset,
  input shift_in,
  output reg [3:0] q
);

  always @(posedge clk or posedge reset) begin
    if (reset)
      q <= 4'b0000;
    else
      q <= {q[2:0], shift_in};
  end

endmodule