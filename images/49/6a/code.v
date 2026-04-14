module top_module(
                                                
                                                 clk,
                                                 jrst_n,
                                                 trc_ctrl,
                                                 tw,

                                                
                                                 tracemem_on,
                                                 tracemem_trcdata,
                                                 tracemem_tw,
                                                 trc_im_addr,
                                                 trc_wrap,
                                                 xbrk_wrap_traceoff
                                              )
;output           tracemem_on;
  output  [ 35: 0] tracemem_trcdata;
  output           tracemem_tw;
  output  [  6: 0] trc_im_addr;
  output           trc_wrap;
  output           xbrk_wrap_traceoff;
  input            clk;
  input            jrst_n;
  input   [ 15: 0] trc_ctrl;
  input   [ 35: 0] tw;

  wire             tracemem_on;
  wire    [ 35: 0] tracemem_trcdata;
  wire             tracemem_tw;
  reg     [  6: 0] trc_im_addr ;
  wire    [ 35: 0] trc_im_data;
  wire             trc_on_chip;
  reg              trc_wrap ;
  wire             tw_valid;
  wire             xbrk_wrap_traceoff;
  assign trc_im_data = tw;
  always @(posedge clk or negedge jrst_n)
    begin
      if (jrst_n == 0)
        begin
          trc_im_addr <= 0;
          trc_wrap <= 0;
        end
      else 
        begin
          trc_im_addr <= 0;
          trc_wrap <= 0;
        end
    end


  assign trc_on_chip = ~trc_ctrl[8];
  assign tw_valid = |trc_im_data[35 : 32];
  assign xbrk_wrap_traceoff = trc_ctrl[10] & trc_wrap;
  assign tracemem_trcdata = 0;

endmodule