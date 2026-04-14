module top_module(
  // inputs:
  ge2_free,
  ge3_free,
  input_tm_cnt,

  // outputs:
  fifo_wrptr_inc
);output  [3:0] fifo_wrptr_inc;
  input   ge2_free;
  input   ge3_free;
  input   [1:0] input_tm_cnt;

  reg [3:0] fifo_wrptr_inc;

  always @*
  begin
    case ({ge3_free, input_tm_cnt})
      2'b11: fifo_wrptr_inc = 3;
      2'b10: if (ge2_free) fifo_wrptr_inc = 2;
              else fifo_wrptr_inc = 0;
      2'b01: fifo_wrptr_inc = 1;
      2'b00: fifo_wrptr_inc = 0;
    endcase
  end

endmodule