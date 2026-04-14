module data_pass_module(
  input clk,
  input [23:0] data_in,
  output reg [23:0] data_out
);

  always @(posedge clk) begin
    data_out <= data_in;
  end

endmodule