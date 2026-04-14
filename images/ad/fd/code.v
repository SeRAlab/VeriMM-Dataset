module shift_register(
  input clk,
  input rst_n,
  input d,
  output reg [3:0] q
);

  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      q <= 4'b0000;
    end
    else begin
      q <= {q[2:0], d};
    end
  end

endmodule