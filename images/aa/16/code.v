module top_module(
  clka,
  wea,
  addra,
  dina,
  douta
);input clka;
input [3 : 0] wea;
input [7 : 0] addra;
input [31 : 0] dina;
output reg [31 : 0] douta; // Changed to reg type for output

reg [31:0] mem [255:0]; // 256 x 32-bit memory array

always @(posedge clka) begin
  if (wea) begin
    // Write operation
    if (wea[0]) mem[addra] <= dina; // Byte Write Enable 0
    if (wea[1]) mem[addra + 1] <= dina; // Byte Write Enable 1
    if (wea[2]) mem[addra + 2] <= dina; // Byte Write Enable 2
    if (wea[3]) mem[addra + 3] <= dina; // Byte Write Enable 3
  end
  douta <= mem[addra]; // Read operation
end

endmodule