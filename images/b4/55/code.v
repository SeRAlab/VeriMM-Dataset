module shift_register(
  input clk,
  input rst_n,
  input load,
  input [3:0] data,
  input shift_in,
  output reg [3:0] q
);

  always @(posedge clk or negedge rst_n) begin
    if (~rst_n)
      q <= 4'b0000;
    else if (load)
      q <= data;
    else
      q <= {shift_in, q[3:1]};
  end

endmodule