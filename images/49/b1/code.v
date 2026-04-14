module top_module(
  input clk_in,
  input rst_in,
  input data_in,
  output clk_out,
  output rst_out,
  output data_out
);// parameter declarations
  parameter shift_reg_width = 2;

  // pulse generator
  reg pulse;
  always @(posedge clk_in) begin
    pulse <= 1'b1;
  end

  // shift register
  reg [shift_reg_width-1:0] shift_reg;
  always @(posedge clk_out) begin
    shift_reg <= {shift_reg[shift_reg_width-2:0], pulse & data_in};
  end

  // output signals
  assign data_out = shift_reg[0];
  assign clk_out = clk_in;
  assign rst_out = rst_in;

endmodule