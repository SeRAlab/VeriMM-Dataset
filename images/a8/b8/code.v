module top_module(
   // Outputs
   output [7:0] lkup_en_c4_buf, 
   output [7:0] rw_dec_c4_buf,
   output [7:0] rd_en_c4_buf, 
   output [7:0] wr_en_c4_buf, 
   output [7:0] rw_entry_c4_buf, 
   output [15:0] lkup_wr_data_c4_buf, 
   output dir_clear_c4_buf, 
   output inval_mask_c4_buf,
   // Inputs
   input rd_en_c4, 
   input wr_en_c4, 
   input [7:0] inval_mask_c4, 
   input [1:0] rw_row_en_c4, 
   input [3:0] rw_panel_en_c4, 
   input [7:0] rw_entry_c4, 
   input [1:0] lkup_row_en_c4, 
   input [3:0] lkup_panel_en_c4, 
   input [15:0] lkup_wr_data_c4, 
   input dir_clear_c4
   );// Assigning values to the output signals
   assign inval_mask_c4_buf = inval_mask_c4 ;
   assign rd_en_c4_buf = rd_en_c4 ;
   assign wr_en_c4_buf = wr_en_c4 ;
   assign rw_entry_c4_buf = rw_entry_c4 ;
   assign lkup_wr_data_c4_buf = lkup_wr_data_c4 ;

   // Assigning values to the lkup_en_c4_buf signal
   assign lkup_en_c4_buf[0] = lkup_row_en_c4[0] & lkup_panel_en_c4[0] ;
   assign lkup_en_c4_buf[1] = lkup_row_en_c4[0] & lkup_panel_en_c4[1] ;
   assign lkup_en_c4_buf[2] = lkup_row_en_c4[0] & lkup_panel_en_c4[2] ;
   assign lkup_en_c4_buf[3] = lkup_row_en_c4[0] & lkup_panel_en_c4[3] ;
   assign lkup_en_c4_buf[4] = lkup_row_en_c4[1] & lkup_panel_en_c4[0] ;
   assign lkup_en_c4_buf[5] = lkup_row_en_c4[1] & lkup_panel_en_c4[1] ;
   assign lkup_en_c4_buf[6] = lkup_row_en_c4[1] & lkup_panel_en_c4[2] ;
   assign lkup_en_c4_buf[7] = lkup_row_en_c4[1] & lkup_panel_en_c4[3] ;

   // Assigning values to the dir_clear_c4_buf signal
   assign dir_clear_c4_buf = dir_clear_c4 ;

   // Assigning values to the rw_dec_c4_buf signal
   assign rw_dec_c4_buf[0] = rw_row_en_c4[0] & rw_panel_en_c4[0] ;
   assign rw_dec_c4_buf[1] = rw_row_en_c4[0] & rw_panel_en_c4[1] ;
   assign rw_dec_c4_buf[2] = rw_row_en_c4[0] & rw_panel_en_c4[2] ;
   assign rw_dec_c4_buf[3] = rw_row_en_c4[0] & rw_panel_en_c4[3] ;
   assign rw_dec_c4_buf[4] = rw_row_en_c4[1] & rw_panel_en_c4[0] ;
   assign rw_dec_c4_buf[5] = rw_row_en_c4[1] & rw_panel_en_c4[1] ;
   assign rw_dec_c4_buf[6] = rw_row_en_c4[1] & rw_panel_en_c4[2] ;
   assign rw_dec_c4_buf[7] = rw_row_en_c4[1] & rw_panel_en_c4[3] ;

endmodule