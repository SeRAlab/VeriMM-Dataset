module top_module(
  input clk_in,
  input data_in,
  output data_out,
  output reg data_decoded
);// No parameters needed for this module

// input signals
assign data_out = (clk_in ^ data_in) ? 1'b0 : 1'b1;

// output signals
always @(posedge clk_in)
begin
  if (data_out == 1'b0)
    data_decoded <= 1'b0;
  else if (data_out == 1'b1)
    data_decoded <= 1'b1;
end

endmodule