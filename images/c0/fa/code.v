module gfx_wbm_read (clk_i, rst_i,
  cyc_o, stb_o, cti_o, bte_o, we_o, adr_o, sel_o, ack_i, err_i, dat_i, sint_o,
  read_request_i,
  texture_addr_i, texture_sel_i, texture_dat_o, texture_data_ack);
  input             clk_i;    
  input             rst_i;    
  output reg        cyc_o;    
  output            stb_o;    
  output [ 2:0]     cti_o;    
  output [ 1:0]     bte_o;    
  output            we_o;     
  output [31:0]     adr_o;    
  output reg [ 3:0] sel_o;    
  input             ack_i;    
  input             err_i;    
  input [31:0]      dat_i;    
  output        sint_o;     
  input         read_request_i;
  input [31:2]  texture_addr_i;
  input [3:0]   texture_sel_i;
  output [31:0] texture_dat_o;
  output reg    texture_data_ack;
  reg busy;
  assign adr_o  = {texture_addr_i, 2'b00};
  assign texture_dat_o = dat_i;
  assign we_o   = 1'b0;
  assign stb_o  = 1'b1;
  assign sint_o = err_i;
  assign bte_o  = 2'b00;
  assign cti_o  = 3'b000;
  always @(posedge clk_i or posedge rst_i)
  if (rst_i) 
    begin
      texture_data_ack <= 1'b0;
      cyc_o <= 1'b0;
      sel_o <= 4'b1111;
      busy  <= 1'b0;
    end
  else
  begin
    sel_o <= texture_sel_i;
    if(ack_i) 
    begin
      cyc_o            <= 1'b0;
      texture_data_ack <= 1'b1;
      busy             <= 1'b0;
    end
    else if(read_request_i & !texture_data_ack) 
    begin
      cyc_o            <= 1'b1;
      texture_data_ack <= 1'b0;
      busy             <= 1'b1;
    end
    else if(!busy) 
      texture_data_ack <= 1'b0;
  end
endmodule