module top_module(
                                                      
                                                       empty,
                                                       ge2_free,
                                                       ge3_free,
                                                       input_tm_cnt,

                                                      
                                                       fifo_cnt_inc
                                                    )
;output  [  4: 0] fifo_cnt_inc;
  input            empty;
  input            ge2_free;
  input            ge3_free;
  input   [  1: 0] input_tm_cnt;

  reg     [  4: 0] fifo_cnt_inc;
  always @(empty or ge2_free or ge3_free or input_tm_cnt)
    begin
      if (empty)
          fifo_cnt_inc = input_tm_cnt[1 : 0];
      else if (ge3_free & (input_tm_cnt == 3))
          fifo_cnt_inc = 2;
      else if (ge2_free & (input_tm_cnt >= 2))
          fifo_cnt_inc = 1;
      else if (input_tm_cnt >= 1)
          fifo_cnt_inc = 0;
      else 
        fifo_cnt_inc = {5{1'b1}};
    end



endmodule