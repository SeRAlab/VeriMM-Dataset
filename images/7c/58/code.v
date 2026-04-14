module top_module(
  input clk,
  input reset,
  input [data_size-1:0] data_in,
  input [data_size-1:0] poly,
  input [data_size-1:0] crc_in,
  input crc_enable,
  input check_enable,
  output [data_size-1:0] crc_out,
  output match
);parameter data_size = 8; // size of input data message in bits
parameter poly_size = 4; // size of generator polynomial in bits
parameter crc_size = poly_size - 1; // size of checksum in bits

reg [data_size-1:0] data_reg;
reg [crc_size-1:0] crc_reg;
reg [crc_size-1:0] crc_calc;
reg [data_size-1:0] poly_reg;
reg [crc_size-1:0] crc_check;

wire [crc_size-1:0] crc_remainder;
wire [crc_size-1:0] crc_check_remainder;

assign crc_remainder = crc_calc[crc_size-1:0] ^ crc_reg;
assign crc_check_remainder = data_reg[crc_size-1:0] ^ crc_check;

assign crc_out = {data_in, crc_calc};
assign match = (crc_check_remainder == crc_in);

always @(posedge clk) begin
  if (reset) begin
    data_reg <= 0;
    crc_reg <= 0;
    crc_calc <= 0;
    poly_reg <= poly;
    crc_check <= crc_in;
  end else begin
    data_reg <= data_in;
    if (crc_enable) begin
      crc_reg <= crc_calc;
      crc_calc <= {crc_calc[crc_size-2:0], data_reg, 1'b0} ^ (poly_reg & {crc_calc[crc_size-2:0], 1'b0});
    end
    if (check_enable) begin
      crc_check <= {crc_check[crc_size-2:0], data_reg, 1'b0} ^ (poly_reg & {crc_check[crc_size-2:0], 1'b0});
    end
  end
end

endmodule