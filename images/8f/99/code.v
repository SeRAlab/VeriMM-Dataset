module top_module(
  input clk,
  input rst,
  input read_en,
  input [7:0] addr,
  input [7:0] data_in,
  output reg [7:0] data_out, // Changed to reg type
  output read_ok
);parameter mem_size = 64; // size of memory region to be protected
parameter mem_start = 128; // starting address of memory region to be protected

reg [7:0] memory [mem_start + mem_size - 1:mem_start]; // define memory region

assign read_ok = (addr >= mem_start) && (addr < mem_start + mem_size); // check if address is within memory region

always @(posedge clk) begin
  if (rst) begin
    data_out <= 0;
  end else begin
    if (read_en && read_ok) begin
      data_out <= memory[addr - mem_start];
    end else begin
      data_out <= 0;
    end
  end
end

endmodule