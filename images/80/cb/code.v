module top_module(Data_i,
    select_i,
    Data_o);input [25:0]Data_i;
  input select_i;
  output [25:0]Data_o;

  wire [25:0]Data_i;
  wire [25:0]Data_o;
  wire select_i;

  assign Data_o[0] = select_i ? Data_i[25] : Data_i[1];
  assign Data_o[1] = select_i ? Data_i[0] : Data_i[2];
  assign Data_o[2] = select_i ? Data_i[1] : Data_i[3];
  assign Data_o[3] = select_i ? Data_i[2] : Data_i[4];
  assign Data_o[4] = select_i ? Data_i[3] : Data_i[5];
  assign Data_o[5] = select_i ? Data_i[4] : Data_i[20];
  assign Data_o[6] = select_i ? Data_i[19] : Data_i[7];
  assign Data_o[7] = select_i ? Data_i[6] : Data_i[8];
  assign Data_o[8] = select_i ? Data_i[7] : Data_i[9];
  assign Data_o[9] = select_i ? Data_i[8] : Data_i[16];
  assign Data_o[10] = select_i ? Data_i[15] : Data_i[11];
  assign Data_o[11] = select_i ? Data_i[10] : Data_i[12];
  assign Data_o[12] = select_i ? Data_i[11] : Data_i[13];
  assign Data_o[13] = select_i ? Data_i[12] : Data_i[14];
  assign Data_o[14] = select_i ? Data_i[13] : Data_i[23];
  assign Data_o[15] = select_i ? Data_i[22] : Data_i[16];
  assign Data_o[16] = select_i ? Data_i[9] : Data_i[17];
  assign Data_o[17] = select_i ? Data_i[8] : Data_i[18];
  assign Data_o[18] = select_i ? Data_i[7] : Data_i[19];
  assign Data_o[19] = select_i ? Data_i[6] : Data_i[20];
  assign Data_o[20] = select_i ? Data_i[5] : Data_i[21];
  assign Data_o[21] = select_i ? Data_i[4] : Data_i[22];
  assign Data_o[22] = select_i ? Data_i[3] : Data_i[23];
  assign Data_o[23] = select_i ? Data_i[2] : Data_i[24];
  assign Data_o[24] = select_i ? Data_i[1] : Data_i[25];
  assign Data_o[25] = select_i ? Data_i[0] : Data_i[24];
endmodule