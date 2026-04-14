module top_module(
  input [1:0] address,
  input chipselect,
  input clk,
  input reset_n,
  input write_n,
  input [31:0] writedata,
  output reg [7:0] out_port,
  output reg [31:0] readdata
);reg [7:0] data_out;
  reg [31:0] mem [0:3]; // Declare memory array

  always @(posedge clk or negedge reset_n) begin
    if (~reset_n) begin
      data_out <= 0;
      mem[0] <= 0; // Initialize memory contents individually
      mem[1] <= 0;
      mem[2] <= 0;
      mem[3] <= 0;
    end
    else begin
      if (chipselect) begin
        if (~write_n) begin
          mem[address] <= writedata; // Write data to memory
        end
        else begin
          data_out <= mem[address][7:0]; // Read lower 8 bits from memory
        end
      end
      else begin
        data_out <= 0;
      end
    end
  end

  assign out_port = data_out; // Output the data
  assign readdata = mem[address]; // Corrected to just return the mem[address]

endmodule