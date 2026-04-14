module top_module(
  clka,
  wea,
  addra,
  dina,
  douta
);input clka;
input [0 : 0] wea;
input [5 : 0] addra;
input [31 : 0] dina;
output reg [31 : 0] douta; // Changed output to reg to allow assignments

// Declare a memory array to represent the block memory
reg [31:0] memory_array [0:63]; // 64 entries of 32-bit wide memory

// Memory write operation
always @(posedge clka) begin
  if (wea) begin
    memory_array[addra] <= dina; // Write data to memory
  end
end

// Memory read operation
always @(posedge clka) begin
  douta <= memory_array[addra]; // Read data from memory
end

endmodule