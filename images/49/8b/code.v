module top_module(
  input [n-1:0] addr,
  input [m-1:0] data,
  input [k-1:0] control,
  output reg [m-1:0] data_out, // Changed to 'reg'
  output reg flag // Changed to 'reg'
);parameter n = 8; // number of address signals
parameter m = 16; // number of data signals
parameter k = 4; // number of control signals

reg [m-1:0] memory [2**n-1:0]; // memory array
reg write_enable;
reg read_enable;
reg reset;

integer i;

// Write test pattern to memory
always @(posedge control[0]) begin
  if (write_enable) begin
    for (i = 0; i < 2**n; i = i + 1) begin
      memory[i] <= data;
    end
  end
end

// Read data from memory and compare with test pattern
always @(posedge control[1]) begin
  if (read_enable) begin
    flag <= 1;
    for (i = 0; i < 2**n; i = i + 1) begin
      if (memory[i] != data_out) begin
        flag <= 0;
      end
    end
  end
end

// Control signals
assign write_enable = control[2];
assign read_enable = control[3];
assign reset = control[4];

// Memory address decoding
wire [n-1:0] addr_decoded;
assign addr_decoded = addr;

// Memory read and write operations
always @(*) // Changed to continuous assignment for data_out
begin
  data_out = memory[addr_decoded];
end

always @(posedge control[2]) begin
  if (write_enable) begin
    memory[addr_decoded] <= data;
  end
end

endmodule