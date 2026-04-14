module top_module(
  input clk,
  input shift_enable,
  input parallel_load_enable,
  input [15:0] data_in,
  output [15:0] data_out
);reg [15:0] register;

  always @(posedge clk) begin
    if (parallel_load_enable) begin
      register <= data_in;
    end else if (shift_enable) begin
      register <= {register[14:0], 1'b0};
    end
  end

  assign data_out = register;

endmodule