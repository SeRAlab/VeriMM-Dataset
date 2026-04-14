module top_module(
  input clk,
  input [n-1:0] addr,
  input [m-1:0] data_in,
  input [p-1:0] wr_en,
  input [p-1:0] rd_en,
  output reg [m-1:0] data_out, // Changed to reg as it is assigned in an always block
  output reg busy // Changed to reg as it is assigned in an always block
);parameter n = 8; // number of address bits
parameter m = 16; // number of data bits
parameter p = 2; // number of ports

reg [m-1:0] mem [0:(2**n)-1]; // memory array

integer i; // loop variable

always @(posedge clk) begin
  // write logic
  for (i = 0; i < p; i = i + 1) begin
    if (wr_en[i]) begin
      mem[addr] <= data_in;
    end
  end
  
  // read logic
  data_out <= mem[addr];
  
  // busy signal logic
  busy <= 0;
  for (i = 0; i < p; i = i + 1) begin
    if (wr_en[i] || rd_en[i]) begin
      busy <= 1;
    end
  end
end

endmodule