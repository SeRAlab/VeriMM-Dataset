module sync_reset_dff (
  input clk,
  input rst,
  input d,
  output reg q
);

  always @(posedge clk, negedge rst) begin
    if (~rst) begin
      q <= 1'b0;
    end else begin
      q <= d;
    end
  end

endmodule