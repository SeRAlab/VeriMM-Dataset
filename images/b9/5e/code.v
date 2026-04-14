module top_module(
  input clk,
  input [3:0] data_in,
  output [3:0] data_out
);reg [3:0] pipe_reg [0:3];

  always @(posedge clk) begin
    pipe_reg[0] <= data_in;
    pipe_reg[1] <= pipe_reg[0];
    pipe_reg[2] <= pipe_reg[1];
    pipe_reg[3] <= pipe_reg[2];
  end

  assign data_out = pipe_reg[3];

endmodule