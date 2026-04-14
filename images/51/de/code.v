module top_module(
  input clk,
  input reset,
  input load,
  input [3:0] data_in,
  output [3:0] data_out
);reg [3:0] reg_data;

  always @(posedge clk or negedge reset) begin
    if (reset == 0) begin
      reg_data <= 4'b0000;
    end
    else if (load == 1) begin
      reg_data <= data_in;
    end
  end

  assign data_out = reg_data;

endmodule