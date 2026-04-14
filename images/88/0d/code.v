module top_module(
  input [width-1:0] data_in,
  input reset,
  input enable,
  output [width-1:0] data_out,
  output error,
  output reg [width-1:0] crc_out
);parameter width = 8; // number of bits in the data word and CRC code
parameter poly = 9'h8; // selected CRC polynomial (x^8 + x^2 + x + 1) as a hexadecimal value

reg [width-1:0] crc_reg;
reg [width-1:0] crc_gen;

assign data_out = data_in;

always @(posedge enable or posedge reset) begin
  if (reset) begin
    crc_reg <= {width{1'b0}};
    crc_gen <= {width{1'b0}};
  end
  else if (enable) begin
    crc_reg <= crc_gen;
    crc_gen <= {crc_reg[width-2:0], 1'b0} ^ (crc_reg[width-1] ? poly : {width{1'b0}});
  end
end

assign crc_out = crc_gen;
assign error = (crc_out != crc_gen);

endmodule