module shift_reg_4bit(
  input clk,
  input load,
  input [3:0] d,
  input si,
  output reg [3:0] q
);

  always @(posedge clk) begin
    if (load)
      q <= d;
    else
      q <= {q[2:0], si};
  end

endmodule