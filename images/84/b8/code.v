module top_module(
  input [n-1:0] addr_r,
  input [n-1:0] addr_w,
  input [m-1:0] data_in,
  input wr_en,
  input rd_en,
  output reg [m-1:0] data_out // Change wire to reg
);parameter n = 4; // number of address bits
parameter m = 8; // number of data bits
parameter k = 16; // number of registers

reg [m-1:0] registers [0:k-1];

always @ (posedge wr_en) begin
  registers[addr_w] <= data_in;
end

always @ (posedge rd_en) begin
  data_out <= registers[addr_r]; // data_out is now a valid l-value
end

endmodule