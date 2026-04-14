module top_module(
  input clk,
  input reset,
  input request,
  input [31:0] address,
  input rw,
  input [31:0] data_in,
  output [31:0] data_out,
  output valid
);reg [31:0] memory [0:1023]; // 4KB memory
  reg [31:0] read_data;
  reg valid_out;

  always @(posedge clk) begin
    if (reset) begin
      valid_out <= 0;
    end else begin
      if (request) begin
        if (rw) begin // write
          memory[address] <= data_in;
        end else begin // read
          read_data <= memory[address];
          valid_out <= 1;
        end
      end else begin
        valid_out <= 0;
      end
    end
  end

  assign data_out = read_data;
  assign valid = valid_out;

endmodule