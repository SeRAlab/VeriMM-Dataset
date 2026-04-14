module top_module(
  input [n-1:0] in,
  output reg [m-1:0] out // Changed from wire to reg
);parameter n = 8; // number of input bits
parameter m = 16; // number of output bits
parameter k = 16; // degree of the generator polynomial

reg [k-1:0] crc_reg;
integer i;

// Generator polynomial
reg [k-1:0] gen_poly = {1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1};

// CRC generator
always @(in) begin
  crc_reg = {in, crc_reg[k-1:n]}; // Initialize CRC register
  for (i = 0; i < n; i = i + 1) begin
    if (crc_reg[k-1] == 1'b1) begin
      crc_reg = crc_reg ^ gen_poly;
    end
    crc_reg = crc_reg << 1;
  end
  out = {in, crc_reg[k-1:n]}; // Adjusted to use correct index range
end

// CRC checker
reg valid;
always @(out) begin
  crc_reg = out;
  for (i = 0; i < m; i = i + 1) begin // Corrected loop range to m
    if (crc_reg[k-1] == 1'b1) begin
      crc_reg = crc_reg ^ gen_poly;
    end
    crc_reg = crc_reg << 1;
  end
  valid = (crc_reg == 0);
end

endmodule