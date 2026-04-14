module top_module(
  input [n-1:0] data,
  input [m-1:0] search,
  output reg [log2p-1:0] address
);parameter n = 8; // width of data signals
parameter m = 4; // width of search signals
parameter p = 16; // number of words in the memory

integer i;
parameter log2p = $clog2(p);

reg [n-1:0] memory [0:p-1];

// initialize memory with random data
initial begin
  for (i = 0; i < p; i = i + 1) begin
    memory[i] = $random;
  end
end

// search memory for matching data
always @(search) begin
  address = -1;
  for (i = 0; i < p; i = i + 1) begin
    if (memory[i] == search) begin
      address = i;
    end
  end
end

// output error signal if no match found
always @(address) begin
  if (address == -1) begin
    $display("Error: no match found");
  end
end

endmodule