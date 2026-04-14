module top_module(
  input [n-1:0] in,
  output reg [m-1:0] out // Changed wire to reg
);parameter n = 3; // number of input signals
parameter m = 2; // number of output signals
parameter w = 8; // width of memory block (in bits)

reg [w-1:0] memory [0:(2**n)-1];

always @(*) begin
  out = memory[in];
end

endmodule