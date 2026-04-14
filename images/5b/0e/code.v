module top_module(
  input clk,
  input rst_n,
  input data_in,
  input data_valid,
  output reg [31:0] crc_out
);parameter POLY = 32'h04C11DB7; // CRC polynomial
  parameter WIDTH = 32; // CRC width
  parameter INIT = 32'hFFFFFFFF; // CRC initial value
  parameter REF_IN = 1; // CRC input data is reflected
  parameter REF_OUT = 1; // CRC output is reflected
  parameter XOR_OUT = 32'hFFFFFFFF; // Final CRC value is XORed with this value

  reg [WIDTH-1:0] crc_reg;
  wire [WIDTH-1:0] crc_next;
  wire [WIDTH-1:0] data;

  assign data = (REF_IN) ? {32{data_in}} : {{32{data_in}}};

  always @(posedge clk) begin
    if (!rst_n) begin
      crc_reg <= INIT;
    end else if (data_valid) begin
      crc_reg <= crc_next;
    end
  end

  assign crc_out = (REF_OUT) ? ~crc_reg ^ XOR_OUT : crc_reg ^ XOR_OUT;

  genvar i;
  generate
    for (i = 0; i < WIDTH; i = i + 1) begin : BIT_LOOP
      assign crc_next[i] = (crc_reg[i+1:0] == 0) ? data[i] : crc_reg[i+1:0] ^ POLY;
    end
  endgenerate

endmodule