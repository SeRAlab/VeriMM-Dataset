module top_module( immediate_jump, extended_jump );input [25:0] immediate_jump;
  output [31:0] extended_jump;

  assign extended_jump[25] = immediate_jump[25];
  assign extended_jump[26] = immediate_jump[25];
  assign extended_jump[27] = immediate_jump[25];
  assign extended_jump[28] = immediate_jump[25];
  assign extended_jump[29] = immediate_jump[25];
  assign extended_jump[30] = immediate_jump[25];
  assign extended_jump[31] = immediate_jump[25];
  assign extended_jump[24] = immediate_jump[24];
  assign extended_jump[23] = immediate_jump[23];
  assign extended_jump[22] = immediate_jump[22];
  assign extended_jump[21] = immediate_jump[21];
  assign extended_jump[20] = immediate_jump[20];
  assign extended_jump[19] = immediate_jump[19];
  assign extended_jump[18] = immediate_jump[18];
  assign extended_jump[17] = immediate_jump[17];
  assign extended_jump[16] = immediate_jump[16];
  assign extended_jump[15] = immediate_jump[15];
  assign extended_jump[14] = immediate_jump[14];
  assign extended_jump[13] = immediate_jump[13];
  assign extended_jump[12] = immediate_jump[12];
  assign extended_jump[11] = immediate_jump[11];
  assign extended_jump[10] = immediate_jump[10];
  assign extended_jump[9] = immediate_jump[9];
  assign extended_jump[8] = immediate_jump[8];
  assign extended_jump[7] = immediate_jump[7];
  assign extended_jump[6] = immediate_jump[6];
  assign extended_jump[5] = immediate_jump[5];
  assign extended_jump[4] = immediate_jump[4];
  assign extended_jump[3] = immediate_jump[3];
  assign extended_jump[2] = immediate_jump[2];
  assign extended_jump[1] = immediate_jump[1];
  assign extended_jump[0] = immediate_jump[0];

endmodule