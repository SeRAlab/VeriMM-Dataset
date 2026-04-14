module top_module(
                                                            
                                                             empty,
                                                             free2,
                                                             free3,
                                                             tm_count,

                                                            
                                                             fifocount_inc
                                                          )
;output  [  4: 0] fifocount_inc;
  input            empty;
  input            free2;
  input            free3;
  input   [  1: 0] tm_count;

  reg     [  4: 0] fifocount_inc;
  always @(empty or free2 or free3 or tm_count)
    begin
      if (empty)
          fifocount_inc = tm_count[1 : 0];
      else if (free3 & (tm_count == 3))
          fifocount_inc = 2;
      else if (free2 & (tm_count >= 2))
          fifocount_inc = 1;
      else if (tm_count >= 1)
          fifocount_inc = 0;
      else 
        fifocount_inc = {5{1'b1}};
    end



endmodule