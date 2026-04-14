module fifo_write_ptr_inc (
  input ge2_free,
  input ge3_free,
  input [1:0] input_tm_cnt,
  output reg [3:0] fifo_wrptr_inc
);

  always @*
    case ({ge3_free, input_tm_cnt})
      2'b11: fifo_wrptr_inc = 3;
      2'b10: if (ge2_free) fifo_wrptr_inc = 2;
              else fifo_wrptr_inc = 1;
      2'b01: fifo_wrptr_inc = 1;
      default: fifo_wrptr_inc = 0;
    endcase

endmodule