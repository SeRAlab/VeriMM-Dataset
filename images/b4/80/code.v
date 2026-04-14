module top_module(
  input [1:0] address,
  input clk,
  input [8:0] in_port,
  input reset_n,
  output reg [31:0] readdata
);// Define memory
  reg [8:0] memory [2:0];

  // Write to memory
  always @(posedge clk) begin
    if (!reset_n) begin
      memory[0] <= 0;
    end else if (address == 2'b00) begin
      memory[0] <= in_port;
    end
  end

  // Read from memory
  always @(posedge clk) begin
    if (!reset_n) begin
      readdata <= 0;
    end else if (address == 2'b01) begin
      readdata <= memory[1];
    end else if (address == 2'b10) begin
      readdata <= memory[2];
    end
  end

endmodule