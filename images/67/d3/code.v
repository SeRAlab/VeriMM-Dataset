module top_module(
    
    input             wb_clk_i,
    input             wb_rst_i,
    input      [15:0] wb_dat_i,
    output     [15:0] wb_dat_o,
    input      [16:1] wb_adr_i,
    input             wb_we_i,
    input             wb_tga_i,
    input             wb_stb_i,
    input             wb_cyc_i,
    output reg        wb_ack_o,

    
    output reg [20:0] flash_addr_,
    input      [15:0] flash_data_,
    output            flash_we_n_,
    output reg        flash_ce2_
  );reg  [11:0] base;
  wire        op;
  wire        opbase;

  
  assign wb_dat_o    = flash_data_;
  assign flash_we_n_ = 1'b1;
  assign op          = wb_cyc_i & wb_stb_i;
  assign opbase      = op & wb_tga_i & wb_we_i;

  
  
  always @(posedge wb_clk_i)
    flash_addr_ <= wb_tga_i ? { 1'b1, base, wb_adr_i[8:1] }
                            : { 5'h0, wb_adr_i[16:1] };

  always @(posedge wb_clk_i) flash_ce2_ <= op;
  always @(posedge wb_clk_i) wb_ack_o   <= op;

  
  always @(posedge wb_clk_i)
    base <= wb_rst_i ? 12'h0: ((opbase) ? wb_dat_i[11:0] : base);
endmodule