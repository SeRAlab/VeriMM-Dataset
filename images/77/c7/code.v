module top_module(
  input clk,
  input [31:0] addr, writeData,
  input memWrite, memRead,
  output [31:0] readData
);reg [31:0] mem [0:255];  
  
  always @(posedge clk) begin 
    if(memWrite)
      mem[addr] <= writeData;
  end

  assign readData = memRead ? mem[addr] : 0;
endmodule