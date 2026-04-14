module top_module(
  input [13:0] address,
  input [15:0] data_in,
  input enable,
  input clock,
  input write,
  output reg [15:0] data_out
);reg [15:0] memory [0:16383];
  reg [15:0] read_data;

  always @(posedge clock) begin
    if (enable) begin
      if (write) begin
        memory[address] <= data_in;
      end else begin
        read_data <= memory[address];
      end
    end
  end

  assign data_out = read_data;

endmodule