module top_module(
    
    input         wb1_clk_i,
    input         wb1_rst_i,
    input  [15:0] wb1_dat_i,
    output [15:0] wb1_dat_o,
    input  [19:1] wb1_adr_i,
    input         wb1_we_i,
    input  [ 1:0] wb1_sel_i,
    input         wb1_stb_i,
    input         wb1_cyc_i,
    output        wb1_ack_o,
    
    
    input         wb2_clk_i,
    input         wb2_rst_i,
    input  [15:0] wb2_dat_i,
    output [15:0] wb2_dat_o,
    input  [19:1] wb2_adr_i,
    input         wb2_we_i,
    input  [ 1:0] wb2_sel_i,
    input         wb2_stb_i,
    input         wb2_cyc_i,
    output        wb2_ack_o
  );reg  [15:0] ram1[0:2**19-1];
  reg  [15:0] ram2[0:2**19-1];

  wire       we1;
  wire [7:0] bhw1, blw1;
  
  wire       we2;
  wire [7:0] bhw2, blw2;

  
  assign wb1_dat_o = ram1[wb1_adr_i];
  assign wb1_ack_o = wb1_stb_i;
  assign we1       = wb1_we_i & wb1_stb_i & wb1_cyc_i;
  
  assign wb2_dat_o = ram2[wb2_adr_i];
  assign wb2_ack_o = wb2_stb_i;
  assign we2       = wb2_we_i & wb2_stb_i & wb2_cyc_i;

  assign bhw1 = wb1_sel_i[1] ? wb1_dat_i[15:8]
                           : ram1[wb1_adr_i][15:8];
  assign blw1 = wb1_sel_i[0] ? wb1_dat_i[7:0]
                           : ram1[wb1_adr_i][7:0];

  assign bhw2 = wb2_sel_i[1] ? wb2_dat_i[15:8]
                           : ram2[wb2_adr_i][15:8];
  assign blw2 = wb2_sel_i[0] ? wb2_dat_i[7:0]
                           : ram2[wb2_adr_i][7:0];

  
  always @(posedge wb1_clk_i)
    begin
      if (we1) ram1[wb1_adr_i] <= { bhw1, blw1 };
      if (we1) ram2[wb1_adr_i] <= { bhw1, blw1 };
    end

  always @(posedge wb2_clk_i)
    begin
      if (we2) ram1[wb2_adr_i] <= { bhw2, blw2 };
      if (we2) ram2[wb2_adr_i] <= { bhw2, blw2 };
    end

endmodule