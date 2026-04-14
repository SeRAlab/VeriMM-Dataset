module top_module(
    
    input         wb_clk_i,
    input         wb_rst_i,
    input  [15:0] wb_dat_i,
    output [15:0] wb_dat_o,
    input         wb_we_i,
    input         wb_adr_i,
    input  [ 1:0] wb_sel_i,
    input         wb_stb_i,
    input         wb_cyc_i,
    output        wb_ack_o,

    
    output [21:0] flash_addr_,
    input  [ 7:0] flash_data_,
    output        flash_we_n_,
    output        flash_oe_n_,
    output        flash_ce_n_,
    output        flash_rst_n_
  );wire        op;
  wire        wr_command;
  reg  [20:0] address;

  wire        word;
  wire        op_word;
  reg         st;
  reg  [ 7:0] lb;

  
  assign op      = wb_stb_i & wb_cyc_i;
  assign word    = wb_sel_i==2'b11;
  assign op_word = op & word & !wb_we_i;

  assign flash_rst_n_ = 1'b1;
  assign flash_we_n_  = 1'b1;
  assign flash_oe_n_  = !op;
  assign flash_ce_n_  = !op;

  assign flash_addr_[21:1] = address;
  assign flash_addr_[0]    = (wb_sel_i==2'b10) | (word & st);
  assign wr_command        = op & wb_we_i;  

  assign wb_ack_o = op & (op_word ? st : 1'b1);
  assign wb_dat_o = wb_sel_i[1] ? { flash_data_, lb }
                                : { 8'h0, flash_data_ };

  
  
  always @(posedge wb_clk_i)
    st <= wb_rst_i ? 1'b0 : op_word;

  
  always @(posedge wb_clk_i)
    lb <= wb_rst_i ? 8'h0 : (op_word ? flash_data_ : 8'h0);

  
  
  
  `define FLASH_ALO   1'h0    
  `define FLASH_AHI   1'h1    
  always @(posedge wb_clk_i)  
    if(wb_rst_i)
      address <= 21'h000000;  
    else
      if(wr_command)          
        case(wb_adr_i)        
            `FLASH_ALO: address[15: 0] <= wb_dat_i;
            `FLASH_AHI: address[20:16] <= wb_dat_i[4:0];
            default:    ;     
        endcase               

endmodule