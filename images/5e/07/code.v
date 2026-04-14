module register_16bit(
  input clk,
  input rst_n,
  input [15:0] d,
  output reg [15:0] q
);

  always @(posedge clk or negedge rst_n) begin
    if (~rst_n)
      q <= 16'b0; // Initialize to 0
    else begin
      q <= d;
    end
  end

endmodule