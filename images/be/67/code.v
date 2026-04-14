module top_module(
  input ge2_free,
  input ge3_free,
  input [1:0] input_tm_cnt,
  output reg [3:0] fifo_wrptr_inc  // Changed to reg to allow assignment in always block
);always @* begin
    if (ge3_free && (input_tm_cnt == 2'b11))
      fifo_wrptr_inc = 4'b0011;
    else if (ge2_free && (input_tm_cnt >= 2))
      fifo_wrptr_inc = 4'b0010;
    else if (input_tm_cnt >= 1)
      fifo_wrptr_inc = 4'b0001;
    else
      fifo_wrptr_inc = 4'b0000;
  end

endmodule