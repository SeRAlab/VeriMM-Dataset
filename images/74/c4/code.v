module top_module(clk, rst, write_enable, write_reg, write_data, read_reg1, read_reg2, read_data1, read_data2);input clk, rst, write_enable;
  input [4:0] write_reg, read_reg1, read_reg2;
  input [31:0] write_data;
  output [31:0] read_data1, read_data2;

  reg [31:0] register [31:0]; // 32 registers, 32-bit each
  integer i;

  // Synchronous reset
  always @(posedge clk or posedge rst) begin
    if (rst) begin
      for (i = 0; i < 32; i = i + 1) begin
        register[i] <= 32'b0; // Initialize registers to 0
      end
    end else if (write_enable) begin
      register[write_reg] <= write_data; // Write data to register
    end
  end

  // Asynchronous read
  assign read_data1 = (read_reg1 == 0) ? 32'b0 : register[read_reg1];
  assign read_data2 = (read_reg2 == 0) ? 32'b0 : register[read_reg2];
  
endmodule