module top_module(
  input [11:0] address_port1,
  input [11:0] address_port2,
  input [15:0] data_in_port1,
  input [15:0] data_in_port2,
  input clock,
  input write_enable_port1,
  input write_enable_port2,
  input output_enable_port1,
  input output_enable_port2,
  output reg [15:0] data_out_port1,
  output reg [15:0] data_out_port2
);reg [15:0] memory [0:4095];

  always @(posedge clock) begin
    if (write_enable_port1) begin
      memory[address_port1] <= data_in_port1;
    end
    if (write_enable_port2) begin
      memory[address_port2] <= data_in_port2;
    end
    if (output_enable_port1) begin
      data_out_port1 <= memory[address_port1];
    end
    if (output_enable_port2) begin
      data_out_port2 <= memory[address_port2];
    end
  end

endmodule