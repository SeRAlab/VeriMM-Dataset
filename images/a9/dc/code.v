module top_module(
    
    input  [31:0] wb_dat_i,
    output [31:0] wb_dat_o,
    input  [31:0] wb_adr_i,
    input         wb_we_i,
    input         wb_tga_i,
    input         wb_stb_i,
    input         wb_cyc_i,
    input  [ 1:0] wb_sel_i,
    output        wb_ack_o
  );reg  [7:0] ram[0:4095];
  wire [8:0] index;

  assign index = wb_adr_i[9:0];
  assign wb_ack_o = wb_stb_i & wb_cyc_i;
  assign wb_dat_o = {ram[index],ram[index+1],ram[index+2],ram[index+3]};

endmodule