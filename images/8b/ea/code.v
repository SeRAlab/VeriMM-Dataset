module top_module(
  input [n-1:0] addr1,
  input [n-1:0] addr2,
  input [m-1:0] data1,
  input [m-1:0] data2,
  input we1,
  input we2,
  input re1,
  input re2,
  output reg [m-1:0] q1,
  output reg [m-1:0] q2
);parameter n = 8; // number of address bits
parameter m = 16; // number of data bits

reg [m-1:0] mem [0:(1<<n)-1]; // memory array

always @(*) begin
  if (we1) mem[addr1] <= data1;
  if (we2) mem[addr2] <= data2;
  if (re1) q1 <= mem[addr1];
  if (re2) q2 <= mem[addr2];
end

endmodule