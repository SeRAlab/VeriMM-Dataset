module d_ff(
  input clk,
  input rst,
  input d,
  output reg q
);

  always @(posedge clk or posedge rst) begin
    if (rst)
      q <= 1'b0; // Initialize to 0
    else begin
      q <= d;
    end
  end

endmodule