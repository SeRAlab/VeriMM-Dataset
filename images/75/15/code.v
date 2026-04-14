module top_module(
  input clk,
  input wr_en,
  input [log2n-1:0] wr_addr,
  input [m-1:0] wr_data,
  output reg [m-1:0] rd_data1,
  output reg [m-1:0] rd_data2
);parameter n = 16; // number of registers
parameter m = 8; // number of bits per register

// Calculate log2n directly during elaboration
localparam log2n = $clog2(n); 

reg [m-1:0] regs [n-1:0];

// write operation
always @(posedge clk) begin
  if (wr_en) begin
    regs[wr_addr] <= wr_data;
  end
end

// read operation
always @(*) begin
  rd_data1 = regs[0];
  rd_data2 = regs[1];
end

endmodule