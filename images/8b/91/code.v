module top_module(
  input clk,
  input [2:0] addr1,
  input [2:0] addr2,
  input [7:0] data_in,
  input write_en,
  output reg [7:0] data_out1,
  output reg [7:0] data_out2
);reg [7:0] regs [0:7];
  
  always @(*) begin
    // Read operations
    data_out1 = regs[addr1];
    data_out2 = regs[addr2];
  end
  
  always @(posedge clk) begin
    // Write operation
    if (write_en) begin
      regs[addr1] <= data_in;
    end
  end
  
endmodule