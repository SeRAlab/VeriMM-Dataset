module clk_buffer_driver (
  input clk_in, 
  input en,
  output clk_out
);

  reg d_ff;
  assign clk_out = d_ff;

  always @(posedge clk_in or negedge en) begin
    if (~en) begin
      d_ff <= 1'b0;
    end else begin
      d_ff <= clk_in;
    end
  end

endmodule