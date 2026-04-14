module shift_register (
  input [7:0] d,
  input clk,
  input shift_en,
  input load,
  output reg [7:0] q
);

  always @(posedge clk) begin
    if (load)
      q <= d;
    else if (shift_en)
      q <= {q[6:0], 1'b0}; // Shift left
  end

endmodule