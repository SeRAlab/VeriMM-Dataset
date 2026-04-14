module top_module(
  input clk,
  input we,
  input [n-1:0] addr,
  input [m-1:0] din,
  output reg [m-1:0] dout // Change 'wire' to 'reg'
);parameter n = 4; // number of address bits
parameter m = 8; // number of data bits
parameter k = 16; // number of memory locations

reg [m-1:0] mem [0:k-1];

always @(posedge clk) begin
  if (we) begin
    mem[addr] <= din;
  end
  else begin
    dout <= mem[addr]; // dout can be assigned since it's declared as reg
  end
end

endmodule