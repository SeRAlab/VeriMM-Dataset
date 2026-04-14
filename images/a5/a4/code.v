module top_module(
  input [n-1:0] addr,
  input [m-1:0] ctrl,
  output reg mem_en // Declare mem_en as reg output
);parameter n = 4; // number of address signals
parameter m = 2; // number of control signals
parameter memory_size = 1024; // size of the memory block to be protected.

always @(*) begin
  if (addr < memory_size && ctrl[0] && !ctrl[1]) begin
    mem_en = 1;
  end else begin
    mem_en = 0;
  end
end

endmodule