module top_module(
  input [31:0] addr,
  input [7:0] write_en,
  output reg [7:0] data_out, // Changed to reg to match driver
  input clk // Added clk input
);parameter n = 2; // number of input signals
parameter m = 1; // number of output signals
parameter mem_size = 1024; // size of memory block
parameter blk_size = 64; // size of protection blocks

reg [7:0] mem [0:mem_size-1]; // memory block
reg [7:0] prot_codes [0:mem_size/blk_size-1]; // protection codes for each block
reg [7:0] auth_code = 8'hAB; // authorization code

integer blk_num; // block number for the accessed address

always @(*) begin
  blk_num = addr / blk_size;
end

always @(*) begin
  data_out = mem[addr]; // Updated to a blocking assignment
end

always @(posedge clk) begin
  if (write_en) begin
    if (prot_codes[blk_num] == auth_code) begin
      mem[addr] <= write_en; // Memory write operation
    end
  end
end

endmodule