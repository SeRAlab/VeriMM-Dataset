module top_module(data, enable, shift, rst, sync_rst, crc_out, clk, crc_match);input         data;
input         enable;
input         shift;
input         rst;
input         sync_rst;
input         clk;

output        crc_out;
output        crc_match;

reg    [31:0] crc;

wire   [31:0] new_crc;

assign new_crc[0] = data          ^ crc[31];
assign new_crc[1] = data          ^ crc[0]  ^ crc[31];
assign new_crc[2] = data          ^ crc[1]  ^ crc[31];
assign new_crc[3] = crc[2];
assign new_crc[4] = data          ^ crc[3]  ^ crc[31];
assign new_crc[5] = data          ^ crc[4]  ^ crc[31];
assign new_crc[6] = crc[5];
assign new_crc[7] = data          ^ crc[6]  ^ crc[31];
assign new_crc[8] = data          ^ crc[7]  ^ crc[31];
assign new_crc[9] = crc[8];
assign new_crc[10] = data         ^ crc[9]  ^ crc[31];
assign new_crc[11] = data         ^ crc[10] ^ crc[31];
assign new_crc[12] = data         ^ crc[11] ^ crc[31];
assign new_crc[13] = crc[12];
assign new_crc[14] = crc[13];
assign new_crc[15] = crc[14];
assign new_crc[16] = data         ^ crc[15] ^ crc[31];
assign new_crc[17] = crc[16];
assign new_crc[18] = crc[17];
assign new_crc[19] = crc[18];
assign new_crc[20] = crc[19];
assign new_crc[21] = crc[20];
assign new_crc[22] = data         ^ crc[21] ^ crc[31];
assign new_crc[23] = data         ^ crc[22] ^ crc[31];
assign new_crc[24] = crc[23];
assign new_crc[25] = crc[24];
assign new_crc[26] = data         ^ crc[25] ^ crc[31];
assign new_crc[27] = crc[26];
assign new_crc[28] = crc[27];
assign new_crc[29] = crc[28];
assign new_crc[30] = crc[29];
assign new_crc[31] = crc[30];

always @ (posedge clk or posedge rst)
begin
  if(rst)
    crc[31:0] <=  32'hffffffff;
  else if(sync_rst)
    crc[31:0] <=  32'hffffffff;
  else if(enable)
    crc[31:0] <=  new_crc;
  else if (shift)
    crc[31:0] <=  {crc[30:0], 1'b0};
end

assign crc_match = (crc == 32'h0);
assign crc_out = crc[31];

endmodule