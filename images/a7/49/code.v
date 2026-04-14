module top_module(
  input data,
  input enable_crc,
  input reset,
  input sync_reset_crc,
  input clk,
  output reg [7:0] crc_out
);// polynomial: (0 1 2 8)
  // data width: 1
  function [7:0] nextCRC8_D1;
    input data;
    input [7:0] crc;

    reg [0:0] d;
    reg [7:0] c;
    reg [7:0] new_crc;

    begin
      d[0] = data;
      c = crc;

      new_crc[0] = d[0] ^ c[7];
      new_crc[1] = d[0] ^ c[0] ^ c[7];
      new_crc[2] = d[0] ^ c[1] ^ c[7];
      new_crc[3] = c[2];
      new_crc[4] = c[3];
      new_crc[5] = c[4];
      new_crc[6] = c[5];
      new_crc[7] = c[6];

      nextCRC8_D1 = new_crc;
    end
  endfunction

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      crc_out <= 0;
    end else if (sync_reset_crc) begin
      crc_out <= 0;
    end else if (enable_crc) begin
      crc_out <= nextCRC8_D1(data, crc_out);
    end
  end

endmodule