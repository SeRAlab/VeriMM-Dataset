module top_module(
  input clk,
  input [31:0] data_in,
  output reg [15:0] crc_out
);reg [15:0] crc_reg = 16'hFFFF;
  reg [31:0] data_reg;
  reg [3:0] i;

  always @(posedge clk) begin
    data_reg <= data_in;
    crc_reg <= crc_reg ^ data_reg;
    for (i = 0; i < 32; i = i + 1) begin
      if (crc_reg[15] == 1) begin
        crc_reg <= {crc_reg[14:0], crc_reg[15]} ^ 16'hA001;
      end else begin
        crc_reg <= {crc_reg[14:0], crc_reg[15]};
      end
    end
    crc_out <= crc_reg;
  end

endmodule