module top_module(
  clka,
  wea,
  addra,
  dina,
  douta
);input clka;
input [0 : 0] wea;
input [9 : 0] addra;
input [7 : 0] dina;
output [7 : 0] douta;

// Use a generic RAM module instead of missing BLK_MEM_GEN_V7_3
reg [7:0] memory [0:1023]; // 1KB memory

always @(posedge clka) begin
  if (wea) begin
    memory[addra] <= dina; // Write to memory on write enable
  end
end

assign douta = memory[addra]; // Read from memory

endmodule