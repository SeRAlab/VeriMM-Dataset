module single_dff_reset (
  input clk,
  input din,
  output reg dout,
  input reset_n
);

  always @(posedge clk or negedge reset_n) begin
    if (~reset_n) begin
      dout <= 1'b0;
    end else begin
      dout <= din;
    end
  end

endmodule