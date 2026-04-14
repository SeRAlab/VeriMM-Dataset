module top_module(
  input clk, // Added clock input
  input wr_ena,
  input [log2(depth)-1:0] wr_addr,
  input [width-1:0] wr_data,
  input rd_ena,
  input [log2(depth)-1:0] rd_addr,
  output reg [width-1:0] rd_data // Changed output to reg type
);parameter depth = 1024; // number of memory locations in the block
parameter width = 8; // number of bits in each memory location

function integer log2; // Define the log2 function
  input integer value;
  begin
    value = value - 1;
    for (log2 = 0; value > 0; log2 = log2 + 1)
      value = value >> 1;
  end
endfunction

reg [width-1:0] memory [depth-1:0]; // memory array as an array of registers

// write port
always @(posedge clk) begin
  if (wr_ena) begin
    memory[wr_addr] <= wr_data;
  end
end

// read port
always @(posedge clk) begin
  if (rd_ena) begin
    rd_data <= memory[rd_addr];
  end
end

endmodule